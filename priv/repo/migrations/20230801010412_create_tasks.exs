defmodule TodoApp.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :date, :date, null: false
      add :completed, :boolean, default: false, null: false
      add :account_id, references(:accounts, on_delete: :delete_all)

      timestamps()
    end

    create index(:tasks, [:account_id])
  end
end
