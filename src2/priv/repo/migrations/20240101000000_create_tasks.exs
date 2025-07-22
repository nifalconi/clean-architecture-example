defmodule CleanArchitectureExample.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :date, :utc_datetime, null: false

      timestamps()
    end

    create index(:tasks, [:name])
    create index(:tasks, [:date])
  end
end
