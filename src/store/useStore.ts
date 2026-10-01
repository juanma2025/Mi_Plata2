import { create } from 'zustand';
import type { Transaction, Goal, Budget, User } from '../types';

interface StoreState {
  user: User;
  transactions: Transaction[];
  goals: Goal[];
  budgets: Budget[];
  addTransaction: (tx: Omit<Transaction, 'id'>) => void;
  deleteTransaction: (id: string) => void;
  addGoal: (goal: Omit<Goal, 'id'>) => void;
}

export const useStore = create<StoreState>((set) => ({
  user: {
    name: 'Juan Manuel',
    email: 'juan@email.com',
    initials: 'JM',
  },
  transactions: [
    { id: '1', name: "Almuerzo universitario", category: "Alimentación", date: "30 Sep", type: "expense", amount: 18000 },
    { id: '2', name: "Pago freelance", category: "Trabajo", date: "29 Sep", type: "income", amount: 450000 },
    { id: '3', name: "Transporte", category: "Transporte", date: "28 Sep", type: "expense", amount: 12000 },
    { id: '4', name: "Curso online", category: "Educación", date: "27 Sep", type: "expense", amount: 85000 },
    { id: '5', name: "Café", category: "Ocio", date: "26 Sep", type: "expense", amount: 9000 }
  ],
  goals: [
    { id: '1', name: "MacBook", description: "Compra de equipo", currentAmount: 3600000, targetAmount: 5000000 },
    { id: '2', name: "Viaje", description: "Vacaciones", currentAmount: 880000, targetAmount: 2000000 },
    { id: '3', name: "Emergencias", description: "Fondo de seguridad", currentAmount: 620000, targetAmount: 2000000 }
  ],
  budgets: [
    { category: "Alimentación", spent: 280000, total: 500000 },
    { category: "Transporte", spent: 145000, total: 250000 },
    { category: "Educación", spent: 210000, total: 400000 },
    { category: "Ocio", spent: 120000, total: 200000 }
  ],
  addTransaction: (tx) => set((state) => ({ 
    transactions: [{ ...tx, id: Math.random().toString(36).substr(2, 9) }, ...state.transactions] 
  })),
  deleteTransaction: (id) => set((state) => ({
    transactions: state.transactions.filter(t => t.id !== id)
  })),
  addGoal: (goal) => set((state) => ({
    goals: [...state.goals, { ...goal, id: Math.random().toString(36).substr(2, 9) }]
  }))
}));
