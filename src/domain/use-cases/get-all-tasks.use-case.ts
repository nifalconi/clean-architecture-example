import type { Task } from '../entities/task.entity';
import type { TaskRepositoryInterface } from '../repository-interface/task.repository.interface';

export interface GetAllTasksUseCaseInterface {
  execute: () => Promise<Task[]>;
}

export const GetAllTasksUseCase = (
  TaskRepository: TaskRepositoryInterface,
): GetAllTasksUseCaseInterface => {
  return {
    execute: async (): Promise<Task[]> => {
      const tasks = await TaskRepository.findAll();

      console.log('All Tasks Retrieved', { count: tasks.length });

      return tasks;
    },
  };
};
