defmodule Formtool.FormsTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Formtool.Repo
  alias Formtool.Forms.Form

  @basic_form %{
    uuid: Ecto.UUID.dump!("9e2e5f01-f267-46b7-90c3-c71f49e7186a"),
    title: "Test form",
    description: "A short description"
  }

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  def form_fixture(attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        title: "Title"
      })

    {:ok, form} =
      %Form{}
      |> Form.changeset(attrs)
      |> Repo.insert()

    form
  end

  describe "Form" do
    test "creating and updating" do
      form = form_fixture(@basic_form)

      assert form.description == "A short description"

      {:ok, form} =
        form
        |> Form.changeset(%{description: "A longer description"})
        |> Repo.update()

      assert form.description == "A longer description"
    end

    test "error if no title is given" do
      {:error, changeset} =
        %Form{}
        |> Form.changeset(%{})
        |> Repo.insert()

      assert Keyword.has_key?(changeset.errors, :title) == true
    end

    test "UUID is created automatically if not given" do
      {:ok, form} =
        %Form{}
        |> Form.changeset(%{title: "With UUID"})
        |> Repo.insert()

      assert {:ok, _} = Ecto.UUID.dump(form.uuid)
    end

    test "UUID on form is unique" do
      {:ok, form} =
        %Form{}
        |> Form.changeset(%{title: "With UUID"})
        |> Repo.insert()

      assert {:ok, uuid} = Ecto.UUID.dump(form.uuid)

      {:error, changeset} =
        %Form{}
        |> Form.changeset(%{title: "With same UUID", uuid: uuid})
        |> Repo.insert()

      assert Keyword.has_key?(changeset.errors, :uuid) == true
    end

    test "find by UUID" do
      uuid_string = "4a160de7-ed2a-49fb-8b9a-4e36fb76199b"
      uuid = Ecto.UUID.dump!(uuid_string)
      form1 = form_fixture(%{title: "By UUID", uuid: uuid})

      form2 = Repo.get_by!(Form, uuid: uuid)

      assert form1.id == form2.id
      assert form2.title == "By UUID"
    end
  end
end
