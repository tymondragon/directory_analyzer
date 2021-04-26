defmodule DirectoryAnalyzerWeb.HomeController do
  use DirectoryAnalyzerWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/directories")
  end
end
