import type { Response } from 'express';
import type { ApiResponse } from '../types/index.js';

/**
 * Standardized API response helpers.
 * All responses follow the same envelope format.
 */
export function sendSuccess<T>(res: Response, data: T, message?: string, statusCode = 200) {
  const body: ApiResponse<T> = {
    success: true,
    data,
    message,
  };
  res.status(statusCode).json(body);
}

export function sendError(res: Response, error: string, statusCode = 400) {
  const body: ApiResponse = {
    success: false,
    error,
  };
  res.status(statusCode).json(body);
}

export function sendCreated<T>(res: Response, data: T, message?: string) {
  sendSuccess(res, data, message, 201);
}
