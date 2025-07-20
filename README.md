# Clean Architecture Example

A TypeScript implementation of Clean Architecture using Bun, MongoDB, and Zod for validation.

## 🏗️ Architecture Overview

This project demonstrates Clean Architecture principles with clear separation of concerns:

```text
src/
├── domain/                 # Enterprise Business Rules
│   ├── entities/          # Domain entities
│   ├── repository-interface/  # Repository contracts
│   └── use-cases/         # Application business rules
├── data/                  # Infrastructure Layer
│   ├── database.ts        # Database connection
│   ├── models/           # Database models (Mongoose)
│   └── repositories/     # Repository implementations
└── presentation/          # Interface Adapters
    └── api/              # REST API endpoints
```

## 🚀 Features

- **Clean Architecture**: Proper dependency inversion and separation of concerns
- **TypeScript**: Full type safety throughout the application
- **Bun Runtime**: Fast JavaScript runtime with built-in package manager
- **MongoDB**: Document database with Mongoose ODM
- **Zod Validation**: Runtime type checking and validation
- **Use Cases**: Business logic encapsulated in use case classes
- **Repository Pattern**: Data access abstraction

## 📋 Prerequisites

- [Bun](https://bun.sh) (v1.0+)
- MongoDB (local or remote)

## 🛠️ Installation

```bash
# Clone the repository
git clone <repository-url>
cd clean-architecture-example

# Install dependencies
bun install
```

## 🏃‍♂️ Running the Application

```bash
# Development mode
bun run dev

# Production mode
bun run start

# Type checking
bun run type-check
```

The API server will start on `http://localhost:3000`

## 📡 API Endpoints

### Get Task
```http
GET /api/tasks/:id
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "task-id",
    "name": "Task Name",
    "date": "2024-01-01T00:00:00.000Z"
  }
}
```

**Error Response:**
```json
{
  "success": false,
  "error": "Task with id: invalid-id not found"
}
```

## 🏛️ Architecture Layers

### 1. Domain Layer (`src/domain/`)
Contains the core business logic and rules:

- **Entities**: Core business objects (`Task`)
- **Repository Interfaces**: Contracts for data access
- **Use Cases**: Application-specific business rules

### 2. Data Layer (`src/data/`)
Handles data persistence and external services:

- **Database**: MongoDB connection management
- **Models**: Mongoose schemas and models
- **Repositories**: Concrete implementations of repository interfaces

### 3. Presentation Layer (`src/presentation/`)
Handles external communication:

- **API Endpoints**: REST API handlers with validation
- **Request/Response**: HTTP request handling and response formatting

## 🔧 Key Design Patterns

### Dependency Injection
```typescript
const repository = new TaskRepository();
const useCase = GetTaskUseCase(repository);
export const handler = getTaskEndpoint(useCase);
```

### Repository Pattern
```typescript
export interface TaskRepositoryInterface {
  findById(id: string): Promise<Task | null>;
  create(task: Omit<Task, 'id'>): Promise<Task>;
  // ... other methods
}
```

### Use Case Pattern
```typescript
export const GetTaskUseCase = (
  TaskRepository: TaskRepositoryInterface,
): GetTaskUseCaseInterface => {
  return {
    execute: async (id: string): Promise<Task> => {
      const task = await TaskRepository.findById(id);
      if (!task) throw new Error(`Task with id: ${id} not found`);
      return task;
    },
  };
};
```

## 🧪 Example Usage

```typescript
// Create a new task
const createUseCase = CreateTaskUseCase(repository);
const task = await createUseCase.execute({
  name: "Learn Clean Architecture",
  date: new Date()
});

// Get a task
const getUseCase = GetTaskUseCase(repository);
const foundTask = await getUseCase.execute(task.id);
```

## 📁 Project Structure

```
clean-architecture-example/
├── src/
│   ├── domain/
│   │   ├── entities/
│   │   │   └── task.entity.ts
│   │   ├── repository-interface/
│   │   │   └── task.repository.interface.ts
│   │   └── use-cases/
│   │       ├── create-task.use-case.ts
│   │       ├── get-task.use-case.ts
│   │       ├── get-all-tasks.use-case.ts
│   │       ├── update-task.use-case.ts
│   │       └── delete-task.use-case.ts
│   ├── data/
│   │   ├── database.ts
│   │   ├── models/
│   │   │   └── task.model.ts
│   │   └── repositories/
│   │       └── task.repository.ts
│   └── presentation/
│       └── api/
│           ├── get-task.endpoint.ts
│           ├── api-handler.ts
│           └── server.ts
├── package.json
├── tsconfig.json
├── bun.lock
└── README.md
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details

---

This project was created using [Bun](https://bun.sh) - a fast all-in-one JavaScript runtime.
