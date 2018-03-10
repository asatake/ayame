# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :ayame, AyameWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mrrRbSY2fICVpmFK5vSmHJ42XRstofi5He3snUngQky/A/U/rv7Cs41R6awOAM8P",
  render_errors: [view: AyameWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ayame.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
