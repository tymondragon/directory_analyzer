defmodule DirectoryAnalyzer.Repo do
  use Ecto.Repo,
    otp_app: :directory_analyzer,
    adapter: Ecto.Adapters.Postgres

  def init(_, opts) do
    {:ok, opts}
  end
end
