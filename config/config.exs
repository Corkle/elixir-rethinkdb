# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :rethink_example, RethinkExample.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "FBCv8vnooaqTqfLqR9j1mHtca2B18au5EhnLutQPp7kczrIYTjFhW+IvPKgeTtyk",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: RethinkExample.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :guardian, Guardian,
  issuer: "RethinkExample",
  ttl: {3, :days},
  verify_issuer: true,
  secret_key: "tb3VSRRiqPCbBgEQWQ6jD5uudZqdRl5d4jOYwBqGd3FFEI27V9hp7+QBJIXF4y4i",
  serializer: RethinkExample.GuardianSerializer