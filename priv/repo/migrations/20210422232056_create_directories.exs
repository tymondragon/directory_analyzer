defmodule DirectoryAnalyzer.Repo.Migrations.CreateDirectories do
  use Ecto.Migration

  def change do
    create table(:directories) do
      add :name, :string
      add :word_count, :integer
      add :file_count, :integer

      timestamps()
    end

    create unique_index(:directories, [:name])
  end
end
