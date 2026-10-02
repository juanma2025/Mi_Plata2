import type { Request } from 'express';
import type { User } from '@supabase/supabase-js';

// ─── Authenticated Request ─────────────────────────
export interface AuthenticatedRequest extends Request {
  user: User;
  accessToken: string;
}

// ─── API Response Envelope ──────────────────────────
export interface ApiResponse<T = unknown> {
  success: boolean;
  data?: T;
  message?: string;
  error?: string;
}

// ─── MFA Types ──────────────────────────────────────
export interface MfaEnrollResponse {
  id: string;
  type: 'totp';
  totp: {
    qr_code: string;
    secret: string;
    uri: string;
  };
}

export interface MfaChallengeResponse {
  id: string;
  factorId: string;
}

// ─── User Profile ───────────────────────────────────
export interface UserProfile {
  id: string;
  email: string;
  name: string;
  avatar_url?: string;
  created_at: string;
  updated_at: string;
}

// ─── Gemini Chat ────────────────────────────────────
export interface ChatMessage {
  role: 'user' | 'assistant';
  content: string;
}

export interface ChatRequest {
  message: string;
  history?: ChatMessage[];
}

export interface ChatResponse {
  reply: string;
}

// ─── Transaction Types (future use) ─────────────────
export type TransactionType = 'income' | 'expense';

export interface Transaction {
  id: string;
  user_id: string;
  name: string;
  amount: number;
  type: TransactionType;
  category: string;
  date: string;
  notes?: string;
  created_at: string;
}

// ─── Budget Types (future use) ──────────────────────
export interface Budget {
  id: string;
  user_id: string;
  category: string;
  limit_amount: number;
  spent_amount: number;
  month: string; // YYYY-MM
  created_at: string;
}

// ─── Goal Types (future use) ────────────────────────
export interface Goal {
  id: string;
  user_id: string;
  name: string;
  target_amount: number;
  saved_amount: number;
  deadline?: string;
  created_at: string;
}
