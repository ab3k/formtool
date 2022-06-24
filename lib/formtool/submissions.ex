defmodule Formtool.Submissions do
  @moduledoc """
  The Submissions context.
  """

  alias Ecto.Changeset
  alias Formtool.Forms
  alias Formtool.Forms.Form
  alias Formtool.Submissions.Submission

  def start_submission(%Form{} = form) do
    submission = Submission.new(form.uuid)
    {:ok, _pid} = Formtool.Submissions.Supervisor.start_child(submission)
    {:ok, submission}
  end

  def get_submission(submission_id) do
    case Registry.lookup(registry_name(), submission_id) do
      [{pid, _}] ->
        Formtool.Submissions.Child.get_submission(pid)

      [] ->
        {:error, "not found"}
    end
  end

  def merge_data(submission_id, data) do
    case Registry.lookup(registry_name(), submission_id) do
      [{pid, _}] ->
        Formtool.Submissions.Child.merge(pid, data)

      [] ->
        {:error, "not found"}
    end
  end

  def finish_submission(submission_id) do
    case Registry.lookup(registry_name(), submission_id) do
      [{pid, _}] ->
        Formtool.Submissions.Child.finish(pid)

      [] ->
        {:error, "not found"}
    end
  end

  def get_changeset_and_permitted(submission) do
    {:ok, form_map} = Forms.serialize_by_uuid(submission.form_uuid)

    data = %{}
    types = types_from_map(form_map)

    {:ok, Changeset.change({data, types}), Map.keys(types)}
  end

  defp types_from_map(%{"components" => components} = _form_map) do
    for component <- components, into: %{} do
      {String.to_atom(component["name"]), type_for_component(component["type"])}
    end
  end

  defp registry_name(), do: Formtool.Submissions.Registry

  defp type_for_component("text"), do: :string
  defp type_for_component("email"), do: :string
end
