import * as React from "react";
import { Navigate } from "react-router-dom";
import { useAuth } from "@/auth/AuthProvider";

export function RequireRole({
  allow,
  children,
}: {
  allow: string[];
  children: React.ReactNode;
}) {
  const { role, loading } = useAuth();

  if (loading) return <div className="p-6 text-sm">Loading…</div>;
  if (!allow?.length) return <>{children}</>;
  if (!role || !allow.includes(role)) return <Navigate to="/unauthorized" replace />;

  return <>{children}</>;
}
