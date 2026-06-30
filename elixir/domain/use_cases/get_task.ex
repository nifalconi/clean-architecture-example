defmodule Domain.UseCases.GetTask do
  @moduledoc """
  Use case for retrieving a task by ID.
  
  This module encapsulates the business logic for task retrieval,
  following the Clean Architecture principles.
  """

  alias Domain.Entities.Task

  @doc """
  Executes the get task use case.
  
  ## Parameters
  
    - repository: Module implementing TaskRepository behaviour
    - id: String ID of the task to retrieve
    
  ## Returns
  
    - `{:ok, task}` - Successfully found task
    - `{:error, :not_found}` - Task not found
    - `{:error, reason}` - Repository error
    
  ## Examples
  
      iex> repo = Data.Repositories.InMemoryTaskRepository
      iex> Domain.UseCases.GetTask.execute(repo, "task-123")
      {:ok, %Domain.Entities.Task{id: "task-123", name: "Learn Elixir", date: ~U[2024-01-01 00:00:00Z]}}
  """
  @spec execute(module(), String.t()) :: {:ok, Task.t()} | {:error, :not_found | term()}
  def execute(repository, id) when is_binary(id) and byte_size(id) > 0 do
    case repository.find_by_id(id) do
      {:ok, task} ->
        IO.puts("Task Retrieved: #{inspect(task)}")
        {:ok, task}

      {:error, :not_found} ->
        {:error, :not_found}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def execute(_repository, _id) do
    {:error, :invalid_id}
  end
end
