defmodule Domain.RepositoryInterfaces.TaskRepository do
  @moduledoc """
  Repository interface for Task operations.
  
  This module defines the contract that any Task repository implementation
  must follow, ensuring dependency inversion principle.
  """

  alias Domain.Entities.Task

  @doc """
  Creates a new task in the repository.
  
  ## Parameters
  
    - task: A Task struct without an ID
    
  ## Returns
  
    - `{:ok, task}` - Task with generated ID
    - `{:error, reason}` - Error creating task
  """
  @callback create(Task.t()) :: {:ok, Task.t()} | {:error, term()}

  @doc """
  Finds a task by its ID.
  
  ## Parameters
  
    - id: String ID of the task
    
  ## Returns
  
    - `{:ok, task}` - Found task
    - `{:error, :not_found}` - Task not found
    - `{:error, reason}` - Other error
  """
  @callback find_by_id(String.t()) :: {:ok, Task.t()} | {:error, :not_found | term()}

  @doc """
  Finds all tasks in the repository.
  
  ## Returns
  
    - `{:ok, tasks}` - List of all tasks
    - `{:error, reason}` - Error retrieving tasks
  """
  @callback find_all() :: {:ok, [Task.t()]} | {:error, term()}

  @doc """
  Updates a task in the repository.
  
  ## Parameters
  
    - id: String ID of the task to update
    - updates: Map of fields to update
    
  ## Returns
  
    - `{:ok, task}` - Updated task
    - `{:error, :not_found}` - Task not found
    - `{:error, reason}` - Other error
  """
  @callback update(String.t(), map()) :: {:ok, Task.t()} | {:error, :not_found | term()}

  @doc """
  Deletes a task from the repository.
  
  ## Parameters
  
    - id: String ID of the task to delete
    
  ## Returns
  
    - `:ok` - Task deleted successfully
    - `{:error, :not_found}` - Task not found
    - `{:error, reason}` - Other error
  """
  @callback delete(String.t()) :: :ok | {:error, :not_found | term()}
end
