defmodule Formtool.Repo.Migrations.CreateComponents do
  use Ecto.Migration

  def change do
    create table(:components) do
      add :uuid, :uuid
      add :type, :string, null: false
      add :name, :string
      add :weight, :integer, default: 0
      add :form_id, references(:forms, on_delete: :delete_all)

      timestamps()
    end

    create index(:components, [:form_id])
    create unique_index(:components, [:uuid])
    create unique_index(:components, [:name, :form_id])
  end
end
