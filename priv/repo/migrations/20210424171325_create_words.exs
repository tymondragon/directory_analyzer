defmodule DirectoryAnalyzer.Repo.Migrations.CreateWords do
  use Ecto.Migration

  def change do
    create table(:words) do
      add :word, :string
      add :count, :integer
      add :directory_id, references(:directories, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:words, [:directory_id])
  end
end
