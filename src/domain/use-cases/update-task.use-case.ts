import type { Task } from '../entities/task.entity';
import type { TaskRepositoryInterface } from '../repository-interface/task.repository.interface';

export interface UpdateTaskUseCaseInterface {
  execute: (id: string, updates: Partial<Omit<Task, 'id'>>) => Promise<Task>;
}

export const UpdateTaskUseCase = (
  TaskRepository: TaskRepositoryInterface,
): UpdateTaskUseCaseInterface => {
  return {
    execute: async (id: string, updates: Partial<Omit<Task, 'id'>>): Promise<Task> => {
      const updatedTask = await TaskRepository.update(id, updates);
      if (!updatedTask)
        throw new Error(`Task with id: ${id} not found`);

      console.log('Task Updated', updatedTask);

      return updatedTask;
    },
  };
};
