import React, { createContext, useContext, useEffect, useMemo, useState } from "react";
import { supabase } from "@/supabaseClient";
import { isMockMode, MOCK_SESSION_KEY } from "@/lib/mode";

type AuthCtx = {
  user: { id: string; email?: string } | null;
  role: string | null;
  isAuthenticated: boolean;
  loading: boolean;
  isMock: boolean;
  login: (email: string, password: string) => Promise<{ success: boolean; message: string }>;
  logout: () => Promise<void>;
};

const Ctx = createContext<AuthCtx | null>(null);

function readMockSession(): { email: string; role: string } | null {
  const raw = localStorage.getItem(MOCK_SESSION_KEY);
  if (!raw) return null;
  try {
    const v = JSON.parse(raw) as any;
    if (!v?.email) return null;
    return { email: String(v.email), role: String(v.role ?? "SUPER_ADMIN") };
  } catch {
    return null;
  }
}

function writeMockSession(email: string, role: string) {
  localStorage.setItem(MOCK_SESSION_KEY, JSON.stringify({ email, role, at: Date.now() }));
}

function clearMockSession() {
  localStorage.removeItem(MOCK_SESSION_KEY);
}

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<AuthCtx["user"]>(null);
  const [role, setRole] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  const isMock = isMockMode();

  const refresh = async () => {
    setLoading(true);

    if (isMock) {
      const sess = readMockSession();
      if (!sess) {
        setUser(null);
        setRole(null);
        setLoading(false);
        return;
      }
      setUser({ id: "mock", email: sess.email });
      setRole(sess.role);
      setLoading(false);
      return;
    }

    const { data } = await supabase.auth.getSession();
    const u = data?.session?.user;
    if (!u) {
      setUser(null);
      setRole(null);
      setLoading(false);
      return;
    }
    setUser({ id: u.id, email: u.email });
    setRole(String((u as any)?.app_metadata?.role ?? (u as any)?.user_metadata?.role ?? "USER"));
    setLoading(false);
  };

  useEffect(() => {
    void refresh();
    if (isMock) return;
    const { data } = supabase.auth.onAuthStateChange(() => void refresh());
    return () => data?.subscription?.unsubscribe();
  }, []);

  const login = async (email: string, password: string) => {
    setLoading(true);
    if (isMock) {
      const e = email.trim();
      if (!e) {
        setLoading(false);
        return { success: false, message: "Missing email" };
      }
      writeMockSession(e, "SUPER_ADMIN");
      await refresh();
      return { success: true, message: "OK" };
    }

    const { data, error } = await supabase.auth.signInWithPassword({ email, password });
    if (error || !data?.session) {
      setLoading(false);
      return { success: false, message: "Invalid credentials" };
    }
    await refresh();
    return { success: true, message: "OK" };
  };

  const logout = async () => {
    if (isMock) {
      clearMockSession();
      await refresh();
      return;
    }
    await supabase.auth.signOut();
    await refresh();
  };

  const value = useMemo<AuthCtx>(
    () => ({
      user,
      role,
      isAuthenticated: !!user,
      loading,
      isMock,
      login,
      logout,
    }),
    [user, role, loading, isMock]
  );

  return <Ctx.Provider value={value}>{children}</Ctx.Provider>;
}

export function useAuth() {
  const v = useContext(Ctx);
  if (!v) throw new Error("useAuth must be used within AuthProvider");
  return v;
}
