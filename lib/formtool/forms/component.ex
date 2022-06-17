defmodule Formtool.Forms.Component do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @component_types [
    "email",
    "text",
    "submit"
  ]

  schema "components" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :type, :string
    field :name, :string
    field :weight, :integer
    belongs_to :form, Formtool.Forms.Form

    timestamps()
  end

  @doc false
  def __component_types__ do
    @component_types
  end

  @doc false
  def changeset(component, attrs) do
    component
    |> cast(attrs, [:type, :name, :weight, :form_id])
    |> validate_required([:type, :name, :form_id])
    |> validate_inclusion(:type, @component_types)
    |> foreign_key_constraint(:form_id)
    |> unique_constraint([:name, :form_id])
  end
end
