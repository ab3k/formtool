defmodule Formtool.Router do
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
    %{"x" => dividend, "y" => divisor} = conn.path_params

    result =
      with {x, _} <- Integer.parse(dividend),
           {y, _} <- Integer.parse(divisor) do
        x / y
      end

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, Float.to_string(result))
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
