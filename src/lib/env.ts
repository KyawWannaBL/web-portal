export function validateEnv(): { ok: true } | { ok: false; missing: string[] } {
  const required = ["VITE_SUPABASE_URL", "VITE_SUPABASE_ANON_KEY"] as const;
  const missing = required.filter((k) => !import.meta.env[k] || String(import.meta.env[k]).trim() === "");
  return missing.length ? { ok: false, missing } : { ok: true };
}
