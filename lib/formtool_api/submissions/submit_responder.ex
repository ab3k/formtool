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

defmodule TupleEncoder do
  alias Jason.Encoder

  defimpl Encoder, for: Tuple do
    def encode(data, options) when is_tuple(data) do
      data
      |> Tuple.to_list()
      |> Encoder.List.encode(options)
    end
  end
end
