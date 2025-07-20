/**
 * Example usage of the Clean Architecture implementation
 * 
 * This file demonstrates how to use the use cases directly
 * without going through the API layer.
 */

import { Database } from './src/data/database';
import { TaskRepository } from './src/data/repositories/task.repository';
import { CreateTaskUseCase } from './src/domain/use-cases/create-task.use-case';
import { DeleteTaskUseCase } from './src/domain/use-cases/delete-task.use-case';
import { GetAllTasksUseCase } from './src/domain/use-cases/get-all-tasks.use-case';
import { GetTaskUseCase } from './src/domain/use-cases/get-task.use-case';
import { UpdateTaskUseCase } from './src/domain/use-cases/update-task.use-case';

async function example() {
  try {
    // Connect to MongoDB
    await Database.connect();

    // Create repository instance
    const taskRepository = new TaskRepository();

    // Initialize use cases with dependency injection
    const createTaskUseCase = CreateTaskUseCase(taskRepository);
    const getTaskUseCase = GetTaskUseCase(taskRepository);
    const getAllTasksUseCase = GetAllTasksUseCase(taskRepository);
    const updateTaskUseCase = UpdateTaskUseCase(taskRepository);
    const deleteTaskUseCase = DeleteTaskUseCase(taskRepository);

    console.log('🚀 Clean Architecture Example\n');

    // Create a new task
    console.log('1. Creating a new task...');
    const newTask = await createTaskUseCase.execute({
      name: 'Learn Clean Architecture',
      date: new Date(),
    });
    console.log('✅ Task created:', newTask);

    // Get the task by ID
    console.log('\n2. Getting task by ID...');
    const foundTask = await getTaskUseCase.execute(newTask.id);
    console.log('✅ Task found:', foundTask);

    // Get all tasks
    console.log('\n3. Getting all tasks...');
    const allTasks = await getAllTasksUseCase.execute();
    console.log('✅ All tasks:', allTasks);

    // Update the task
    console.log('\n4. Updating the task...');
    const updatedTask = await updateTaskUseCase.execute(newTask.id, {
      name: 'Master Clean Architecture',
    });
    console.log('✅ Task updated:', updatedTask);

    // Delete the task
    console.log('\n5. Deleting the task...');
    await deleteTaskUseCase.execute(newTask.id);
    console.log('✅ Task deleted successfully');

    console.log('\n🎉 Example completed successfully!');

  } catch (error) {
    console.error('❌ Error:', error);
  } finally {
    // Disconnect from MongoDB
    await Database.disconnect();
  }
}

// Run the example
example();
