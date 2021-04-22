defmodule DirectoryAnalyzerWeb.PageController do
  use DirectoryAnalyzerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
