defmodule FormtoolApi.Endpoint do
  @moduledoc false

  use Plug.Router
  use Plug.ErrorHandler

  plug(:match)
  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "ok")
  end

  get "/ping" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "pong")
  end

  get "/div/:x/:y" do
    conn =
      conn
      |> put_resp_content_type("text/plain")

    case Formtool.divide_strings(conn.path_params) do
      :error -> send_resp(conn, 400, "bad data")
      result -> send_resp(conn, 200, Float.to_string(result))
    end
  end

  match _ do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(404, "not found")
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    # A response is send and the error is re-raised
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(conn.status, "Something went wrong")
  end
end
