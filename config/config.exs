# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :message_processor, MessageProcessorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EA75TPFVgMukaIPug0d8MfWFPeJ3KD49rNW+7ecICrJrZyYtnWFnSqwLg4wlHNTf",
  render_errors: [view: MessageProcessorWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: MessageProcessor.PubSub, adapter: Phoenix.PubSub.PG2]

config :message_processor,
  default_queue_name: "default"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# uncomment to reduce noise in server output
# config :logger, level: :error

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
