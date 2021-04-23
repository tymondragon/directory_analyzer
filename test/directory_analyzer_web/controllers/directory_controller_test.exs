defmodule DirectoryAnalyzerWeb.DirectoryControllerTest do
  use DirectoryAnalyzerWeb.ConnCase

  alias DirectoryAnalyzer.Directories

  @create_attrs %{file_count: 42, name: "some name", word_count: 42}
  @update_attrs %{file_count: 43, name: "some updated name", word_count: 43}
  @invalid_attrs %{file_count: nil, name: nil, word_count: nil}

  def fixture(:directory) do
    {:ok, directory} = Directories.create_directory(@create_attrs)
    directory
  end

  describe "index" do
    test "lists all directories", %{conn: conn} do
      conn = get(conn, Routes.directory_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Directories"
    end
  end

  describe "new directory" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.directory_path(conn, :new))
      assert html_response(conn, 200) =~ "New Directory"
    end
  end

  describe "create directory" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.directory_path(conn, :create), directory: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.directory_path(conn, :show, id)

      conn = get(conn, Routes.directory_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Directory"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.directory_path(conn, :create), directory: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Directory"
    end
  end

  describe "edit directory" do
    setup [:create_directory]

    test "renders form for editing chosen directory", %{conn: conn, directory: directory} do
      conn = get(conn, Routes.directory_path(conn, :edit, directory))
      assert html_response(conn, 200) =~ "Edit Directory"
    end
  end

  describe "update directory" do
    setup [:create_directory]

    test "redirects when data is valid", %{conn: conn, directory: directory} do
      conn = put(conn, Routes.directory_path(conn, :update, directory), directory: @update_attrs)
      assert redirected_to(conn) == Routes.directory_path(conn, :show, directory)

      conn = get(conn, Routes.directory_path(conn, :show, directory))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, directory: directory} do
      conn = put(conn, Routes.directory_path(conn, :update, directory), directory: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Directory"
    end
  end

  describe "delete directory" do
    setup [:create_directory]

    test "deletes chosen directory", %{conn: conn, directory: directory} do
      conn = delete(conn, Routes.directory_path(conn, :delete, directory))
      assert redirected_to(conn) == Routes.directory_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.directory_path(conn, :show, directory))
      end
    end
  end

  defp create_directory(_) do
    directory = fixture(:directory)
    %{directory: directory}
  end
end
