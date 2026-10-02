import { createUserClient } from '../config/supabase.js';
import { logger } from '../utils/logger.js';
import type { 
  CreateTransactionInput, UpdateTransactionInput,
  CreateBudgetInput, UpdateBudgetInput,
  CreateGoalInput, UpdateGoalInput
} from '../schemas/finance.schemas.js';

// ─── TRANSACTIONS ───────────────────────────────────

export async function getTransactions(accessToken: string, limit = 50, offset = 0) {
  const client = createUserClient(accessToken);
  const { data, error, count } = await client
    .from('transactions')
    .select('*', { count: 'exact' })
    .order('date', { ascending: false })
    .order('created_at', { ascending: false })
    .range(offset, offset + limit - 1);

  if (error) {
    logger.error('Finance: Get transactions failed', { error: error.message });
    throw new Error('Error al obtener transacciones');
  }

  return { transactions: data, total: count };
}

export async function createTransaction(accessToken: string, userId: string, input: CreateTransactionInput) {
  const client = createUserClient(accessToken);
  const { data, error } = await client
    .from('transactions')
    .insert([{ ...input, user_id: userId }])
    .select()
    .single();

  if (error) {
    logger.error('Finance: Create transaction failed', { error: error.message });
    throw new Error('Error al crear transacción');
  }

  return data;
}

export async function updateTransaction(accessToken: string, id: string, input: UpdateTransactionInput) {
  const client = createUserClient(accessToken);
  const { data, error } = await client
    .from('transactions')
    .update(input)
    .eq('id', id)
    .select()
    .single();

  if (error) {
    logger.error('Finance: Update transaction failed', { error: error.message });
    throw new Error('Error al actualizar transacción');
  }

  return data;
}

export async function deleteTransaction(accessToken: string, id: string) {
  const client = createUserClient(accessToken);
  const { error } = await client
    .from('transactions')
    .delete()
    .eq('id', id);

  if (error) {
    logger.error('Finance: Delete transaction failed', { error: error.message });
    throw new Error('Error al eliminar transacción');
  }
}

// ─── BUDGETS ────────────────────────────────────────

export async function getBudgets(accessToken: string, month: string) {
  const client = createUserClient(accessToken);
  const { data, error } = await client
    .from('budgets')
    .select('*')
    .eq('month', month)
    .order('created_at', { ascending: false });

  if (error) {
    logger.error('Finance: Get budgets failed', { error: error.message });
    throw new Error('Error al obtener presupuestos');
  }

  return data;
}

export async function createBudget(accessToken: string, userId: string, input: CreateBudgetInput) {
  const client = createUserClient(accessToken);
  
  // Note: RLS ensures users can only create for themselves, but we explicitly pass user_id
  const { data, error } = await client
    .from('budgets')
    .insert([{ ...input, user_id: userId }])
    .select()
    .single();

  if (error) {
    logger.error('Finance: Create budget failed', { error: error.message });
    if (error.code === '23505') { // Unique violation
      throw new Error('Ya existe un presupuesto para esta categoría en este mes');
    }
    throw new Error('Error al crear presupuesto');
  }

  return data;
}

export async function updateBudget(accessToken: string, id: string, input: UpdateBudgetInput) {
  const client = createUserClient(accessToken);
  const { data, error } = await client
    .from('budgets')
    .update(input)
    .eq('id', id)
    .select()
    .single();

  if (error) {
    logger.error('Finance: Update budget failed', { error: error.message });
    throw new Error('Error al actualizar presupuesto');
  }

  return data;
}

export async function deleteBudget(accessToken: string, id: string) {
  const client = createUserClient(accessToken);
  const { error } = await client
    .from('budgets')
    .delete()
    .eq('id', id);

  if (error) {
    logger.error('Finance: Delete budget failed', { error: error.message });
    throw new Error('Error al eliminar presupuesto');
  }
}

// ─── GOALS ──────────────────────────────────────────

export async function getGoals(accessToken: string) {
  const client = createUserClient(accessToken);
  const { data, error } = await client
    .from('goals')
    .select('*')
    .order('created_at', { ascending: false });

  if (error) {
    logger.error('Finance: Get goals failed', { error: error.message });
    throw new Error('Error al obtener metas');
  }

  return data;
}

export async function createGoal(accessToken: string, userId: string, input: CreateGoalInput) {
  const client = createUserClient(accessToken);
  const { data, error } = await client
    .from('goals')
    .insert([{ ...input, user_id: userId }])
    .select()
    .single();

  if (error) {
    logger.error('Finance: Create goal failed', { error: error.message });
    throw new Error('Error al crear meta');
  }

  return data;
}

export async function updateGoal(accessToken: string, id: string, input: UpdateGoalInput) {
  const client = createUserClient(accessToken);
  const { data, error } = await client
    .from('goals')
    .update(input)
    .eq('id', id)
    .select()
    .single();

  if (error) {
    logger.error('Finance: Update goal failed', { error: error.message });
    throw new Error('Error al actualizar meta');
  }

  return data;
}

export async function deleteGoal(accessToken: string, id: string) {
  const client = createUserClient(accessToken);
  const { error } = await client
    .from('goals')
    .delete()
    .eq('id', id);

  if (error) {
    logger.error('Finance: Delete goal failed', { error: error.message });
    throw new Error('Error al eliminar meta');
  }
}
