defmodule DirectoryAnalyzer.Repo do
  use Ecto.Repo,
    otp_app: :directory_analyzer,
    adapter: Ecto.Adapters.Postgres
end
