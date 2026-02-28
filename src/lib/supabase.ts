import { createClient } from '@supabase/supabase-js';

// Environment variables must be prefixed with VITE_ for the bundler to include them in the APK
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  console.error("APK CONFIG ERROR: Missing Production Backend Keys");
}

export const supabase = createClient(supabaseUrl || '', supabaseAnonKey || '');
