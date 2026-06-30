defmodule Data.Repositories.InMemoryTaskRepository do
  @moduledoc """
  In-memory implementation of the `TaskRepository` behaviour, backed by a GenServer.

  Requires no database, so it doubles as the test double and a local playground.
  Wire it in via config:

      config :clean_architecture_example,
        task_repository: Data.Repositories.InMemoryTaskRepository
  """

  use GenServer

  alias Domain.Entities.Task
  alias Domain.RepositoryInterfaces.TaskRepository

  @behaviour TaskRepository

  # Client API

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl TaskRepository
  def create(%Task{id: nil} = task) do
    GenServer.call(__MODULE__, {:create, task})
  end

  def create(%Task{id: _id}), do: {:error, :task_already_has_id}

  @impl TaskRepository
  def find_by_id(id) when is_binary(id) do
    GenServer.call(__MODULE__, {:find_by_id, id})
  end

  @impl TaskRepository
  def find_all do
    GenServer.call(__MODULE__, :find_all)
  end

  @impl TaskRepository
  def update(id, updates) when is_binary(id) and is_map(updates) do
    GenServer.call(__MODULE__, {:update, id, updates})
  end

  @impl TaskRepository
  def delete(id) when is_binary(id) do
    GenServer.call(__MODULE__, {:delete, id})
  end

  # Server callbacks

  @impl GenServer
  def init(state), do: {:ok, state}

  @impl GenServer
  def handle_call({:create, task}, _from, state) do
    created = %Task{task | id: generate_id()}
    {:reply, {:ok, created}, Map.put(state, created.id, created)}
  end

  def handle_call({:find_by_id, id}, _from, state) do
    case Map.fetch(state, id) do
      {:ok, task} -> {:reply, {:ok, task}, state}
      :error -> {:reply, {:error, :not_found}, state}
    end
  end

  def handle_call(:find_all, _from, state) do
    {:reply, {:ok, Map.values(state)}, state}
  end

  def handle_call({:update, id, updates}, _from, state) do
    case Map.fetch(state, id) do
      {:ok, task} ->
        updated = struct(task, Map.take(updates, [:name, :date]))
        {:reply, {:ok, updated}, Map.put(state, id, updated)}

      :error ->
        {:reply, {:error, :not_found}, state}
    end
  end

  def handle_call({:delete, id}, _from, state) do
    case Map.fetch(state, id) do
      {:ok, _task} -> {:reply, :ok, Map.delete(state, id)}
      :error -> {:reply, {:error, :not_found}, state}
    end
  end

  # Private functions

  defp generate_id do
    "task_" <> (:crypto.strong_rand_bytes(8) |> Base.encode16(case: :lower))
  end
end
