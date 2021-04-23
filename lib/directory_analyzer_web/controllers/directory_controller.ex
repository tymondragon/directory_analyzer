defmodule DirectoryAnalyzerWeb.DirectoryController do
  use DirectoryAnalyzerWeb, :controller

  alias DirectoryAnalyzer.Directories
  alias DirectoryAnalyzer.Directories.Directory

  def index(conn, _params) do
    directories = Directories.list_directories()
    render(conn, "index.html", directories: directories)
  end

  def new(conn, _params) do
    changeset = Directories.change_directory(%Directory{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"directory" => directory_params}) do
    case Directories.create_directory(directory_params) do
      {:ok, directory} ->
        conn
        |> put_flash(:info, "Directory created successfully.")
        |> redirect(to: Routes.directory_path(conn, :show, directory))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    directory = Directories.get_directory!(id)
    render(conn, "show.html", directory: directory)
  end

  def edit(conn, %{"id" => id}) do
    directory = Directories.get_directory!(id)
    changeset = Directories.change_directory(directory)
    render(conn, "edit.html", directory: directory, changeset: changeset)
  end

  def update(conn, %{"id" => id, "directory" => directory_params}) do
    directory = Directories.get_directory!(id)

    case Directories.update_directory(directory, directory_params) do
      {:ok, directory} ->
        conn
        |> put_flash(:info, "Directory updated successfully.")
        |> redirect(to: Routes.directory_path(conn, :show, directory))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", directory: directory, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    directory = Directories.get_directory!(id)
    {:ok, _directory} = Directories.delete_directory(directory)

    conn
    |> put_flash(:info, "Directory deleted successfully.")
    |> redirect(to: Routes.directory_path(conn, :index))
  end
end
