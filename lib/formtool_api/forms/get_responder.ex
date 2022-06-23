defmodule FormtoolApi.Forms.GetResponder do
  @moduledoc false
  import Plug.Conn

  def respond(conn, result) do
    {status_code, data} = response_for(result)
    json = Jason.encode!(data)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status_code, json)
  end

  defp response_for({:ok, form}) do
    {200,
     %{
       form: %{
         uuid: form.uuid,
         title: form.title,
         description: form.description,
         config: form.config,
         components:
           Enum.map(form.components, fn c ->
             %{
               uuid: c.uuid,
               type: c.type,
               name: c.name,
               config: c.config,
               weight: c.weight
             }
           end)
       }
     }}
  end

  defp response_for({:error, :not_found}), do: {404, %{msg: "not found"}}
  defp response_for({:error, :not_an_uuid}), do: {400, %{msg: "not an UUID"}}
  defp response_for(_), do: {400, %{msg: "error"}}
end
