import Config

# Configure your database
config :formtool, Formtool.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "formtool_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10
