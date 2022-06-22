defmodule Formtool.Repo.Migrations.AddConfigToForms do
  use Ecto.Migration

  def change do
    alter table(:forms) do
      add :config, :map, default: %{}
    end
  end
end
