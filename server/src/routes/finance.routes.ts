import { Router } from 'express';
import * as financeController from '../controllers/finance.controller.js';
import { validate } from '../middlewares/validate.middleware.js';
import { requireAuth } from '../middlewares/auth.middleware.js';
import {
  createTransactionSchema, updateTransactionSchema,
  createBudgetSchema, updateBudgetSchema,
  createGoalSchema, updateGoalSchema
} from '../schemas/finance.schemas.js';

const router = Router();

// All finance routes require authentication
router.use(requireAuth);

// ─── TRANSACTIONS ───────────────────────────────────
router.get('/transactions', financeController.getTransactions);
router.post('/transactions', validate(createTransactionSchema), financeController.createTransaction);
router.patch('/transactions/:id', validate(updateTransactionSchema), financeController.updateTransaction);
router.delete('/transactions/:id', financeController.deleteTransaction);

// ─── BUDGETS ────────────────────────────────────────
router.get('/budgets', financeController.getBudgets);
router.post('/budgets', validate(createBudgetSchema), financeController.createBudget);
router.patch('/budgets/:id', validate(updateBudgetSchema), financeController.updateBudget);
router.delete('/budgets/:id', financeController.deleteBudget);

// ─── GOALS ──────────────────────────────────────────
router.get('/goals', financeController.getGoals);
router.post('/goals', validate(createGoalSchema), financeController.createGoal);
router.patch('/goals/:id', validate(updateGoalSchema), financeController.updateGoal);
router.delete('/goals/:id', financeController.deleteGoal);

export default router;
