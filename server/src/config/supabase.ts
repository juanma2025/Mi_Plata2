import { createClient } from '@supabase/supabase-js';
import { env } from './env.js';

/**
 * Public Supabase client — uses the anon key.
 * Used for operations where the user's JWT provides the authorization context.
 * This is safe to use in request handlers where the user token is passed.
 */
export const supabasePublic = createClient(env.SUPABASE_URL, env.SUPABASE_ANON_KEY);

/**
 * Admin Supabase client — uses the service role key.
 * NEVER expose this client or its key to the frontend.
 * Used only for server-side admin operations (user management, etc.)
 */
export const supabaseAdmin = createClient(env.SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY, {
  auth: {
    autoRefreshToken: false,
    persistSession: false,
  },
});

/**
 * Creates a Supabase client scoped to a user's JWT.
 * This ensures Row Level Security (RLS) policies are enforced for the user.
 */
export function createUserClient(accessToken: string) {
  return createClient(env.SUPABASE_URL, env.SUPABASE_ANON_KEY, {
    global: {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    },
  });
}
