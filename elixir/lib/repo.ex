defmodule CleanArchitectureExample.Repo do
  @moduledoc """
  Ecto repository for database operations.
  
  This module provides the database interface using Ecto,
  following Elixir/Phoenix conventions.
  """

  use Ecto.Repo,
    otp_app: :clean_architecture_example,
    adapter: Ecto.Adapters.Postgres
end
