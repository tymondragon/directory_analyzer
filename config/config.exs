# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :directory_analyzer,
  ecto_repos: [DirectoryAnalyzer.Repo]

# Configures the endpoint
config :directory_analyzer, DirectoryAnalyzerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dPEgBvV6oSWDjtlqxnvPtEDJlWpfFqUpiWvla5KuU7uSWZxRtwXD1Z3z4U1eWLjE",
  render_errors: [view: DirectoryAnalyzerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DirectoryAnalyzer.PubSub,
  live_view: [signing_salt: "Ira9mPIe"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
