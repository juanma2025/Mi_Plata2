import { z } from 'zod';

// ─── TRANSACTIONS ───────────────────────────────────

export const createTransactionSchema = z.object({
  body: z.object({
    name: z.string().min(1, 'El nombre es requerido').max(100, 'El nombre es muy largo').trim(),
    amount: z.number().positive('El monto debe ser positivo'),
    type: z.enum(['income', 'expense'], { required_error: 'El tipo debe ser income o expense' }),
    category: z.string().min(1, 'La categoría es requerida').trim(),
    date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'La fecha debe estar en formato YYYY-MM-DD'),
    notes: z.string().max(500, 'Las notas son muy largas').optional(),
  }),
});

export const updateTransactionSchema = z.object({
  body: z.object({
    name: z.string().min(1).max(100).trim().optional(),
    amount: z.number().positive().optional(),
    type: z.enum(['income', 'expense']).optional(),
    category: z.string().min(1).trim().optional(),
    date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
    notes: z.string().max(500).optional().nullable(),
  }),
});

// ─── BUDGETS ────────────────────────────────────────

export const createBudgetSchema = z.object({
  body: z.object({
    category: z.string().min(1, 'La categoría es requerida').trim(),
    limit_amount: z.number().positive('El límite debe ser positivo'),
    month: z.string().regex(/^\d{4}-\d{2}$/, 'El mes debe estar en formato YYYY-MM'),
  }),
});

export const updateBudgetSchema = z.object({
  body: z.object({
    limit_amount: z.number().positive('El límite debe ser positivo'),
  }),
});

// ─── GOALS ──────────────────────────────────────────

export const createGoalSchema = z.object({
  body: z.object({
    name: z.string().min(1, 'El nombre es requerido').max(100).trim(),
    target_amount: z.number().positive('El monto objetivo debe ser positivo'),
    deadline: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'La fecha debe estar en formato YYYY-MM-DD').optional(),
  }),
});

export const updateGoalSchema = z.object({
  body: z.object({
    name: z.string().min(1).max(100).trim().optional(),
    target_amount: z.number().positive().optional(),
    saved_amount: z.number().min(0).optional(),
    deadline: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional().nullable(),
  }),
});

// Types
export type CreateTransactionInput = z.infer<typeof createTransactionSchema>['body'];
export type UpdateTransactionInput = z.infer<typeof updateTransactionSchema>['body'];

export type CreateBudgetInput = z.infer<typeof createBudgetSchema>['body'];
export type UpdateBudgetInput = z.infer<typeof updateBudgetSchema>['body'];

export type CreateGoalInput = z.infer<typeof createGoalSchema>['body'];
export type UpdateGoalInput = z.infer<typeof updateGoalSchema>['body'];
