defmodule Formtool.Repo.Migrations.AddIndexToComponentsConfig do
  use Ecto.Migration

  def change do
    create index(:components, [:config], using: :gin)
  end
end
