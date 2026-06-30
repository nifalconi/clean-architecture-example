import Config

# Configure the database for production
config :clean_architecture_example, CleanArchitectureExample.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true
