defmodule CleanArchitectureExample.Application do
  @moduledoc """
  Application module for the Clean Architecture Example.

  This module starts the supervision tree and manages the application lifecycle.
  """

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      CleanArchitectureExample.Repo,
      # Start the HTTP server
      {Bandit, plug: Presentation.Api.Router, port: http_port()}
    ]

    opts = [strategy: :one_for_one, name: CleanArchitectureExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp http_port do
    Application.get_env(:clean_architecture_example, :http_port, 4000)
  end
end
