defmodule Domain.Entities.Task do
  @moduledoc """
  Task entity representing the core business object.
  
  This module defines the Task struct and related functions
  following Domain-Driven Design principles.
  """

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t(),
          date: DateTime.t()
        }

  defstruct [:id, :name, :date]

  @doc """
  Creates a new Task struct.
  
  ## Examples
  
      iex> Domain.Entities.Task.new("Learn Elixir", ~U[2024-01-01 00:00:00Z])
      %Domain.Entities.Task{id: nil, name: "Learn Elixir", date: ~U[2024-01-01 00:00:00Z]}
  """
  @spec new(String.t(), DateTime.t()) :: t()
  def new(name, date) do
    %__MODULE__{
      id: nil,
      name: name,
      date: date
    }
  end

  @doc """
  Creates a new Task struct with an ID.
  
  ## Examples
  
      iex> Domain.Entities.Task.with_id("task-123", "Learn Elixir", ~U[2024-01-01 00:00:00Z])
      %Domain.Entities.Task{id: "task-123", name: "Learn Elixir", date: ~U[2024-01-01 00:00:00Z]}
  """
  @spec with_id(String.t(), String.t(), DateTime.t()) :: t()
  def with_id(id, name, date) do
    %__MODULE__{
      id: id,
      name: name,
      date: date
    }
  end

  @doc """
  Validates a Task struct.
  
  ## Examples
  
      iex> task = Domain.Entities.Task.new("", ~U[2024-01-01 00:00:00Z])
      iex> Domain.Entities.Task.valid?(task)
      false
      
      iex> task = Domain.Entities.Task.new("Learn Elixir", ~U[2024-01-01 00:00:00Z])
      iex> Domain.Entities.Task.valid?(task)
      true
  """
  @spec valid?(t()) :: boolean()
  def valid?(%__MODULE__{name: name}) when is_binary(name) and byte_size(name) > 0, do: true
  def valid?(_), do: false
end
