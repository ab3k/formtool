import Config

# Configure your database
config :formtool, Formtool.Repo,
  pool_size: 10,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "formtool_dev"
