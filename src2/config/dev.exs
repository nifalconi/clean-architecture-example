import Config

# Configure the database for development
config :clean_architecture_example, CleanArchitectureExample.Repo,
  database: "clean_architecture_example_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
