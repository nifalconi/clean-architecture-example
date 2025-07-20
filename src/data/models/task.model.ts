import { Schema, model } from 'mongoose';
import type { Task } from '../../domain/entities/task.entity';

export const TaskSchema = new Schema<Task>(
  {
    id: { type: String, required: true, unique: true },
    name: { type: String, required: true },
    date: { type: Date, required: true },
  },
  {
    timestamps: true,
    toObject: { virtuals: true },
    toJSON: { virtuals: true },
  },
);

export const TaskModel = model<Task>('Task', TaskSchema);
