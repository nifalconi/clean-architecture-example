defmodule Domain.UseCases.DeleteTask do
  @moduledoc """
  Use case for deleting a task.
  
  This module encapsulates the business logic for task deletion,
  following the Clean Architecture principles.
  """

  @doc """
  Executes the delete task use case.
  
  ## Parameters
  
    - repository: Module implementing TaskRepository behaviour
    - id: String ID of the task to delete
    
  ## Returns
  
    - `:ok` - Task successfully deleted
    - `{:error, :not_found}` - Task not found
    - `{:error, reason}` - Repository error
    
  ## Examples
  
      iex> repo = Data.Repositories.InMemoryTaskRepository
      iex> Domain.UseCases.DeleteTask.execute(repo, "task-123")
      :ok
  """
  @spec execute(module(), String.t()) :: :ok | {:error, :not_found | term()}
  def execute(repository, id) when is_binary(id) and byte_size(id) > 0 do
    case repository.delete(id) do
      :ok ->
        IO.puts("Task Deleted: id=#{id}")
        :ok

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
