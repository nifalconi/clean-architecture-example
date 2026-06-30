import { Schema, model, type InferSchemaType } from 'mongoose';

export const TaskSchema = new Schema(
  {
    id: { type: String, required: true, unique: true },
    name: { type: String, required: true },
    date: { type: Date, required: true },
  },
  { timestamps: true },
);

// The persistence shape — distinct from the domain `Task` entity.
// Includes Mongo concerns (timestamps, _id) the domain must not know about.
export type TaskDocument = InferSchemaType<typeof TaskSchema>;

export const TaskModel = model('Task', TaskSchema);
