defmodule DirectoryAnalyzerWeb.DirectoryController do
  use DirectoryAnalyzerWeb, :controller

  alias DirectoryAnalyzer.Directories

  def index(conn, _params) do
    directories = Directories.list_directories()
    render(conn, "index.html", directories: directories)
  end

  def process(conn, %{"directory_name" => name}) do
    name
    |> Directories.process_directory()

    conn
    |> put_flash(:info, "Directory analyzed successfully.")
    |> redirect(to: Routes.directory_path(conn, :index))

    # case Directories.create_directory(data) do
    #   {:ok, directory} ->
    #     conn
    #     |> put_flash(:info, "Analysis of #{directory.name} completed.")
    #     |> redirect(to: Routes.directory_path(conn, :show, directory))

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end
  end

  def show(conn, %{"id" => id}) do
    directory = Directories.get_directory!(id)
    render(conn, "show.html", directory: directory)
  end

  def delete(conn, %{"id" => id}) do
    directory = Directories.get_directory!(id)
    {:ok, _directory} = Directories.delete_directory(directory)

    conn
    |> put_flash(:info, "Directory deleted successfully.")
    |> redirect(to: Routes.directory_path(conn, :index))
  end
end
