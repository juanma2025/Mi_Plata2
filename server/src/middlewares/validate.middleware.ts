import type { Request, Response, NextFunction } from 'express';
import type { ZodSchema } from 'zod';
import { sendError } from '../utils/apiResponse.js';

/**
 * Middleware factory that validates request data against a Zod schema.
 * The schema should define `body`, `params`, and/or `query` objects.
 */
export function validate(schema: ZodSchema) {
  return (req: Request, res: Response, next: NextFunction) => {
    const result = schema.safeParse({
      body: req.body,
      params: req.params,
      query: req.query,
    });

    if (!result.success) {
      const errors = result.error.issues.map((issue) => ({
        field: issue.path.join('.'),
        message: issue.message,
      }));

      // Return the first error message for simplicity
      sendError(res, errors[0]?.message ?? 'Datos de entrada inválidos', 422);
      return;
    }

    // Replace request data with validated+transformed data
    if (result.data.body) req.body = result.data.body;
    if (result.data.params) req.params = result.data.params;
    if (result.data.query) req.query = result.data.query;

    next();
  };
}
