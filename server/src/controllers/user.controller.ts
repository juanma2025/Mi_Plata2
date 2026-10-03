import type { Request, Response } from 'express';
import { env } from '../config/env.js';
import { sendSuccess, sendError } from '../utils/apiResponse.js';
import type { AuthenticatedRequest } from '../types/index.js';

async function getUserService() {
  if (env.DEMO_MODE) {
    return import('../services/user.mock.js');
  }
  return import('../services/user.service.js');
}

// ─── GET /user/profile ──────────────────────────────
export async function getProfile(req: Request, res: Response) {
  try {
    const userService = await getUserService();
    const authReq = req as AuthenticatedRequest;
    const profile = await userService.getProfile(authReq.user, authReq.accessToken);
    sendSuccess(res, profile);
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}

// ─── PATCH /user/profile ────────────────────────────
export async function updateProfile(req: Request, res: Response) {
  try {
    const userService = await getUserService();
    const authReq = req as AuthenticatedRequest;
    const profile = await userService.updateProfile(authReq.user.id, req.body, authReq.accessToken);
    sendSuccess(res, profile, 'Perfil actualizado exitosamente');
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}

// ─── POST /user/onboarding ──────────────────────────
export async function saveOnboarding(req: Request, res: Response) {
  try {
    const userService = await getUserService();
    const authReq = req as AuthenticatedRequest;
    const profile = await userService.saveOnboarding(authReq.user.id, req.body, authReq.accessToken);
    sendSuccess(res, profile, 'Configuración completada exitosamente');
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}

// ─── DELETE /user/account ───────────────────────────
export async function deleteAccount(req: Request, res: Response) {
  try {
    const userService = await getUserService();
    const authReq = req as AuthenticatedRequest;
    await userService.deleteAccount(authReq.user.id);
    sendSuccess(res, null, 'Cuenta eliminada exitosamente');
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}
