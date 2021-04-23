defmodule DirectoryAnalyzerWeb.DirectoryView do
  use DirectoryAnalyzerWeb, :view

  @list ["lorem", "ipsum", "zombies"]
  def directoryList(directories) when length(directories) === 0, do: @list

  def directoryList(directories) do
    directories = Enum.map(directories, &Map.get(&1, :name)) |> Enum.map(&String.downcase(&1))
    Enum.filter(@list, fn folder ->
      !Enum.member?(directories, String.downcase(folder))
    end)
  end
end
