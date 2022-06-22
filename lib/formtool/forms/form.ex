defmodule Formtool.Forms.Form do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "forms" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :title, :string
    field :description, :string
    field :config, :map
    has_many :components, Formtool.Forms.Component

    timestamps()
  end

  @doc false
  def changeset(form, attrs) do
    form
    |> cast(attrs, [:uuid, :title, :description, :config])
    |> validate_required([:title])
    |> unique_constraint([:uuid])
  end
end
