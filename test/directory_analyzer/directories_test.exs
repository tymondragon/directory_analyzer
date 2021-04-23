defmodule DirectoryAnalyzer.DirectoriesTest do
  use DirectoryAnalyzer.DataCase

  alias DirectoryAnalyzer.Directories

  describe "directories" do
    alias DirectoryAnalyzer.Directories.Directory

    @valid_attrs %{file_count: 42, name: "some name", word_count: 42}
    @update_attrs %{file_count: 43, name: "some updated name", word_count: 43}
    @invalid_attrs %{file_count: nil, name: nil, word_count: nil}

    def directory_fixture(attrs \\ %{}) do
      {:ok, directory} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Directories.create_directory()

      directory
    end

    test "list_directories/0 returns all directories" do
      directory = directory_fixture()
      assert Directories.list_directories() == [directory]
    end

    test "get_directory!/1 returns the directory with given id" do
      directory = directory_fixture()
      assert Directories.get_directory!(directory.id) == directory
    end

    test "create_directory/1 with valid data creates a directory" do
      assert {:ok, %Directory{} = directory} = Directories.create_directory(@valid_attrs)
      assert directory.file_count == 42
      assert directory.name == "some name"
      assert directory.word_count == 42
    end

    test "create_directory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directories.create_directory(@invalid_attrs)
    end

    test "update_directory/2 with valid data updates the directory" do
      directory = directory_fixture()

      assert {:ok, %Directory{} = directory} =
               Directories.update_directory(directory, @update_attrs)

      assert directory.file_count == 43
      assert directory.name == "some updated name"
      assert directory.word_count == 43
    end

    test "update_directory/2 with invalid data returns error changeset" do
      directory = directory_fixture()
      assert {:error, %Ecto.Changeset{}} = Directories.update_directory(directory, @invalid_attrs)
      assert directory == Directories.get_directory!(directory.id)
    end

    test "delete_directory/1 deletes the directory" do
      directory = directory_fixture()
      assert {:ok, %Directory{}} = Directories.delete_directory(directory)
      assert_raise Ecto.NoResultsError, fn -> Directories.get_directory!(directory.id) end
    end

    test "change_directory/1 returns a directory changeset" do
      directory = directory_fixture()
      assert %Ecto.Changeset{} = Directories.change_directory(directory)
    end
  end
end
