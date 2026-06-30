import { Database } from '../../data/database';
import { buildHandlers } from './composition-root';

const handlers = buildHandlers();

const server = Bun.serve({
  port: 3000,
  async fetch(req) {
    const url = new URL(req.url);
    const method = req.method;

    console.log(`${method} ${url.pathname}`);

    // Route: GET /api/tasks/:id
    if (method === 'GET' && url.pathname.match(/^\/api\/tasks\/[^\/]+$/)) {
      try {
        const pathSegments = url.pathname.split('/').filter(Boolean);
        const id = pathSegments[pathSegments.length - 1];

        if (!id) {
          throw new Error('Task ID is required');
        }

        const task = await handlers.getTask({ params: { id } });

        return new Response(JSON.stringify({
          success: true,
          data: task
        }), {
          status: 200,
          headers: { 'Content-Type': 'application/json' }
        });
      } catch (error) {
        const errorMessage = error instanceof Error ? error.message : 'Unknown error';
        const statusCode = errorMessage.includes('not found') ? 404 : 400;

        return new Response(JSON.stringify({
          success: false,
          error: errorMessage
        }), {
          status: statusCode,
          headers: { 'Content-Type': 'application/json' }
        });
      }
    }

    // 404 for unmatched routes
    return new Response(JSON.stringify({
      success: false,
      error: 'Route not found',
    }), {
      status: 404,
      headers: { 'Content-Type': 'application/json' },
    });
  },
});

// Connect to database when server starts
await Database.connect();

console.log(`Server running on http://localhost:${server.port}`);

export default server;
