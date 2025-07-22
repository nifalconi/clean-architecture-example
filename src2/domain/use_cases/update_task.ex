defmodule Domain.UseCases.UpdateTask do
  @moduledoc """
  Use case for updating a task.
  
  This module encapsulates the business logic for task updates,
  following the Clean Architecture principles.
  """

  alias Domain.Entities.Task
  alias Domain.RepositoryInterfaces.TaskRepository

  @doc """
  Executes the update task use case.
  
  ## Parameters
  
    - repository: Module implementing TaskRepository behaviour
    - id: String ID of the task to update
    - updates: Map of fields to update (e.g., %{name: "New Name"})
    
  ## Returns
  
    - `{:ok, task}` - Successfully updated task
    - `{:error, :not_found}` - Task not found
    - `{:error, :invalid_updates}` - Invalid update data
    - `{:error, reason}` - Repository error
    
  ## Examples
  
      iex> repo = Data.Repositories.InMemoryTaskRepository
      iex> Domain.UseCases.UpdateTask.execute(repo, "task-123", %{name: "Updated Task"})
      {:ok, %Domain.Entities.Task{id: "task-123", name: "Updated Task", ...}}
  """
  @spec execute(module(), String.t(), map()) :: {:ok, Task.t()} | {:error, term()}
  def execute(repository, id, updates) when is_binary(id) and is_map(updates) do
    case validate_updates(updates) do
      :ok ->
        case repository.update(id, updates) do
          {:ok, updated_task} ->
            IO.puts("Task Updated: #{inspect(updated_task)}")
            {:ok, updated_task}

          {:error, :not_found} ->
            {:error, :not_found}

          {:error, reason} ->
            {:error, reason}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  def execute(_repository, _id, _updates) do
    {:error, :invalid_parameters}
  end

  # Private function to validate update parameters
  defp validate_updates(updates) do
    allowed_keys = [:name, :date]
    
    case Map.keys(updates) -- allowed_keys do
      [] -> 
        case validate_update_values(updates) do
          true -> :ok
          false -> {:error, :invalid_updates}
        end
      _invalid_keys -> 
        {:error, :invalid_updates}
    end
  end

  defp validate_update_values(updates) do
    Enum.all?(updates, fn
      {:name, name} when is_binary(name) and byte_size(name) > 0 -> true
      {:date, %DateTime{}} -> true
      _ -> false
    end)
  end
end
