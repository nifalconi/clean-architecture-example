import mongoose from 'mongoose';

export class Database {
  static async connect(connectionString: string = 'mongodb://localhost:27017/tasks'): Promise<void> {
    try {
      await mongoose.connect(connectionString);
      console.log('Connected to MongoDB');
    } catch (error) {
      console.error('Error connecting to MongoDB:', error);
      throw error;
    }
  }

  static async disconnect(): Promise<void> {
    try {
      await mongoose.disconnect();
      console.log('Disconnected from MongoDB');
    } catch (error) {
      console.error('Error disconnecting from MongoDB:', error);
      throw error;
    }
  }
}
