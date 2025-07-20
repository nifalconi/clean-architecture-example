import type { Task } from '../entities/task.entity';

export interface TaskRepositoryInterface {
  create(task: Omit<Task, 'id'>): Promise<Task>;
  findById(id: string): Promise<Task | null>;
  findAll(): Promise<Task[]>;
  update(id: string, updates: Partial<Omit<Task, 'id'>>): Promise<Task | null>;
  delete(id: string): Promise<boolean>;
}
