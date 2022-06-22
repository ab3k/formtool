defmodule Formtool.Repo.Migrations.AddIndexToFormsConfig do
  use Ecto.Migration

  def change do
    create index(:forms, [:config], using: :gin)
  end
end
