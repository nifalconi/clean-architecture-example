import type { Task } from '../../domain/entities/task.entity';
import type { TaskDocument } from '../models/task.model';

// Persistence → domain. Drops Mongo-only fields (_id, createdAt, updatedAt)
// so the domain entity never leaks infrastructure concerns.
export const toEntity = (doc: TaskDocument): Task => ({
  id: doc.id,
  name: doc.name,
  date: doc.date,
});
