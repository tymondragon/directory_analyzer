defmodule DirectoryAnalyzerWeb.DirectoryView do
  use DirectoryAnalyzerWeb, :view

  @list [
    %{display_name: "Lorem", dir_name: "lorem"},
    %{display_name: "Recipes", dir_name: "recipes"},
    %{display_name: "The Living Mummy", dir_name: "the_living_mummy"}
  ]
  def directory_list(directories) when length(directories) === 0, do: @list

  def directory_list(directories) do
    directories =
      Enum.map(directories, &Map.get(&1, :name))
      |> Enum.map(&String.downcase(&1))

    Enum.filter(@list, fn folder ->
      !Enum.member?(directories, folder.dir_name)
    end)
  end
end
