#!/usr/bin/env elixir

# This example demonstrates the Clean Architecture with Ecto
# Run with: mix run example.exs

defmodule CleanArchitectureExample do
  @moduledoc """
  Example demonstrating Clean Architecture in Elixir with Ecto.

  This module shows how to use the use cases with Ecto repository
  and proper separation of concerns.
  """

  alias Domain.UseCases.{CreateTask, GetTask, GetAllTasks, UpdateTask, DeleteTask}
  alias Data.Repositories.EctoTaskRepository

  def run do
    IO.puts("🚀 Clean Architecture Example in Elixir with Ecto\n")

    try do
      # 1. Create a new task
      IO.puts("1. Creating a new task...")
      {:ok, task} = CreateTask.execute(
        EctoTaskRepository,
        "Learn Clean Architecture in Elixir",
        DateTime.utc_now()
      )
      IO.puts("✅ Task created with ID: #{task.id}\n")

      # 2. Get the task by ID
      IO.puts("2. Getting task by ID...")
      {:ok, found_task} = GetTask.execute(EctoTaskRepository, task.id)
      IO.puts("✅ Task found: #{found_task.name}\n")

      # 3. Create another task
      IO.puts("3. Creating another task...")
      {:ok, task2} = CreateTask.execute(
        EctoTaskRepository,
        "Master Functional Programming",
        DateTime.utc_now()
      )
      IO.puts("✅ Second task created with ID: #{task2.id}\n")

      # 4. Get all tasks
      IO.puts("4. Getting all tasks...")
      {:ok, all_tasks} = GetAllTasks.execute(EctoTaskRepository)
      IO.puts("✅ Found #{length(all_tasks)} tasks\n")

      # 5. Update the first task
      IO.puts("5. Updating the first task...")
      {:ok, updated_task} = UpdateTask.execute(
        EctoTaskRepository,
        task.id,
        %{name: "Master Clean Architecture in Elixir"}
      )
      IO.puts("✅ Task updated: #{updated_task.name}\n")

      # 6. Delete the second task
      IO.puts("6. Deleting the second task...")
      :ok = DeleteTask.execute(EctoTaskRepository, task2.id)
      IO.puts("✅ Task deleted\n")

      # 7. Verify deletion
      IO.puts("7. Verifying deletion...")
      {:ok, remaining_tasks} = GetAllTasks.execute(EctoTaskRepository)
      IO.puts("✅ Remaining tasks: #{length(remaining_tasks)}\n")

      # 8. Try to get deleted task (should fail)
      IO.puts("8. Trying to get deleted task...")
      case GetTask.execute(EctoTaskRepository, task2.id) do
        {:error, :not_found} ->
          IO.puts("✅ Correctly returned not_found error\n")
        other ->
          IO.puts("❌ Unexpected result: #{inspect(other)}\n")
      end

      IO.puts("🎉 Example completed successfully!")

    rescue
      error ->
        IO.puts("❌ Error occurred: #{inspect(error)}")
    end
  end
end

# Run the example
CleanArchitectureExample.run()
