defmodule Domain.UseCases.CreateTask do
  @moduledoc """
  Use case for creating a new task.
  
  This module encapsulates the business logic for task creation,
  following the Clean Architecture principles.
  """

  alias Domain.Entities.Task
  alias Domain.RepositoryInterfaces.TaskRepository

  @doc """
  Executes the create task use case.
  
  ## Parameters
  
    - repository: Module implementing TaskRepository behaviour
    - name: String name of the task
    - date: DateTime for the task
    
  ## Returns
  
    - `{:ok, task}` - Successfully created task
    - `{:error, :invalid_task}` - Task validation failed
    - `{:error, reason}` - Repository error
    
  ## Examples
  
      iex> repo = Data.Repositories.InMemoryTaskRepository
      iex> Domain.UseCases.CreateTask.execute(repo, "Learn Elixir", ~U[2024-01-01 00:00:00Z])
      {:ok, %Domain.Entities.Task{id: "generated-id", name: "Learn Elixir", date: ~U[2024-01-01 00:00:00Z]}}
  """
  @spec execute(module(), String.t(), DateTime.t()) :: {:ok, Task.t()} | {:error, term()}
  def execute(repository, name, date) do
    task = Task.new(name, date)

    case Task.valid?(task) do
      true ->
        case repository.create(task) do
          {:ok, created_task} ->
            IO.puts("Task Created: #{inspect(created_task)}")
            {:ok, created_task}

          {:error, reason} ->
            {:error, reason}
        end

      false ->
        {:error, :invalid_task}
    end
  end
end
