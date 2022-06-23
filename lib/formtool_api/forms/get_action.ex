defmodule FormtoolApi.Forms.GetAction do
  @moduledoc false

  @defaults [responder: FormtoolApi.Forms.GetResponder]

  def init(opts \\ []) do
    @defaults
    |> Keyword.merge(opts)
  end

  def call(conn, opts) do
    responder = Keyword.fetch!(opts, :responder)

    result =
      with %{"uuid" => raw_uuid} <- conn.path_params,
           {:ok, uuid} <- Ecto.UUID.cast(raw_uuid),
           {:ok, form} <- Formtool.Forms.get_form_by_uuid(uuid) do
        {:ok, form}
      else
        {:error, :not_found} -> {:error, :not_found}
        :error -> {:error, :not_an_uuid}
        _ -> :error
      end

    conn
    |> responder.respond(result)
  end
end
