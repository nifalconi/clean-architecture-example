import { TaskRepository } from '../../data/repositories/task.repository';
import { GetTaskUseCase } from '../../domain/use-cases/get-task.use-case';
import { getTaskEndpoint } from './get-task.endpoint';

/**
 * Composition root: the single place where concrete dependencies are wired
 * into the object graph. Add one line per endpoint here as the app grows;
 * server.ts stays thin and knows nothing about repositories or use cases.
 */
export function buildHandlers() {
  const taskRepository = new TaskRepository();

  return {
    getTask: getTaskEndpoint(GetTaskUseCase(taskRepository)),
  };
}

export type Handlers = ReturnType<typeof buildHandlers>;
