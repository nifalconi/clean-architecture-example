defmodule Data.Repositories.EctoTaskRepository do
  @moduledoc """
  Ecto-based implementation of the TaskRepository.
  
  This module provides database persistence for tasks using Ecto,
  implementing the TaskRepository behaviour.
  """

  alias CleanArchitectureExample.Repo
  alias Data.Models.Task, as: TaskModel
  alias Domain.Entities.Task
  alias Domain.RepositoryInterfaces.TaskRepository

  @behaviour TaskRepository

  # TaskRepository behaviour implementation

  @impl TaskRepository
  def create(%Task{id: nil} = domain_task) do
    attrs = TaskModel.from_domain_entity(domain_task)
    
    %TaskModel{}
    |> TaskModel.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, task_model} ->
        {:ok, TaskModel.to_domain_entity(task_model)}
      
      {:error, changeset} ->
        {:error, format_changeset_errors(changeset)}
    end
  end

  def create(%Task{id: _id}), do: {:error, :task_already_has_id}

  @impl TaskRepository
  def find_by_id(id) when is_binary(id) do
    case Repo.get(TaskModel, id) do
      nil -> 
        {:error, :not_found}
      
      task_model -> 
        {:ok, TaskModel.to_domain_entity(task_model)}
    end
  end

  @impl TaskRepository
  def find_all do
    tasks = 
      TaskModel
      |> Repo.all()
      |> Enum.map(&TaskModel.to_domain_entity/1)
    
    {:ok, tasks}
  end

  @impl TaskRepository
  def update(id, updates) when is_binary(id) and is_map(updates) do
    case Repo.get(TaskModel, id) do
      nil ->
        {:error, :not_found}
      
      task_model ->
        task_model
        |> TaskModel.changeset(updates)
        |> Repo.update()
        |> case do
          {:ok, updated_task_model} ->
            {:ok, TaskModel.to_domain_entity(updated_task_model)}
          
          {:error, changeset} ->
            {:error, format_changeset_errors(changeset)}
        end
    end
  end

  @impl TaskRepository
  def delete(id) when is_binary(id) do
    case Repo.get(TaskModel, id) do
      nil ->
        {:error, :not_found}
      
      task_model ->
        case Repo.delete(task_model) do
          {:ok, _} -> :ok
          {:error, changeset} -> {:error, format_changeset_errors(changeset)}
        end
    end
  end

  # Private functions

  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
