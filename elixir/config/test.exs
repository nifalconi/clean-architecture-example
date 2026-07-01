import Config

# Configure the database for testing
config :clean_architecture_example, CleanArchitectureExample.Repo,
  database: "clean_architecture_example_test#{System.get_env("MIX_TEST_PARTITION")}",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# Use the in-memory repository for tests — no database required.
config :clean_architecture_example,
  task_repository: Data.Repositories.InMemoryTaskRepository

# Bind the HTTP server to a random free port during tests.
config :clean_architecture_example,
  http_port: 0
