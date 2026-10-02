import type { Request, Response } from 'express';
import { env } from '../config/env.js';
import { sendSuccess, sendError } from '../utils/apiResponse.js';

async function getGeminiService() {
  if (env.DEMO_MODE) {
    return import('../services/gemini.mock.js');
  }
  return import('../services/gemini.service.js');
}

// ─── POST /chat ─────────────────────────────────────
export async function chat(req: Request, res: Response) {
  try {
    const geminiService = await getGeminiService();
    const reply = await geminiService.chat(req.body);
    sendSuccess(res, { reply }, 'Respuesta generada');
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}
