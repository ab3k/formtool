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

  @doc """
  Transform the stored JSON to a keyword list of validations.

  Can be used with the Validator.add_validations()
  """
  def validations(form) do
    validations = Map.get(form.config, "validations", %{})

    Enum.reduce(validations, [], fn {name, validations}, acc ->
      Keyword.put(
        acc,
        String.to_atom(name),
        Enum.map(validations, fn validation ->
          {String.to_atom(validation), true}
        end)
      )
    end)
  end
end
