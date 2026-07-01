defmodule Domain.UseCases.GetAllTasks do
  @moduledoc """
  Use case for retrieving all tasks.
  
  This module encapsulates the business logic for retrieving all tasks,
  following the Clean Architecture principles.
  """

  alias Domain.Entities.Task

  @doc """
  Executes the get all tasks use case.
  
  ## Parameters
  
    - repository: Module implementing TaskRepository behaviour
    
  ## Returns
  
    - `{:ok, tasks}` - List of all tasks
    - `{:error, reason}` - Repository error
    
  ## Examples
  
      iex> repo = Data.Repositories.InMemoryTaskRepository
      iex> Domain.UseCases.GetAllTasks.execute(repo)
      {:ok, [%Domain.Entities.Task{}, ...]}
  """
  @spec execute(module()) :: {:ok, [Task.t()]} | {:error, term()}
  def execute(repository) do
    case repository.find_all() do
      {:ok, tasks} ->
        IO.puts("All Tasks Retrieved: count=#{length(tasks)}")
        {:ok, tasks}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
