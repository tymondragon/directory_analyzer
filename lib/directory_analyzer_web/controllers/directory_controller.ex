defmodule DirectoryAnalyzerWeb.DirectoryController do
  use DirectoryAnalyzerWeb, :controller

  alias DirectoryAnalyzer.Directories

  def index(conn, _params) do
    directories = Directories.list_directories()
    render(conn, "index.html", directories: directories)
  end

  def process(conn, %{"dir_name" => name}) do
    evaluated_directory =
      case Directories.evaluate_directory(name) do
        {:ok, directory_results} ->
          directory_results

        {:error, reason} ->
          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.directory_path(conn, :index))
      end

    case Directories.create_directory(evaluated_directory) do
      {:ok, %{directory: directory}} ->
        conn
        |> put_flash(:info, "Analysis of #{directory.name} completed.")
        |> redirect(to: Routes.directory_path(conn, :show, directory))

      # Probably won't hit the error since the list of directories filters out already processed ones.
      {:error, %Ecto.Changeset{} = %{changes: changes}} ->
        conn
        |> put_flash(:error, changes[:name] <> " " <> "has already been processed")
        |> redirect(to: Routes.directory_path(conn, :index))

      {:error, _failed_operation, _errors, _changes_so_far} ->
        conn
        |> put_flash(:error, "We reaaaaally are not sure what's happened?")
        |> redirect(to: Routes.directory_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    case Directories.get_directory!(id) do
      nil ->
        conn
        |> put_flash(:error, "Directory Not Found")
        |> redirect(to: Routes.directory_path(conn, :index))

      directory ->
        render(conn, "show.html", directory: directory)
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
