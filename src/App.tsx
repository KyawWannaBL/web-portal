import React, { Suspense } from "react";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import { LanguageProvider, useLanguage } from "./contexts/LanguageContext";
import AdminLayout from "./components/AdminLayout";
import Login from "./pages/Login";
import SuperAdminDashboard from "./pages/SuperAdminDashboard";
import AccountControl from "./pages/AccountControl";
import HRPortal from "./pages/HRPortal";
import Unauthorized from "./pages/Unauthorized";
import { RequireAuth } from "@/routes/RequireAuth";
import { RequireRole } from "@/routes/RequireRole";

// New Modules imported here
import ShipmentControl from "./pages/ShipmentControl";
import FleetCommand from "./pages/FleetCommand";
import OmniFinance from "./pages/OmniFinance";
import LiveMap from "./pages/LiveMap";
import SystemTariffs from "./pages/SystemTariffs";

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
                
                {/* Properly mapped dynamic routes */}
                <Route path="approvals" element={<AccountControl />} />
                <Route path="accounts" element={<AccountControl />} />
                <Route path="hr" element={<HRPortal />} />
                <Route path="shipments" element={<ShipmentControl />} />
                <Route path="fleet" element={<FleetCommand />} />
                <Route path="omni-finance" element={<OmniFinance />} />
                <Route path="live-map" element={<LiveMap />} />
                <Route path="settings" element={<SystemTariffs />} />
              </Route>
            </Route>
            <Route path="*" element={<Navigate to="/login" replace />} />
          </Routes>
        </Router>
      </Suspense>
    </LanguageProvider>
  );
}
