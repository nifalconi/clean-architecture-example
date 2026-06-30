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

# Composition root: which TaskRepository implementation the app wires in.
# Overridden in test.exs to use the in-memory repository.
config :clean_architecture_example,
  task_repository: Data.Repositories.EctoTaskRepository

# Import environment specific config
import_config "#{config_env()}.exs"
