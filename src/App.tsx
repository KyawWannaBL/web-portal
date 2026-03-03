import React, { Suspense } from "react";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import { LanguageProvider } from "./contexts/LanguageContext";
import AdminLayout from "./components/AdminLayout";
import Login from "./pages/Login";
import SuperAdminDashboard from "./pages/SuperAdminDashboard";
import AccountControl from "./pages/AccountControl";
import HRPortal from "./pages/HRPortal";
import Unauthorized from "./pages/Unauthorized";
import { RequireAuth } from "@/routes/RequireAuth";
import { RequireRole } from "@/routes/RequireRole";

const Loading = () => <div className="bg-[#05080F] min-h-screen" />;

export default function App() {
  return (
    <LanguageProvider>
      <Suspense fallback={<Loading />}>
        <Router>
          <Routes>
            {/* Public Routes */}
            <Route path="/login" element={<Login />} />
            <Route path="/unauthorized" element={<Unauthorized />} />

            {/* Protected Admin Routes */}
            <Route element={<RequireAuth />}>
              <Route path="/admin" element={
                <RequireRole allow={["SYS", "APP_OWNER", "SUPER_ADMIN", "SUPER_A"]}>
                  <AdminLayout />
                </RequireRole>
              }>
                {/* These match the button paths in AdminLayout.tsx */}
                <Route index element={<Navigate to="dashboard" replace />} />
                <Route path="dashboard" element={<SuperAdminDashboard />} />
                <Route path="approvals" element={<AccountControl />} />
                <Route path="accounts" element={<AccountControl />} />
                <Route path="hr" element={<HRPortal />} />
                
                {/* Fallbacks for menu buttons not yet built */}
                <Route path="shipments" element={<SuperAdminDashboard />} />
                <Route path="fleet" element={<SuperAdminDashboard />} />
                <Route path="omni-finance" element={<SuperAdminDashboard />} />
                <Route path="live-map" element={<SuperAdminDashboard />} />
                <Route path="settings" element={<SuperAdminDashboard />} />
              </Route>
            </Route>

            <Route path="/" element={<Navigate to="/login" replace />} />
            <Route path="*" element={<Navigate to="/login" replace />} />
          </Routes>
        </Router>
      </Suspense>
    </LanguageProvider>
  );
}
