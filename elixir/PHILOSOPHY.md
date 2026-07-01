# The Philosophy Behind This Elixir Implementation

This document explains *why* the code is shaped the way it is: what Clean
Architecture actually asks for, and how those demands are met in Elixir — a
language with no classes, no interfaces, and no constructor injection. If the
README tells you *what* the layers are, this tells you *what makes them hold*.

The short version: Clean Architecture is one rule about the direction of
dependencies. Elixir satisfies that rule with runtime module passing and a
domain-owned contract — **not** with the `@behaviour` keyword, which only
*checks* the arrangement rather than creating it.

---

## 1. The one idea: the Dependency Rule

Clean Architecture reduces to a single constraint:

> Source-code dependencies point **inward**, toward higher-level policy.
> Inner layers know nothing about outer layers.

The layers, from inner to outer:

```
        ┌──────────────────────────────────────┐
        │  domain/        (Enterprise rules)    │   entities, use cases,
        │                                        │   repository contracts
        │   ▲            no outward deps         │
        │   │                                    │
        │  data/          (Infrastructure)       │   Ecto, GenServer, Postgres
        │  presentation/  (Interface adapters)   │   Plug router, endpoints
        └──────────────────────────────────────┘
                    dependencies point ▲ up/in
```

`domain/` may not mention Ecto, Plug, Postgres, or JSON. `data/` and
`presentation/` may — and must — depend on `domain/`. Every design choice in
this repo exists to keep that arrow pointing the right way.

---

## 2. The problem the Dependency Rule creates

A use case needs to read a task from *somewhere*. The natural instinct is:

```elixir
# ❌ domain depending on infrastructure — arrow points OUT
def execute(id) do
  Data.Repositories.EctoTaskRepository.find_by_id(id)
end
```

Now the domain names Ecto. The arrow points outward. To test the use case you
need Postgres; to change the database you edit the domain. This is exactly what
the Dependency Rule forbids.

**Dependency inversion** is the technique that fixes it. And this is the heart
of the whole design, so it gets its own section.

---

## 3. Dependency inversion — the physiology

Dependency inversion has three moving parts. Only the first two do any work;
the third (`@behaviour`) verifies them.

### Part 1 — the abstraction lives in the domain

The contract is a *behaviour*, defined in the domain layer
([domain/repository_interfaces/task_repository.ex](domain/repository_interfaces/task_repository.ex)):

```elixir
defmodule Domain.RepositoryInterfaces.TaskRepository do
  @callback find_by_id(String.t()) :: {:ok, Task.t()} | {:error, :not_found | term()}
  @callback create(Task.t()) :: {:ok, Task.t()} | {:error, term()}
  # ...
end
```

The concrete repositories implement it, in the data layer:

```
Domain.RepositoryInterfaces.TaskRepository      ← contract, in the DOMAIN
        ▲                              ▲
        │ @behaviour                   │ @behaviour
Data.Repositories.EctoTaskRepository   Data.Repositories.InMemoryTaskRepository
```

`EctoTaskRepository` (low-level) points **up** at a contract owned by the domain
(high-level). **That upward arrow is the inversion.** Move the behaviour module
into `data/` and the keyword changes nothing — you have lost dependency
inversion, because the abstraction is now owned by the wrong layer.

### Part 2 — the concrete choice is injected at runtime

The use case never names a repository. It takes one as an argument and dispatches
dynamically ([domain/use_cases/get_task.ex](domain/use_cases/get_task.ex)):

```elixir
def execute(repository, id) when is_binary(id) and byte_size(id) > 0 do
  repository.find_by_id(id)   # `repository` is a module, resolved at runtime
end
```

Look at what the use case references: nothing concrete, and **not even the
behaviour** — its spec is `@spec execute(module(), String.t())`, just `module()`.
The domain is blind to Ecto, to the in-memory repo, and to the contract module
itself. This is the *injection*: the dependency enters from outside.

Where does the choice get made? At the **composition root** — the outermost
edge. Here it is the endpoint reading config
([presentation/api/get_task_endpoint.ex](presentation/api/get_task_endpoint.ex)):

```elixir
defp task_repository do
  Application.get_env(:clean_architecture_example, :task_repository,
    Data.Repositories.EctoTaskRepository)
end

# ...
GetTask.execute(task_repository(), id)
```

And config decides which module is real ([config/config.exs](config/config.exs)
vs [config/test.exs](config/test.exs)):

```elixir
# production
config :clean_architecture_example, task_repository: Data.Repositories.EctoTaskRepository
# tests — no database
config :clean_architecture_example, task_repository: Data.Repositories.InMemoryTaskRepository
```

### Part 3 — `@behaviour` enforces, it does not invert

Here is the point that the README bullet glosses over. `@behaviour` is **not**
the mechanism of dependency inversion. Prove it with two thought experiments:

- **Delete every `@behaviour` and `@callback` line.** The code compiles and runs
  *identically*. Ecto and in-memory repos still swap via config. Nothing about
  the inversion changes — because BEAM dispatches `repository.find_by_id/1` to
  whatever module was passed, contract or not.
- **Keep every `@behaviour`, but hardcode `EctoTaskRepository.find_by_id(id)`
  inside the use case.** Dependency inversion is now *dead*, despite the contract
  being present everywhere.

So what does `@behaviour` buy? It upgrades a duck-typed convention ("pass me any
module that happens to have `find_by_id/1`") into a **checked contract**:

1. **Compile-time verification** — with `@impl true` on each function, the
   compiler warns if an implementation is missing a callback or uses the wrong
   arity. Without it, a typo surfaces only at runtime.
2. **Static analysis** — the `@callback` specs give Dialyzer something to check.
3. **Legibility** — the contract becomes a real, nameable thing for humans and
   tooling.

`@behaviour` documents and guards the discipline. It does not create it.

---

## 4. The cross-language truth

The TypeScript sibling uses `getTaskEndpoint(useCase: GetTaskUseCaseInterface)`.
That `interface` is **erased at runtime** — JavaScript just calls `.execute()` on
whatever object arrived. Elixir's `@behaviour` is *also* ignored at runtime — the
VM dispatches to whatever module you passed.

In both languages the same three facts hold:

| Concern | TypeScript | Elixir |
|---|---|---|
| The abstraction (inversion) | `TaskRepositoryInterface` in `domain/` | `@behaviour` module in `domain/` |
| The injection (mechanism) | pass an object into a factory | pass a module into a function |
| The contract at runtime | erased | ignored |

The interface/behaviour is the compile-time contract. The **passing** is the
runtime mechanism. The **placement in the inner layer** is the inversion. Same
physiology, different syntax.

---

## 5. How each Clean Architecture concept maps to Elixir

Clean Architecture was written for object-oriented languages. Elixir has no
objects, so each concept is re-expressed with a functional idiom:

| Clean Architecture concept | OO expression | This Elixir codebase |
|---|---|---|
| Entity | class with invariants | plain `defstruct` + `valid?/1` ([domain/entities/task.ex](domain/entities/task.ex)) |
| Use case | service class, injected deps | pure function taking the repo module ([domain/use_cases/](domain/use_cases/)) |
| Repository interface | `interface` / abstract class | `@behaviour` with `@callback`s |
| Dependency injection | constructor injection | module passed as an argument |
| Composition root | DI container / `main()` | `Application.get_env/3` + config |
| Repository implementation | class `implements` interface | module with `@behaviour` + `@impl` |
| Error handling | exceptions | `{:ok, value}` / `{:error, reason}` tuples |
| Persistence model vs entity | ORM entity + mapper | Ecto schema + `to_domain_entity/1` ([data/models/task.ex](data/models/task.ex)) |
| Long-lived state | singleton object | GenServer ([data/repositories/in_memory_task_repository.ex](data/repositories/in_memory_task_repository.ex)) |

Two of these deserve a note:

- **Use cases are pure functions.** No class, no stored dependency. The repo is
  a parameter, which is the most honest form of injection there is — the
  dependency is visible in the function signature.
- **Errors are values, not control flow.** Because failures are `{:error,
  reason}` tuples, the presentation layer can pattern-match reason atoms
  (`:not_found`, `:invalid_id`) onto HTTP status codes without the domain ever
  knowing HTTP exists. That keeps the domain honest about *what* went wrong while
  leaving *how to report it* to the edge.

---

## 6. What this buys you, concretely

The payoff is not theoretical. Because the domain depends only on a contract
resolved at the edge:

- **Tests run with no database.** The suite swaps in the in-memory GenServer repo
  via `config/test.exs`. See [test/](test/) — the use cases and the endpoint are
  exercised end-to-end with zero Postgres.
- **Swapping infrastructure is a one-line config change**, not a domain edit.
- **The domain is portable.** `domain/` would compile and pass its tests if you
  deleted Ecto, Plug, and Postgres from the project entirely.

That last point is the real test of Clean Architecture: *can the business rules
survive the deletion of the framework?* Here, they can.

---

## 7. The honest trade-off

This is a task with three fields. The behaviour, the mapper, the composition
root, and the in-memory repo are all *ceremony* relative to the problem size — a
direct `Repo.get(Task, id)` would be shorter. The structure earns its keep only
when the system grows: more use cases, more entities, a second data source, a
need to test business logic without I/O. This repo pays the cost up front so the
*shape* is legible. Do not read that as "always do this" — read it as "this is
what the discipline looks like when you choose to apply it."

---

## Where to look

| You want to understand… | Read |
|---|---|
| The contract (inversion) | [domain/repository_interfaces/task_repository.ex](domain/repository_interfaces/task_repository.ex) |
| Injection + dynamic dispatch | [domain/use_cases/get_task.ex](domain/use_cases/get_task.ex) |
| The composition root | [presentation/api/get_task_endpoint.ex](presentation/api/get_task_endpoint.ex), [config/config.exs](config/config.exs) |
| Persistence mapping | [data/models/task.ex](data/models/task.ex), [data/repositories/ecto_task_repository.ex](data/repositories/ecto_task_repository.ex) |
| A swappable implementation | [data/repositories/in_memory_task_repository.ex](data/repositories/in_memory_task_repository.ex) |
| Proof it all holds | [test/](test/) |
