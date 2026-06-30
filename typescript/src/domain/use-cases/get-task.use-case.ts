import type { Task } from '../entities/task.entity';
import type { TaskRepositoryInterface } from '../repository-interface/task.repository.interface';

export interface GetTaskUseCaseInterface {
  execute: (id: string) => Promise<Task>;
}

export const GetTaskUseCase = (
  TaskRepository: TaskRepositoryInterface,
): GetTaskUseCaseInterface => {
  return {
    execute: async (id: string): Promise<Task> => {
      const task = await TaskRepository.findById(id);
      if (!task)
        throw new Error(`Task with id: ${id} not found`);

      console.log('Task Retrieved', task);

      return task;
    },
  };
};
