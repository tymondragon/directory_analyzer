defmodule DirectoryAnalyzer.Words do
  import Ecto.Query, warn: false

  alias DirectoryAnalyzer.Repo

  alias DirectoryAnalyzer.Words.Word

  @doc """
  Bulk inserts top 10 used words in a directory.

  ## Examples

      iex> insert_top_ten_words([%{word: "word", count: 10, directory_id: 1}, %{}])
      {:ok, %Directory{}}

      iex> create_directory(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def insert_top_ten_words(words) when is_list(words) do
    try do
      case Repo.insert_all(Word, words, returning: true) do
        {_insertion_count, words} -> {:ok, words}
      end
    rescue
      err in Postgrex.Error ->
        %Postgrex.Error{postgres: %{message: message}} = err
        {:error, %{message: message}}
    end
  end
end
