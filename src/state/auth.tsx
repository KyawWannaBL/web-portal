import * as React from "react";
import { Navigate, useLocation, useNavigate } from "react-router-dom";
import { PATHS } from "../routes/paths";

export type User = { id: string; email: string; name: string; token: string; };

type AuthContextValue = { 
  user: User | null; 
  login: (email: string, password: string) => Promise<void>; 
  logout: () => void; 
};

const AuthContext = React.createContext<AuthContextValue | null>(null);
const STORAGE_KEY = "britium.session";

export function AuthProvider(props: { children: React.ReactNode }) {
  const [user, setUser] = React.useState<User | null>(() => {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return null;
    try {
      const parsed = JSON.parse(raw) as User;
      return parsed?.id && parsed?.token ? parsed : null;
    } catch { return null; }
  });

  const login = React.useCallback(async (email: string, password: string) => {
    // TODO: Replace with real API implementation (e.g. Supabase/Firebase)
    // const response = await fetch('/api/auth/login', { method: 'POST', body: JSON.stringify({ email, password }) });
    // const data = await response.json();
    
    // Simulating network request for production readiness
    await new Promise(resolve => setTimeout(resolve, 800));
    
    const sessionData: User = { 
      id: "usr_" + Math.random().toString(36).slice(2, 9), 
      email: email,
      name: email.split("@")[0] || "User", 
      token: "jwt_token_placeholder" 
    };
    
    setUser(sessionData);
    localStorage.setItem(STORAGE_KEY, JSON.stringify(sessionData));
  }, []);

  const logout = React.useCallback(() => {
    setUser(null);
    localStorage.removeItem(STORAGE_KEY);
  }, []);

  return <AuthContext.Provider value={{ user, login, logout }}>{props.children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = React.useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
}

export function RequireAuth(props: { children: React.ReactNode }) {
  const { user } = useAuth();
  const location = useLocation();
  if (!user) return <Navigate to={PATHS.login} replace state={{ from: location.pathname }} />;
  return <>{props.children}</>;
}

export function useSignOutAndRedirect() {
  const { logout } = useAuth();
  const navigate = useNavigate();
  return React.useCallback(() => {
    logout();
    navigate(PATHS.login, { replace: true });
  }, [navigate, logout]);
}
