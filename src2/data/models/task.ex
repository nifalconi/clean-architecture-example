defmodule Data.Models.Task do
  @moduledoc """
  Ecto schema for Task database model.
  
  This module defines the database representation of a Task,
  separate from the domain entity.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "tasks" do
    field :name, :string
    field :date, :utc_datetime

    timestamps()
  end

  @doc """
  Changeset for creating and updating tasks.
  """
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :date])
    |> validate_required([:name, :date])
    |> validate_length(:name, min: 1, max: 255)
  end

  @doc """
  Converts an Ecto Task to a Domain Task entity.
  """
  def to_domain_entity(%__MODULE__{} = task) do
    %Domain.Entities.Task{
      id: task.id,
      name: task.name,
      date: task.date
    }
  end

  @doc """
  Converts a Domain Task entity to Ecto Task attributes.
  """
  def from_domain_entity(%Domain.Entities.Task{} = domain_task) do
    %{
      name: domain_task.name,
      date: domain_task.date
    }
  end
end
