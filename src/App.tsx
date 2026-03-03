import React, { Suspense } from "react";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import { LanguageProvider, useLanguage } from "./contexts/LanguageContext";

import AdminLayout from "./components/AdminLayout";
import Login from "./pages/Login";
import SignUp from "./pages/SignUp";
import ForgotPassword from "./pages/ForgotPassword";
import SuperAdminDashboard from "./pages/SuperAdminDashboard";
import AccountControl from "./pages/AccountControl";
import HRPortal from "./pages/HRPortal";

import AuthCallback from "./pages/AuthCallback";
import SecurityUpdate from "./pages/SecurityUpdate";
import Unauthorized from "./pages/Unauthorized";

import { RequireAuth } from "@/routes/RequireAuth";
import { RequirePasswordRotation } from "@/routes/RequirePasswordRotation";
import { RequireRole } from "@/routes/RequireRole";

const Loading = () => {
  const { lang } = useLanguage();
  return (
    <div className="min-h-screen bg-[#05080F] flex flex-center justify-center font-mono space-y-4">
      <div className="text-[10px] text-emerald-500 tracking-widest uppercase animate-pulse">
        {lang === 'en' ? 'INITIALIZING L5 SECURE GATEWAY...' : 'L5 လုံခြုံရေးဂိတ်ကို စတင်နေပါသည်...'}
      </div>
    </div>
  );
};

export default function App() {
  return (
    <LanguageProvider>
      <Suspense fallback={<Loading />}>
        <Router>
          <Routes>
            {/* Public */}
            <Route path="/login" element={<Login />} />
            <Route path="/signup" element={<SignUp />} />
            <Route path="/forgot-password" element={<ForgotPassword />} />
            <Route path="/auth/callback" element={<AuthCallback />} />

            {/* Policy enforcement */}
            <Route path="/security-update" element={<SecurityUpdate />} />
            <Route path="/unauthorized" element={<Unauthorized />} />

            {/* Protected */}
            <Route element={<RequireAuth />}>
              <Route element={<RequirePasswordRotation />}>
                <Route
                  path="/admin"
                  element={
                    <RequireRole
                      allow={[
                        "SYS",            // System Overlord Bypass
                        "APP_OWNER",      // MD Bypass
                        "SUPER_ADMIN",    // IT Admin Bypass
                        "SUPER_A",        // Truncation Fallback
                        "OPERATIONS_ADMIN",
                        "FINANCE_ADMIN",
                        "MARKETING_ADMIN",
                        "CUSTOMER_SERVICE_ADMIN",
                        "MGR",
                      ]}
                    >
                      <AdminLayout />
                    </RequireRole>
                  }
                >
                  <Route index element={<Navigate to="dashboard" replace />} />
                  <Route path="dashboard" element={<SuperAdminDashboard />} />
                  <Route path="accounts" element={<AccountControl />} />
                  <Route path="hr" element={<HRPortal />} />
                </Route>
              </Route>
            </Route>

            {/* Defaults */}
            <Route path="/" element={<Navigate to="/login" replace />} />
            <Route path="*" element={<Navigate to="/login" replace />} />
          </Routes>
        </Router>
      </Suspense>
    </LanguageProvider>
  );
}
