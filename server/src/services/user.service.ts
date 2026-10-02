import { supabaseAdmin } from '../config/supabase.js';
import { logger } from '../utils/logger.js';
import type { UpdateProfileInput } from '../schemas/user.schemas.js';
import type { User } from '@supabase/supabase-js';

// ─── Get Profile ────────────────────────────────────
export async function getProfile(user: User) {
  return {
    id: user.id,
    email: user.email ?? '',
    name: user.user_metadata?.name ?? '',
    avatar_url: user.user_metadata?.avatar_url ?? null,
    created_at: user.created_at,
    updated_at: user.updated_at ?? user.created_at,
  };
}

// ─── Update Profile ─────────────────────────────────
export async function updateProfile(userId: string, input: UpdateProfileInput) {
  const updateData: Record<string, unknown> = {};

  if (input.name !== undefined) updateData.name = input.name;
  if (input.avatar_url !== undefined) updateData.avatar_url = input.avatar_url;

  const { data, error } = await supabaseAdmin.auth.admin.updateUserById(userId, {
    user_metadata: updateData,
  });

  if (error) {
    logger.error('User: Profile update failed', { userId, error: error.message });
    throw new Error('Error al actualizar el perfil');
  }

  logger.info('User: Profile updated', { userId });

  return {
    id: data.user.id,
    email: data.user.email ?? '',
    name: data.user.user_metadata?.name ?? '',
    avatar_url: data.user.user_metadata?.avatar_url ?? null,
    created_at: data.user.created_at,
    updated_at: data.user.updated_at ?? data.user.created_at,
  };
}

// ─── Delete Account ─────────────────────────────────
export async function deleteAccount(userId: string) {
  const { error } = await supabaseAdmin.auth.admin.deleteUser(userId);

  if (error) {
    logger.error('User: Account deletion failed', { userId, error: error.message });
    throw new Error('Error al eliminar la cuenta');
  }

  logger.info('User: Account deleted', { userId });
}
