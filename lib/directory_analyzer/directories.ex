defmodule DirectoryAnalyzer.Directories do
  @moduledoc """
  The Directories context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias DirectoryAnalyzer.Repo

  alias DirectoryAnalyzer.Directories.Directory
  alias DirectoryAnalyzer.Words
  alias DirectoryAnalyzer.Words.Word

  @doc """
  Returns the list of directories.

  ## Examples

      iex> list_directories()
      [%Directory{}, ...]

  """
  def list_directories do
    Repo.all(Directory)
  end

  @doc """
  Gets a single directory and it's 10 most used words.

  Raises `Ecto.NoResultsError` if the Directory does not exist.

  ## Examples

      iex> get_directory!(123)
      %Directory{}

      iex> get_directory!(456)
      ** (Ecto.NoResultsError)

  """
  def get_directory!(id) do
    top_ten_words_query =
      Word
      |> order_by([w], desc: w.count, asc: w.word)

    Directory
    |> where([d], d.id == ^id)
    |> preload([_], top_ten_words: ^top_ten_words_query)
    |> Repo.one()
  end

  @doc """
  Runs a transaction: creating a directory, inserting top 10 words

  ## Examples

      iex> create_directory(%{field: value})
      {:ok, %Directory{}}

      iex> create_directory(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_directory(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:directory, Directory.changeset(%Directory{}, attrs))
    |> Multi.run(:top_ten_words, fn _, %{directory: directory} ->
      now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

      top_ten_words =
        attrs[:words]
        |> Enum.map(fn {word, count} ->
          %{
            word: word,
            count: count,
            directory_id: directory.id,
            inserted_at: now,
            updated_at: now
          }
        end)

      Words.insert_top_ten_words(top_ten_words)
    end)
    |> Repo.transaction()
  end

  @doc """
  Deletes a directory.

  ## Examples

  iex> delete_directory(directory)
  {:ok, %Directory{}}

  iex> delete_directory(directory)
  {:error, %Ecto.Changeset{}}

  """
  def delete_directory(%Directory{} = directory) do
    Repo.delete(directory)
  end

  @doc """
  Evaluates directory for word count stats
  ## Examples

      iex> evaluate_directory(name)
      {:ok, %{name: name, word_count: word_count, file_count: file_count, words: [%{hello: 5}, %{}]}}

      iex> evaluate_directory(name)
      {:error, message}

  """
  def evaluate_directory(name) do
    case list_files(name) do
      {:ok, files} ->
        process_directory(name, files)

      {:error, message} ->
        {:error, message}
    end
  end

  defp list_files(name) do
    # -- get absolute path name for directory
    # -- find all txt files within directory <--- safe to say that it will ignore any non text file.
    files =
      Path.absname("documents/#{name}")
      |> Kernel.<>("/*.txt")
      |> Path.wildcard()

    case length(files) do
      0 ->
        {:error, "There are no .txt files in this directory"}

      _ ->
        {:ok, files}
    end
  end

  defp process_directory(name, files) do
    result =
      files
      |> Enum.map(fn file ->
        process_file(file)
      end)
      |> List.flatten()
      |> Enum.reduce(%{word_count: 0, words: %{}}, fn word,
                                                      %{word_count: word_count, words: words} =
                                                        acc ->
        words = Map.update(words, word, 1, fn existing_value -> existing_value + 1 end)

        %{acc | word_count: word_count + 1, words: words}
      end)
      |> Map.merge(%{file_count: length(files), name: name})

    # sorting by count is working, yet both count and word are descending so the ordering on the words is reverse alphabetized.
    top_ten_words =
      Enum.sort_by(result.words, fn {word, count} -> {count, word} end, &>=/2)
      |> Enum.slice(0..9)

    {:ok, %{result | words: top_ten_words}}
  end

  defp process_file(file) do
    # TODO fix last map to handle ignore only all caps I's
    file
    |> File.stream!()
    |> Enum.map(&String.replace(&1, ~r/([[:punct:]]|[[:digit:]])/, ""))
    |> Enum.map(&Regex.replace(~r/\b(?:(?!I)\w)+\b/, &1, fn a, _ -> String.downcase(a) end))
    |> Enum.filter(fn s -> s !== "\n" end)
    |> Enum.map(&String.replace(&1, ~r/(\n+)/, ""))
    |> Enum.map(&String.split/1)
  end
end
