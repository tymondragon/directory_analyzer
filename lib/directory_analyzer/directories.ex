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
    IO.inspect(name, label: "LABEL LABEL LABALE")
  end
end
