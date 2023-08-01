defmodule TodoApp.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias TodoApp.Accounts.Account

  schema "tasks" do
    field :completed, :boolean, default: false
    field :date, :date
    field :title, :string
    belongs_to :account, Account

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :date, :completed])
    |> validate_required([:title, :date, :completed])
  end
end
