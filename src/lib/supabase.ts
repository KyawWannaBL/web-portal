import { createClient } from '@supabase/supabase-js';

// Use import.meta.env for Vite projects
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

// Log a warning instead of crashing during the build phase
if (!supabaseUrl || !supabaseAnonKey) {
  console.warn("Backend Connection Warning: Supabase credentials not found in environment.");
}

export const supabase = createClient(
  supabaseUrl || 'https://placeholder.supabase.co', 
  supabaseAnonKey || 'placeholder'
);
