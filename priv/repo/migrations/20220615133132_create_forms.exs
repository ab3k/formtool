defmodule Formtool.Repo.Migrations.CreateForms do
  use Ecto.Migration

  def change do
    create table(:forms) do
      add :uuid, :uuid
      add :title, :string
      add :description, :text

      timestamps()
    end
  end
end
