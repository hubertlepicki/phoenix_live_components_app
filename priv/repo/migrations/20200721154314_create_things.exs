defmodule App.Repo.Migrations.CreateThings do
  use Ecto.Migration

  def change do
    create table(:things) do
      add :type, :string
      add :name, :string
      add :box_id, references(:boxes, on_delete: :delete_all)

      timestamps()
    end

    create index(:things, [:box_id])
  end
end
