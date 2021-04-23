defmodule DirectoryAnalyzer.Directories.Directory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "directories" do
    field :file_count, :integer
    field :name, :string
    field :word_count, :integer

    timestamps()
  end

  @doc false
  def changeset(directory, attrs) do
    directory
    |> cast(attrs, [:name, :word_count, :file_count])
    |> validate_required([:name, :word_count, :file_count])
  end
end
