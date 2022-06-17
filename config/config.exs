# General application configuration
import Config

# Configure the HTTP server port
config :formtool, Formtool.Router, port: 4000

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
