import React, { Suspense } from "react";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import { LanguageProvider, useLanguage } from "./contexts/LanguageContext";
import AdminLayout from "./components/AdminLayout";
import Login from "./pages/Login";
import SuperAdminDashboard from "./pages/SuperAdminDashboard";
import Unauthorized from "./pages/Unauthorized";
import { RequireAuth } from "@/routes/RequireAuth";
import { RequireRole } from "@/routes/RequireRole";

const Loading = () => {
  const { lang } = useLanguage();
  return (
    <div className="min-h-screen bg-[#05080F] flex flex-col items-center justify-center font-mono text-emerald-500">
      <div className="animate-pulse uppercase tracking-widest text-[10px]">
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
            <Route path="/login" element={<Login />} />
            <Route path="/unauthorized" element={<Unauthorized />} />
            <Route element={<RequireAuth />}>
              <Route path="/admin" element={
                <RequireRole allow={["SYS", "APP_OWNER", "SUPER_ADMIN", "SUPER_A", "MGR"]}>
                  <AdminLayout />
                </RequireRole>
              }>
                <Route index element={<Navigate to="dashboard" replace />} />
                <Route path="dashboard" element={<SuperAdminDashboard />} />
              </Route>
            </Route>
            <Route path="*" element={<Navigate to="/login" replace />} />
          </Routes>
        </Router>
      </Suspense>
    </LanguageProvider>
  );
}
