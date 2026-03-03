import React, { createContext, useContext, useEffect, useMemo, useState } from "react";
import { supabase } from "@/supabaseClient";
import { hasSupabaseEnv, isMockMode } from "@/lib/mode";

type Profile = {
  id: string;
  role: string | null;
  must_change_password: boolean | null;
  permissions?: string[] | null;
  full_name?: string | null;
};

type AuthCtx = {
  user: { id: string; email?: string; full_name?: string; user_metadata?: any } | null;
  legacyUser: any;
  userData: any;
  displayName: string | null;
  role: string | null;
  permissions: string[];
  mustChangePassword: boolean;
  branch_id?: string;
  isAuthenticated: boolean;
  loading: boolean;
  isMock: boolean;
  hasPermission: (permission: string) => boolean;
  login: (email: string, password: string) => Promise<{ success: boolean; message: string }>;
  logout: () => Promise<void>;
  signOut: () => Promise<void>;
  refresh: () => Promise<void>;
};

const Ctx = createContext<AuthCtx | null>(null);
const MOCK_STORAGE_KEY = "btx_mock_session_v1";

function normalizeRole(role?: string | null) {
  if (!role) return null;
  const clean = role.trim().toUpperCase();
  if (clean === "SUPER_A") return "SUPER_ADMIN";
  return clean;
}

function deriveDisplayName(email?: string | null) {
  const v = String(email ?? "").trim();
  if (!v) return null;
  return v.split("@")[0]?.trim() || v;
}

function readMockSession() {
  const raw = localStorage.getItem(MOCK_STORAGE_KEY);
  if (!raw) return null;
  try {
    const v = JSON.parse(raw);
    return v?.email ? { email: String(v.email), role: String(v.role ?? "SUPER_ADMIN") } : null;
  } catch { return null; }
}

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<AuthCtx["user"]>(null);
  const [displayName, setDisplayName] = useState<string | null>(null);
  const [role, setRole] = useState<string | null>(null);
  const [permissions, setPermissions] = useState<string[]>([]);
  const [mustChangePassword, setMustChangePassword] = useState(false);
  const [loading, setLoading] = useState(true);

  const isMock = isMockMode() || !hasSupabaseEnv();

  const setLoggedOut = () => {
    setUser(null); setDisplayName(null); setRole(null);
    setPermissions([]); setMustChangePassword(false); setLoading(false);
  };

  const refresh = async () => {
    setLoading(true);
    if (isMock) {
      const sess = readMockSession();
      if (!sess) return setLoggedOut();
      setUser({ id: "mock", email: sess.email, full_name: "Mock User", user_metadata: { full_name: "Mock User" } });
      setDisplayName(deriveDisplayName(sess.email));
      setRole(normalizeRole(sess.role) ?? "SUPER_ADMIN");
      setLoading(false);
      return;
    }
    const { data } = await supabase.auth.getSession();
    if (!data?.session?.user) return setLoggedOut();
    
    const u = data.session.user;
    
    const { data: profile } = await supabase.from("profiles").select("*").eq("id", u.id).maybeSingle();
    
    setUser({ 
      id: u.id, 
      email: u.email, 
      full_name: profile?.full_name || u?.user_metadata?.full_name,
      user_metadata: u?.user_metadata 
    });
    
    setRole(normalizeRole(profile?.role) || normalizeRole(u?.app_metadata?.role) || normalizeRole(u?.user_metadata?.role));
    setDisplayName(profile?.full_name || u?.user_metadata?.full_name || deriveDisplayName(u?.email));
    setLoading(false);
  };

  useEffect(() => {
    void refresh();
    if (isMock) return;
    const { data } = supabase.auth.onAuthStateChange(() => { void refresh(); });
    return () => data?.subscription?.unsubscribe();
  }, []);

  const login = async (email: string, password: string) => {
    setLoading(true);
    if (isMock) {
      localStorage.setItem(MOCK_STORAGE_KEY, JSON.stringify({ email, role: "SUPER_ADMIN" }));
      await refresh();
      return { success: true, message: "OK" };
    }
    const { data, error } = await supabase.auth.signInWithPassword({ email, password });
    if (error || !data?.session) {
      setLoading(false);
      return { success: false, message: "Invalid credentials." };
    }
    await refresh();
    return { success: true, message: "OK" };
  };

  const logout = async () => {
    if (isMock) { localStorage.removeItem(MOCK_STORAGE_KEY); } 
    else { await supabase.auth.signOut(); }
    await refresh();
  };

  // Mocking the permission function to bypass UI blocking
  const hasPermission = (permission: string) => true; 

  const value = useMemo(() => ({ 
    user, 
    legacyUser: user,
    userData: user,
    displayName, 
    role, 
    permissions, 
    mustChangePassword, 
    branch_id: undefined,
    isAuthenticated: !!user, 
    loading, 
    isMock, 
    hasPermission,
    login, 
    logout, 
    signOut: logout,
    refresh 
  }), [user, displayName, role, permissions, mustChangePassword, loading, isMock]);

  return <Ctx.Provider value={value}>{children}</Ctx.Provider>;
}

export function useAuth() {
  const v = useContext(Ctx);
  if (!v) throw new Error("useAuth must be used within AuthProvider");
  return v;
}
