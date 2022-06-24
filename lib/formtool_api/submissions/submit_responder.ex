defmodule FormtoolApi.Submissions.SubmitResponder do
  @moduledoc false

  require Logger
  import Plug.Conn

  def respond(conn, result) do
    {status_code, data} = response_for(result)
    json = Jason.encode!(data)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status_code, json)
  end

  defp response_for({:ok, data}) do
    {200, %{msg: "submitted", data: data}}
  end

  defp response_for({:error, %Ecto.Changeset{} = changeset}) do
    {400, %{msg: "error", errors: changeset.errors}}
  end

  defp response_for(_), do: {400, %{msg: "error"}}
end
