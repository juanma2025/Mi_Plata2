import type { Request, Response } from 'express';
import { env } from '../config/env.js';
import { sendSuccess, sendError, sendCreated } from '../utils/apiResponse.js';
import type { AuthenticatedRequest } from '../types/index.js';

async function getFinanceService() {
  if (env.DEMO_MODE) {
    return import('../services/finance.mock.js');
  }
  return import('../services/finance.service.js');
}

// â”€â”€â”€ TRANSACTIONS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

export async function getTransactions(req: Request, res: Response) {
  try {
    const service = await getFinanceService();
    const authReq = req as AuthenticatedRequest;
    const limit = parseInt(req.query.limit as string) || 50;
    const offset = parseInt(req.query.offset as string) || 0;
    const data = await service.getTransactions(authReq.accessToken, limit, offset);
    sendSuccess(res, data);
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}

export async function createTransaction(req: Request, res: Response) {
  try {
    const service = await getFinanceService();
    const authReq = req as AuthenticatedRequest;
    const data = await service.createTransaction(authReq.accessToken, authReq.user.id, req.body);
    sendCreated(res, data, 'TransacciÃ³n registrada');
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}

export async function updateTransaction(req: Request, res: Response) {
  try {
    const service = await getFinanceService();
    const authReq = req as AuthenticatedRequest;
    const data = await service.updateTransaction(authReq.accessToken, (req.params.id as string), req.body);
    sendSuccess(res, data, 'TransacciÃ³n actualizada');
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}

export async function deleteTransaction(req: Request, res: Response) {
  try {
    const service = await getFinanceService();
    const authReq = req as AuthenticatedRequest;
    await service.deleteTransaction(authReq.accessToken, (req.params.id as string));
    sendSuccess(res, null, 'TransacciÃ³n eliminada');
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}

// â”€â”€â”€ BUDGETS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

export async function getBudgets(req: Request, res: Response) {
  try {
    const service = await getFinanceService();
    const authReq = req as AuthenticatedRequest;
    const month = (req.query.month as string) || new Date().toISOString().substring(0, 7);
    const data = await service.getBudgets(authReq.accessToken, month);
    sendSuccess(res, data);
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}

export async function createBudget(req: Request, res: Response) {
  try {
    const service = await getFinanceService();
    const authReq = req as AuthenticatedRequest;
    const data = await service.createBudget(authReq.accessToken, authReq.user.id, req.body);
    sendCreated(res, data, 'Presupuesto creado');
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}

export async function updateBudget(req: Request, res: Response) {
  try {
    const service = await getFinanceService();
    const authReq = req as AuthenticatedRequest;
    const data = await service.updateBudget(authReq.accessToken, (req.params.id as string), req.body);
    sendSuccess(res, data, 'Presupuesto actualizado');
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}

export async function deleteBudget(req: Request, res: Response) {
  try {
    const service = await getFinanceService();
    const authReq = req as AuthenticatedRequest;
    await service.deleteBudget(authReq.accessToken, (req.params.id as string));
    sendSuccess(res, null, 'Presupuesto eliminado');
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}

// â”€â”€â”€ GOALS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

export async function getGoals(req: Request, res: Response) {
  try {
    const service = await getFinanceService();
    const authReq = req as AuthenticatedRequest;
    const data = await service.getGoals(authReq.accessToken);
    sendSuccess(res, data);
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}

export async function createGoal(req: Request, res: Response) {
  try {
    const service = await getFinanceService();
    const authReq = req as AuthenticatedRequest;
    const data = await service.createGoal(authReq.accessToken, authReq.user.id, req.body);
    sendCreated(res, data, 'Meta creada');
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}

export async function updateGoal(req: Request, res: Response) {
  try {
    const service = await getFinanceService();
    const authReq = req as AuthenticatedRequest;
    const data = await service.updateGoal(authReq.accessToken, (req.params.id as string), req.body);
    sendSuccess(res, data, 'Meta actualizada');
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}

export async function deleteGoal(req: Request, res: Response) {
  try {
    const service = await getFinanceService();
    const authReq = req as AuthenticatedRequest;
    await service.deleteGoal(authReq.accessToken, (req.params.id as string));
    sendSuccess(res, null, 'Meta eliminada');
  } catch (err) {
    sendError(res, (err as Error).message);
  }
}
