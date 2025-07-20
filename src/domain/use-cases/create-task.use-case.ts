import type { Task } from '../entities/task.entity';
import type { TaskRepositoryInterface } from '../repository-interface/task.repository.interface';

export interface CreateTaskUseCaseInterface {
  execute: (taskData: Omit<Task, 'id'>) => Promise<Task>;
}

export const CreateTaskUseCase = (
  TaskRepository: TaskRepositoryInterface,
): CreateTaskUseCaseInterface => {
  return {
    execute: async (taskData: Omit<Task, 'id'>): Promise<Task> => {
      const task = await TaskRepository.create(taskData);

      console.log('Task Created', task);

      return task;
    },
  };
};
