defmodule DirectoryAnalyzerWeb.DirectoryView do
  use DirectoryAnalyzerWeb, :view

  @list ["lorem", "ipsum", "zombies"]
  def directoryist(directories) when length(directories) === 0, do: @list

  def directory_list(directories) do
    directories = Enum.map(directories, &Map.get(&1, :name)) |> Enum.map(&String.downcase(&1))

    Enum.filter(@list, fn folder ->
      !Enum.member?(directories, folder)
    end)
  end
end
