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

  test "GET /does-not-exist responses with 404 status" do
    conn = conn(:get, "/does-not-exist")

    conn = Formtool.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "not found"
  end

  test "GET /div/2/1 returns 0.5" do
    conn = conn(:get, "/div/1/2")

    conn = Formtool.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "0.5"
  end

  test "GET /div/1/0 responses with 500 status" do
    conn = conn(:get, "/div/1/0")

    conn = Formtool.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 500
    assert conn.resp_body == "Something went wrong"
  end
end
