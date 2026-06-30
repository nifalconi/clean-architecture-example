defmodule Presentation.Api.GetTaskEndpointTest do
  @moduledoc """
  Proves the composition root works: the endpoint resolves its repository from
  config (set to the in-memory repo in test.exs), never naming a concrete repo.
  """

  use ExUnit.Case, async: false

  alias Data.Repositories.InMemoryTaskRepository
  alias Domain.UseCases.CreateTask
  alias Presentation.Api.GetTaskEndpoint

  setup do
    start_supervised!(InMemoryTaskRepository)
    :ok
  end

  test "handle/1 returns the task resolved via the configured repository" do
    {:ok, task} =
      CreateTask.execute(
        InMemoryTaskRepository,
        "Wire the composition root",
        ~U[2024-01-01 00:00:00Z]
      )

    assert {:ok, %{success: true, data: data}} = GetTaskEndpoint.handle(%{"id" => task.id})
    assert data.id == task.id
    assert data.name == "Wire the composition root"
  end

  test "handle/1 returns a 404 tuple for a missing task" do
    assert {:error, 404, _message} = GetTaskEndpoint.handle(%{"id" => "task_missing"})
  end

  test "handle/1 returns a 400 tuple when id is missing" do
    assert {:error, 400, _message} = GetTaskEndpoint.handle(%{})
  end
end
