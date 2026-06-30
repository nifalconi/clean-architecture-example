import { z } from 'zod';
import type { Task } from '../../domain/entities/task.entity';
import type { GetTaskUseCaseInterface } from '../../domain/use-cases/get-task.use-case';

const RequestSchema = z.object({
  params: z.object({
    id: z.string().min(1),
  }),
});

type RequestType = z.infer<typeof RequestSchema>;

const validate = (request: unknown): RequestType => {
  try {
    return RequestSchema.parse(request);
  } catch (error) {
    throw new Error(`${(error as z.ZodError).issues[0]?.message}`);
  }
};

// you could use cache here
export const getTaskEndpoint =
  (useCase: GetTaskUseCaseInterface) =>
  async (request: unknown): Promise<Task> => {
    const {
      params: { id },
    } = validate(request);

    return useCase.execute(id);
  };
