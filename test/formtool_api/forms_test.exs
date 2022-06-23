defmodule FormtoolApi.FormsTest do
  @moduledoc """
  Tests for the Formtool routes.
  """
  use ExUnit.Case, async: true
  use Plug.Test

  alias Formtool.Forms.{Form, Component}
  alias Formtool.Repo
  alias FormtoolApi.FormsRouter, as: Router

  @opts Router.init([])

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  setup do
    {:ok, form} =
      %Form{}
      |> Form.changeset(%{
        title: "Test form",
        description: "A short description",
        config: %{}
      })
      |> Repo.insert()

    {:ok, _component} =
      %Component{}
      |> Component.changeset(%{
        form_id: form.id,
        type: "text",
        name: "test"
      })
      |> Repo.insert()

    %{form: form}
  end

  describe "GET a form" do
    test "with the UUID" do
      conn = conn(:get, "/not-an-uuid")

      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 400
      assert Enum.member?(conn.resp_headers, {"content-type", "application/json; charset=utf-8"})
      assert Jason.decode!(conn.resp_body) == %{"msg" => "not an UUID"}
    end

    test "with a non-existing UUID" do
      non_existing_uuid = "572ddce4-44bc-445f-a630-20f45807df2b"
      conn = conn(:get, "/#{non_existing_uuid}")

      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 404
      assert Enum.member?(conn.resp_headers, {"content-type", "application/json; charset=utf-8"})
      assert Jason.decode!(conn.resp_body) == %{"msg" => "not found"}
    end

    test "GET / returns ok", %{form: form} do
      uuid = form.uuid
      conn = conn(:get, "/#{uuid}")

      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200
      assert Enum.member?(conn.resp_headers, {"content-type", "application/json; charset=utf-8"})

      assert %{
               "form" => %{
                 "components" => [
                   %{
                     "uuid" => _,
                     "config" => %{},
                     "name" => "test",
                     "type" => "text",
                     "weight" => 0
                   }
                 ],
                 "config" => %{},
                 "description" => "A short description",
                 "title" => "Test form",
                 "uuid" => ^uuid
               }
             } = Jason.decode!(conn.resp_body)
    end
  end
end
