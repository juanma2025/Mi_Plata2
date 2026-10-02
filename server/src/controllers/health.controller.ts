import type { Request, Response } from 'express';
import { sendSuccess } from '../utils/apiResponse.js';

// ─── GET /health ────────────────────────────────────
export function healthCheck(_req: Request, res: Response) {
  sendSuccess(res, {
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
}
