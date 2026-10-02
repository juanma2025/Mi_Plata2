import type { Request, Response, NextFunction } from 'express';
import { logger } from '../utils/logger.js';
import { env } from '../config/env.js';

/**
 * Global error handler — catches all unhandled errors.
 * Never reveals stack traces or internal details in production.
 */
export function errorHandler(err: Error, _req: Request, res: Response, _next: NextFunction) {
  logger.error('Unhandled error', {
    message: err.message,
    stack: env.NODE_ENV === 'development' ? err.stack : undefined,
  });

  const statusCode = 'statusCode' in err ? (err as Error & { statusCode: number }).statusCode : 500;

  res.status(statusCode).json({
    success: false,
    error: env.NODE_ENV === 'production'
      ? 'Ha ocurrido un error interno. Intenta de nuevo más tarde.'
      : err.message,
  });
}

/**
 * Catches 404s for undefined routes.
 */
export function notFoundHandler(_req: Request, res: Response) {
  res.status(404).json({
    success: false,
    error: 'Recurso no encontrado',
  });
}
