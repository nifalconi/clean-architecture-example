import Config

# Configure the database
config :clean_architecture_example, CleanArchitectureExample.Repo,
  database: "clean_architecture_example_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Configure Ecto repositories
config :clean_architecture_example,
  ecto_repos: [CleanArchitectureExample.Repo]

# Import environment specific config
import_config "#{config_env()}.exs"
