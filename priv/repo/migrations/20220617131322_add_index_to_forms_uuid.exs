defmodule Formtool.Repo.Migrations.AddIndexToFormsUuid do
  use Ecto.Migration

  def change do
    create unique_index(:forms, [:uuid])
  end
end
