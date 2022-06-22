defmodule Formtool.Repo.Migrations.AddConfigToComponents do
  use Ecto.Migration

  def change do
    alter table(:components) do
      add :config, :map, default: %{}
    end
  end
end
