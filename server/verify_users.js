import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

dotenv.config({ path: join(__dirname, '.env') });

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

const supabase = createClient(supabaseUrl, supabaseKey);

async function verifyUsers() {
  console.log('Fetching users...');
  const { data: { users }, error } = await supabase.auth.admin.listUsers();
  
  if (error) {
    console.error('Error fetching users:', error);
    return;
  }

  let verifiedCount = 0;
  for (const user of users) {
    if (!user.email_confirmed_at) {
      console.log(`Verifying user: ${user.email}`);
      const { error: updateError } = await supabase.auth.admin.updateUserById(user.id, { email_confirm: true });
      if (updateError) {
        console.error(`Error verifying ${user.email}:`, updateError);
      } else {
        verifiedCount++;
        console.log(`Successfully verified ${user.email}`);
      }
    }
  }
  console.log(`Done! Automatically verified ${verifiedCount} users.`);
}

verifyUsers();
