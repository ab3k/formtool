defmodule Formtool.Submissions.Child do
  @moduledoc false
  use GenServer

  alias Formtool.Submissions.Submission

  ## Client API

  def start_link(opts) do
    submission = Keyword.get(opts, :submission)
    name = {:via, Registry, {Formtool.Submissions.Registry, submission.id}}

    GenServer.start_link(__MODULE__, submission, name: name)
  end

  def get_submission(server_or_id) do
    GenServer.call(server_for_submission(server_or_id), :get_submission)
  end

  def merge(server_or_id, data) do
    GenServer.call(server_for_submission(server_or_id), {:merge, data})
  end

  def finish(server_or_id) do
    GenServer.call(server_for_submission(server_or_id), :finish)
  end

  def finished?(server_or_id) do
    GenServer.call(server_for_submission(server_or_id), :finished?)
  end

  ## Callbacks

  @impl true
  def init(%Submission{} = submission) do
    {:ok, %{finished?: false, data: %{}, submission: submission}}
  end

  @impl true
  def handle_call(:get_submission, _from, state) do
    {:reply, {:ok, state.submission}, state}
  end

  @impl true
  def handle_call({:merge, new_data}, _from, %{data: data} = state) do
    data = Map.merge(data, new_data)
    {:reply, {:ok, data}, %{state | data: data}}
  end

  @impl true
  def handle_call(:finish, _from, state) do
    {:reply, {:ok, state.data}, %{state | finished?: true}, {:continue, :do_finish}}
  end

  @impl true
  def handle_call(:finished?, _from, state) do
    {:reply, state.finished?, state}
  end

  @impl true
  def handle_continue(:do_finish, state) do
    {:stop, :normal, state}
  end

  defp server_for_submission(server) when is_binary(server) do
    {:via, Registry, {Formtool.Submissions.Registry, server}}
  end

  defp server_for_submission(server) do
    server
  end
end
