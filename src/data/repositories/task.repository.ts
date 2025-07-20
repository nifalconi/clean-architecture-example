import type { Task } from '../../domain/entities/task.entity';
import type { TaskRepositoryInterface } from '../../domain/repository-interface/task.repository.interface';
import { TaskModel } from '../models/task.model';

export class TaskRepository implements TaskRepositoryInterface {
  async create(task: Omit<Task, 'id'>): Promise<Task> {
    const newTask = new TaskModel({
      ...task,
      id: this.generateId(),
    });

    const savedTask = await newTask.save();
    return savedTask.toObject();
  }

  async findById(id: string): Promise<Task | null> {
    const task = await TaskModel.findOne({ id }).lean();
    return task;
  }

  async findAll(): Promise<Task[]> {
    const tasks = await TaskModel.find({}).lean();
    return tasks;
  }

  async update(id: string, updates: Partial<Omit<Task, 'id'>>): Promise<Task | null> {
    const updatedTask = await TaskModel.findOneAndUpdate(
      { id },
      updates,
      { new: true, lean: true }
    );

    return updatedTask;
  }

  async delete(id: string): Promise<boolean> {
    const result = await TaskModel.deleteOne({ id });
    return result.deletedCount > 0;
  }

  private generateId(): string {
    return Math.random().toString(36).substring(2) + Date.now().toString(36);
  }
}
