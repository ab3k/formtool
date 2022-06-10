defmodule Formtool.RouterTest do
  @moduledoc """
  Tests for the Formtool routes.
  """
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Formtool.Router.init([])

  test "GET / returns ok" do
    # Create a test connection
    conn = conn(:get, "/")

    # Invoke the plug
    conn = Formtool.Router.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "ok"
  end

  test "GET /ping returns pong" do
    conn = conn(:get, "/ping")

    conn = Formtool.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "pong"
  end
end
