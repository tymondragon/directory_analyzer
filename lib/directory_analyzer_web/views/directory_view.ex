defmodule DirectoryAnalyzerWeb.DirectoryView do
  use DirectoryAnalyzerWeb, :view

  @list ["lorem", "recipes", "the_living_mummy"]
  def directory_list(directories) when length(directories) === 0, do: @list

  def directory_list(directories) do
    directories =
      Enum.map(directories, &Map.get(&1, :name))
      |> Enum.map(&String.downcase(&1))
      |> Enum.map(&String.replace(&1, "_", " "))

    Enum.filter(@list, fn folder ->
      !Enum.member?(directories, folder)
    end)
  end
end
