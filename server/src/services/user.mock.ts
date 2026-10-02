/**
 * Mock User Service — simulates user operations for demo/testing.
 */
import { logger } from '../utils/logger.js';
import type { UpdateProfileInput } from '../schemas/user.schemas.js';

// In-memory profile store
const profiles = new Map<string, {
  id: string;
  email: string;
  name: string;
  avatar_url: string | null;
  created_at: string;
  updated_at: string;
}>();

export async function getProfile(user: { id: string; email?: string; user_metadata?: Record<string, unknown>; created_at?: string }) {
  const existing = profiles.get(user.id);
  if (existing) return existing;

  const profile = {
    id: user.id,
    email: user.email ?? 'demo@miplata.com',
    name: (user.user_metadata?.name as string) ?? 'Usuario Demo',
    avatar_url: null,
    created_at: user.created_at ?? new Date().toISOString(),
    updated_at: new Date().toISOString(),
  };

  profiles.set(user.id, profile);
  return profile;
}

export async function updateProfile(userId: string, input: UpdateProfileInput) {
  const profile = profiles.get(userId) ?? {
    id: userId,
    email: 'demo@miplata.com',
    name: 'Usuario Demo',
    avatar_url: null,
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  };

  if (input.name !== undefined) profile.name = input.name;
  if (input.avatar_url !== undefined) profile.avatar_url = input.avatar_url;
  profile.updated_at = new Date().toISOString();

  profiles.set(userId, profile);
  logger.info('Mock User: Profile updated', { userId });

  return profile;
}

export async function deleteAccount(userId: string) {
  profiles.delete(userId);
  logger.info('Mock User: Account deleted', { userId });
}
