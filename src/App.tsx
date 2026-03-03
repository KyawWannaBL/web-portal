import React from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import AdminLayout from "@/components/AdminLayout";
import RequireAuth from "@/routes/RequireAuth";

import Login from "@/pages/Login";
import SuperAdminDashboard from "@/pages/SuperAdminDashboard";

import AdminApprovals from "@/pages/admin/AdminApprovals";
import AdminAccounts from "@/pages/admin/AdminAccounts";
import AdminHR from "@/pages/admin/AdminHR";
import AdminShipments from "@/pages/admin/AdminShipments";
import AdminFleet from "@/pages/admin/AdminFleet";
import AdminFinance from "@/pages/admin/AdminFinance";
import AdminLiveMap from "@/pages/admin/AdminLiveMap";
import AdminSettings from "@/pages/admin/AdminSettings";

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Navigate to="/login" replace />} />
        <Route path="/login" element={<Login />} />

        <Route
          path="/admin"
          element={
            <RequireAuth>
              <AdminLayout />
            </RequireAuth>
          }
        >
          <Route path="dashboard" element={<SuperAdminDashboard />} />
          <Route path="approvals" element={<AdminApprovals />} />
          <Route path="accounts" element={<AdminAccounts />} />
          <Route path="hr" element={<AdminHR />} />
          <Route path="shipments" element={<AdminShipments />} />
          <Route path="fleet" element={<AdminFleet />} />
          <Route path="omni-finance" element={<AdminFinance />} />
          <Route path="live-map" element={<AdminLiveMap />} />
          <Route path="settings" element={<AdminSettings />} />
          <Route index element={<Navigate to="dashboard" replace />} />
        </Route>

        <Route path="*" element={<Navigate to="/login" replace />} />
      </Routes>
    </BrowserRouter>
  );
}
