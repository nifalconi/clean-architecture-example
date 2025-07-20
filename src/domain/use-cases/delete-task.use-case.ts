import type { TaskRepositoryInterface } from '../repository-interface/task.repository.interface';

export interface DeleteTaskUseCaseInterface {
  execute: (id: string) => Promise<void>;
}
 
export const DeleteTaskUseCase = (
  TaskRepository: TaskRepositoryInterface,
): DeleteTaskUseCaseInterface => {
  return {
    execute: async (id: string): Promise<void> => {
      const deleted = await TaskRepository.delete(id);
      if (!deleted)
        throw new Error(`Task with id: ${id} not found`);

      console.log('Task Deleted', { id });
    },
  };
};
