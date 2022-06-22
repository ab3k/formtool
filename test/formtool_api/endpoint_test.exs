defmodule FormtoolApi.EndpointTest do
  @moduledoc """
  Tests for the Formtool endpoint.
  """
  use ExUnit.Case, async: true
  use Plug.Test

  alias FormtoolApi.Endpoint

  @opts Endpoint.init([])

  test "GET / returns ok" do
    # Create a test connection
    conn = conn(:get, "/")

    # Invoke the plug
    conn = Endpoint.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "ok"
  end

  test "GET /ping returns pong" do
    conn = conn(:get, "/ping")

    conn = Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "pong"
  end

  test "GET /does-not-exist responses with 404 status" do
    conn = conn(:get, "/does-not-exist")

    conn = Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "not found"
  end

  test "GET /div/2/1 returns 0.5" do
    conn = conn(:get, "/div/1/2")

    conn = Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "0.5"
  end

  # There is no actual HTTP request/response, because we are
  # unit testing a Plug. We therefore need to assert Plug specific
  # state and cannot assert on a HTTP response content.
  test "GET /div/1/0 responses with 500 status" do
    conn = conn(:get, "/div/1/0")

    # call the Plug and expect a wrapped exception
    assert_raise Plug.Conn.WrapperError, fn ->
      Endpoint.call(conn, @opts)
    end

    # Plug deals with the blown up request and sends a message to the caller
    # (us). Then we can retrieve the response-to-be-sent from the Plug.Conn.
    assert_received {:plug_conn, :sent}
    assert {500, _headers, "Something went wrong"} = sent_resp(conn)
  end

  test "GET /div/no/integers responses with 400 status" do
    conn = conn(:get, "/div/no/integers")

    conn = Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 400
    assert conn.resp_body == "bad data"
  end
end
