defmodule Formtool.FormsTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Formtool.Repo
  alias Formtool.Forms.{Component, Form}

  @basic_form %{
    uuid: Ecto.UUID.dump!("9e2e5f01-f267-46b7-90c3-c71f49e7186a"),
    title: "Test form",
    description: "A short description",
    config: %{}
  }

  @valid_component_types Component.__component_types__()

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

  def component_fixture(%Form{} = form, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        form_id: form.id,
        type: "text",
        weight: 1
      })

    {:ok, component} =
      %Component{}
      |> Component.changeset(attrs)
      |> Repo.insert()

    component
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

    test "schemaless config can be stored" do
      form = form_fixture(@basic_form)

      # Update and re-read from DB
      {:ok, form} =
        form
        |> Form.changeset(%{config: %{"key1" => 1, key2: 2}})
        |> Repo.update(returning: true)

      assert form.config == %{"key1" => 1, "key2" => 2}
    end
  end

  describe "Component" do
    test "creating and updating" do
      form = form_fixture(@basic_form)

      component =
        component_fixture(form, %{
          name: "my_field",
          config: %{},
          weight: 1
        })

      assert component.name == "my_field"
      assert component.weight == 1

      form = Repo.preload(form, :components)

      assert form.components == [component]

      {:ok, component} =
        component
        |> Component.changeset(%{weight: 2})
        |> Repo.update()

      assert component.weight == 2
    end

    test "error if no form is given" do
      {:error, changeset} =
        %Component{}
        |> Component.changeset(%{type: "text", name: "my_field"})
        |> Repo.insert()

      assert Keyword.has_key?(changeset.errors, :form_id) == true
    end

    test "type and name are required" do
      form = form_fixture(@basic_form)

      {:error, changeset} =
        %Component{}
        |> Component.changeset(%{form_id: form.id})
        |> Repo.insert()

      assert Keyword.has_key?(changeset.errors, :type) == true
      assert Keyword.has_key?(changeset.errors, :name) == true
    end

    test "component name is unique per form" do
      form = form_fixture(@basic_form)
      _component1 = component_fixture(form, %{name: "my_field", weight: 1})

      {:error, changeset} =
        %Component{}
        |> Component.changeset(%{form_id: form.id, type: "text", name: "my_field", weight: 2})
        |> Repo.insert()

      assert Keyword.has_key?(changeset.errors, :name) == true
    end

    test "components are removed if the form is deleted" do
      form = form_fixture(@basic_form)
      component1 = component_fixture(form, %{name: "field", weight: 1})

      component = Repo.get_by(Component, uuid: component1.uuid)
      assert component

      Repo.delete!(form)

      no_component = Repo.get_by(Component, uuid: component1.uuid)
      assert no_component == nil
    end

    test "component types are restricted" do
      form = form_fixture(@basic_form)

      {:error, changeset} =
        %Component{}
        |> Component.changeset(%{
          form_id: form.id,
          type: "unknown",
          name: "not_ok_type",
          weight: 1
        })
        |> Repo.insert()

      assert Keyword.has_key?(changeset.errors, :type) == true

      for t <- @valid_component_types do
        _component =
          component_fixture(form, %{
            type: t,
            name: "ok_type_#{System.unique_integer([:positive, :monotonic])}",
            weight: 1
          })
      end
    end

    test "schemaless config can be stored" do
      form = form_fixture(@basic_form)
      component = component_fixture(form, %{name: "test"})

      # Update and re-read from DB
      {:ok, component} =
        component
        |> Component.changeset(%{config: %{"key1" => 1, key2: 2}})
        |> Repo.update(returning: true)

      assert component.config == %{"key1" => 1, "key2" => 2}
    end
  end
end
