defmodule DirectoryAnalyzer.Words.Word do
  use Ecto.Schema
  import Ecto.Changeset

  alias DirectoryAnalyzer.Directories.Directory

  schema "words" do
    field :word, :string
    field :count, :integer
    field :word_count, :integer

    belongs_to :directory, Directory

    timestamps()
  end

  @doc false
  def changeset(word, attrs) do
    word
    |> cast(attrs, [:word, :count])
    |> validate_required([:word, :count])
  end
end
