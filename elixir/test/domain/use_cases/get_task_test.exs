defmodule Domain.UseCases.GetTaskTest do
  @moduledoc """
  Exercises the use cases against the in-memory repository — proof the domain
  layer depends only on the behaviour, not on Ecto. Runs with no database.
  """

  use ExUnit.Case, async: false

  alias Data.Repositories.InMemoryTaskRepository
  alias Domain.UseCases.{CreateTask, GetTask}

  setup do
    start_supervised!(InMemoryTaskRepository)
    :ok
  end

  test "creating a task then fetching it by id returns the same task" do
    {:ok, created} =
      CreateTask.execute(InMemoryTaskRepository, "Learn Elixir", ~U[2024-01-01 00:00:00Z])

    assert is_binary(created.id)
    assert created.name == "Learn Elixir"

    assert {:ok, found} = GetTask.execute(InMemoryTaskRepository, created.id)
    assert found == created
  end

  test "fetching an unknown id returns :not_found" do
    assert {:error, :not_found} = GetTask.execute(InMemoryTaskRepository, "task_missing")
  end

  test "fetching with an empty id returns :invalid_id" do
    assert {:error, :invalid_id} = GetTask.execute(InMemoryTaskRepository, "")
  end
end
