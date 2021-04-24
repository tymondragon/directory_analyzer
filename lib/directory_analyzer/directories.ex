defmodule DirectoryAnalyzer.Directories do
  @moduledoc """
  The Directories context.
  """

  import Ecto.Query, warn: false
  alias DirectoryAnalyzer.Repo

  alias DirectoryAnalyzer.Directories.Directory

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
  Gets a single directory.

  Raises `Ecto.NoResultsError` if the Directory does not exist.

  ## Examples

      iex> get_directory!(123)
      %Directory{}

      iex> get_directory!(456)
      ** (Ecto.NoResultsError)

  """
  def get_directory!(id), do: Repo.get!(Directory, id)

  @doc """
  Creates a directory.

  ## Examples

      iex> create_directory(%{field: value})
      {:ok, %Directory{}}

      iex> create_directory(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_directory(attrs \\ %{}) do
    %Directory{}
    |> Directory.changeset(attrs)
    |> Repo.insert()
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
  Generates a word count for all .txt files within a directory.

  ## Examples

      iex> process_directory(name)
      {:ok, %Directory{}}

      iex> process_directory(name)
      {:error, :file.format_error(reason)}

  """
  def process_directory(name) do
    files = list_files(name)

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
      |> Map.merge(%{file_count: length(files)})

      # STILL NEED TO FIGURE OUT HOW TO SELECT TOP TEN WORDS IN THE LIST
      for {key, val} <- result.words,
        into: %{},
        do:
          {String.to_atom(key), val}
          |> IO.inspect()


    # get absolute path name for directory
    # find all txt files within directory <--- safe to say that it will ignore any non text file.
    # drop any file that is empty
    # loop over each file and read the file.
    # With result of each file ----- (TODO: look below)
    # reduce to dir_map of %{total_words: total_words + length(file) words: %{word: count}}
    # put file_count to dir_map -> %{total_words: integer, words: %{word: count}, file_count: length(files)}

    # TODO
    # sanitize files
    # remove special characters
    # remove integers
    # extra spaces, carriages, new lines
  end

  defp list_files(name) do
    # -- get absolute path name for directory
    # -- find all txt files within directory <--- safe to say that it will ignore any non text file.
    Path.absname("documents/#{name}")
    |> Kernel.<>("/*.txt")
    |> Path.wildcard()
  end

  def process_file(file) do
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
