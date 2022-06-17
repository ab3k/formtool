import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.

# Change the DB host or the whole connection string. Handy for running in a
# container or in production.
cond do
  database_host = System.get_env("DATABASE_HOST") ->
    config :formtool, Formtool.Repo, hostname: database_host

  database_url = System.get_env("DATABASE_URL") ->
    config :formtool, Formtool.Repo, url: database_url

  true ->
    nil
end

if port = System.get_env("PORT") do
  config :formtool, Formtool.Router, port: String.to_integer(port)
end
