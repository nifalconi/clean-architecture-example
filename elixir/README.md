# Clean Architecture Example - Elixir Implementation

This directory contains the same Clean Architecture example implemented in **Elixir** with **Ecto**, demonstrating functional programming principles, database persistence, and OTP (Open Telecom Platform) patterns.

## 🏗️ Architecture Overview

```text
elixir/
├── domain/                    # Enterprise Business Rules
│   ├── entities/             # Domain entities (Task)
│   ├── repository_interfaces/ # Repository contracts (behaviours)
│   └── use_cases/            # Application business rules
├── data/                     # Infrastructure Layer
│   ├── models/              # Ecto schemas
│   └── repositories/         # Ecto + in-memory implementations
├── presentation/             # Interface Adapters
│   └── api/                  # Plug router + endpoint handlers
├── lib/                      # Application setup
│   ├── application.ex        # OTP Application (starts Repo + HTTP server)
│   └── repo.ex               # Ecto repo
├── test/                     # ExUnit tests (run against in-memory repo)
├── mix.exs                   # Project configuration
├── example.exs               # Runnable example
└── README.md                 # This file
```

## 🚀 Key Elixir Features Demonstrated

- **Behaviours**: Used for repository interfaces (dependency inversion)
- **Ecto**: Database wrapper and query generator for PostgreSQL
- **Pattern Matching**: Extensive use in function definitions
- **Supervision Trees**: OTP application structure
- **Functional Programming**: Immutable data structures
- **Error Handling**: `{:ok, result}` and `{:error, reason}` tuples
- **Documentation**: Comprehensive `@doc` and `@spec` annotations

## 📋 Prerequisites

- [Elixir](https://elixir-lang.org/install.html) (v1.14+)
- [Erlang/OTP](https://www.erlang.org/downloads) (v25+)
- [PostgreSQL](https://www.postgresql.org/download/) (v12+)

## 🛠️ Installation

```bash
cd elixir

# Install dependencies
mix deps.get

# Create and migrate database
mix ecto.create
mix ecto.migrate

# Compile the project
mix compile
```

## 🏃‍♂️ Running the Example

### Option 1: Run with Mix
```bash
mix run example.exs
```

### Option 2: Run in IEx (Interactive Elixir)
```bash
iex -S mix

# Create a task
iex> {:ok, task} = Domain.UseCases.CreateTask.execute(
...>   Data.Repositories.EctoTaskRepository,
...>   "Learn Elixir",
...>   DateTime.utc_now()
...> )

# Get the task
iex> {:ok, found_task} = Domain.UseCases.GetTask.execute(
...>   Data.Repositories.EctoTaskRepository,
...>   task.id
...> )
```

## 🌐 Running the HTTP Server

The OTP application starts a [Bandit](https://github.com/mtrudel/bandit) HTTP
server (via a `Plug.Router`) alongside the Ecto repo:

```bash
iex -S mix
# or: mix run --no-halt
```

The server listens on port `4000` (configurable via `:http_port`):

```bash
curl http://localhost:4000/api/tasks/<id>
```

The router is deliberately thin — it only maps HTTP to the endpoint's
`handle/1` + `format_response/1` and holds no business logic.

## 🧪 Running the Tests

The test suite runs against the in-memory repository, so **no database is
required**:

```bash
mix test
```

This works because the repository implementation is resolved from config (the
composition root), and `config/test.exs` swaps in
`Data.Repositories.InMemoryTaskRepository`:

```elixir
# config/config.exs — production default
config :clean_architecture_example,
  task_repository: Data.Repositories.EctoTaskRepository

# config/test.exs — no DB needed
config :clean_architecture_example,
  task_repository: Data.Repositories.InMemoryTaskRepository
```

The presentation layer never names a concrete repository; it reads
`Application.get_env(:clean_architecture_example, :task_repository)`.

## 🏛️ Architecture Layers (Elixir Style)

### 1. Domain Layer
- **Entities**: Structs with validation functions
- **Repository Interfaces**: Behaviours defining contracts
- **Use Cases**: Pure functions with business logic

### 2. Data Layer
- **Repositories**: Ecto-based implementations for database persistence
- **Models**: Ecto schemas for database representation

### 3. Presentation Layer
- **API Endpoints**: Functions handling HTTP requests/responses
- **Controllers**: Could include Phoenix controllers

## 🔧 Key Design Patterns

### Behaviour-Based Dependency Injection
```elixir
@behaviour Domain.RepositoryInterfaces.TaskRepository

def execute(repository, id) do
  repository.find_by_id(id)
end
```

### GenServer for State Management
```elixir
defmodule Data.Repositories.InMemoryTaskRepository do
  use GenServer
  @behaviour Domain.RepositoryInterfaces.TaskRepository
  
  def create(task) do
    GenServer.call(__MODULE__, {:create, task})
  end
end
```

### Pattern Matching for Control Flow
```elixir
def execute(repository, id) do
  case repository.find_by_id(id) do
    {:ok, task} -> {:ok, task}
    {:error, :not_found} -> {:error, :not_found}
    {:error, reason} -> {:error, reason}
  end
end
```

### Comprehensive Error Handling
```elixir
@spec execute(module(), String.t()) :: {:ok, Task.t()} | {:error, :not_found | term()}
```

## 🧪 Example Output

```
🚀 Clean Architecture Example in Elixir

1. Creating a new task...
Task Created: %Domain.Entities.Task{id: "task_a1b2c3d4", name: "Learn Clean Architecture in Elixir", date: ~U[2024-01-01 12:00:00Z]}
✅ Task created with ID: task_a1b2c3d4

2. Getting task by ID...
Task Retrieved: %Domain.Entities.Task{id: "task_a1b2c3d4", name: "Learn Clean Architecture in Elixir", date: ~U[2024-01-01 12:00:00Z]}
✅ Task found: Learn Clean Architecture in Elixir

...

🎉 Example completed successfully!
```

## 📚 Learning Resources

- [Elixir Official Guide](https://elixir-lang.org/getting-started/introduction.html)
- [OTP Design Principles](https://www.erlang.org/doc/design_principles/users_guide.html)
- [GenServer Documentation](https://hexdocs.pm/elixir/GenServer.html)
- [Behaviours in Elixir](https://elixir-lang.org/getting-started/typespecs-and-behaviours.html#behaviours)

## 🔄 Comparison with TypeScript Version

| Aspect | TypeScript (typescript/) | Elixir (elixir/) |
|--------|------------------|----------------|
| **Type System** | Static typing | Dynamic with specs |
| **Error Handling** | Exceptions | Result tuples |
| **State Management** | Classes/Objects | GenServer/Processes |
| **Dependency Injection** | Constructor injection | Behaviour + module passing |
| **Concurrency** | Async/await | Actor model (processes) |
| **Data Structures** | Mutable objects | Immutable structs |

## 🤝 Contributing

The Elixir implementation follows the same Clean Architecture principles as the TypeScript version, adapted for functional programming paradigms and OTP patterns.

---

*This Elixir implementation demonstrates how Clean Architecture principles can be applied in a functional programming language with actor-based concurrency.*
