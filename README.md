# Clean Architecture Example

The same task-management domain — entities, repository interfaces, use cases,
and a presentation layer — modeled twice with Clean Architecture, so you can
compare how the same design plays out in two very different languages.

```text
clean-architecture-example/
├── typescript/   # TypeScript + Bun + MongoDB (Mongoose) + Zod
└── elixir/       # Elixir + Ecto + PostgreSQL + OTP
```

Each folder is self-contained with its own toolchain, dependencies, and README.

## Implementations

| | TypeScript | Elixir |
|---|---|---|
| **Runtime** | [Bun](https://bun.sh) | Erlang/OTP |
| **Persistence** | MongoDB (Mongoose) | PostgreSQL (Ecto) |
| **Validation** | Zod | Ecto changesets / specs |
| **Dependency inversion** | Constructor / factory injection | Behaviours + module passing |
| **Error handling** | Exceptions | `{:ok, _}` / `{:error, _}` tuples |
| **Setup** | [typescript/README.md](typescript/README.md) | [elixir/README.md](elixir/README.md) |

## The shared design

Both implementations follow the same dependency direction — the domain layer
knows nothing about infrastructure, and the data layer implements interfaces the
domain defines:

```text
domain/        # Enterprise business rules (entities, use cases, repo contracts)
data/          # Infrastructure (DB models, repository implementations)
presentation/  # Interface adapters (API endpoints)
```

Read each implementation's README for language-specific details and run
instructions.

## License

MIT — see [LICENSE](LICENSE).
