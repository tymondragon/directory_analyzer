defmodule DirectoryAnalyzer.Directories.Directory do
  use Ecto.Schema
  import Ecto.Changeset

  alias DirectoryAnalyzer.Words.Word

  schema "directories" do
    field :file_count, :integer
    field :name, :string
    field :word_count, :integer

    has_many :words, Word

    timestamps()
  end

  @doc false
  def changeset(directory, attrs) do
    directory
    |> cast(attrs, [:name, :word_count, :file_count])
    |> validate_required([:name, :word_count, :file_count])
    |> unique_constraint(:name)
  end
end
