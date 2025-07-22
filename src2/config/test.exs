import Config

# Configure the database for testing
config :clean_architecture_example, CleanArchitectureExample.Repo,
  database: "clean_architecture_example_test#{System.get_env("MIX_TEST_PARTITION")}",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10
