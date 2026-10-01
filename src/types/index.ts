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
  name: string;
  email: string;
  initials: string;
}
