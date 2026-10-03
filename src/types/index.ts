export type TransactionType = 'income' | 'expense';

export interface Transaction {
  id: string;
  name: string;
  category: string;
  date: string;
  type: TransactionType;
  amount: number;
}

export interface Goal {
  id: string;
  name: string;
  description: string;
  currentAmount: number;
  targetAmount: number;
}

export interface Budget {
  category: string;
  spent: number;
  total: number;
}

export interface User {
  id?: string;
  name: string;
  email: string;
  initials?: string;
  monthly_income?: number;
  main_income_source?: string;
  approximate_monthly_expenses?: number;
  monthly_budget?: number;
  savings_goal?: number;
  main_expense_categories?: string[];
  onboarding_completed?: boolean;
}
