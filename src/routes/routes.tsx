import React, { Suspense, lazy } from "react";
import type { RouteObject } from "react-router-dom";
import { Outlet } from "react-router-dom";
import { PATHS } from "./paths";
import { RequireAuth } from "../state/auth";

// Lazy load your actual production components
const AdminDashboard = lazy(() => import("@/pages/AdminDashboard"));
const AccountControl = lazy(() => import("@/pages/AccountControl"));
const FinancialManagement = lazy(() => import("@/pages/admin/accounting/FinancialManagementPage"));
const WayManagement = lazy(() => import("@/pages/WayManagement"));
const Login = lazy(() => import("@/pages/Login"));

// A sleek loading screen while your heavy components load
const Loading = () => (
  <div className="min-h-screen bg-[#0B101B] flex items-center justify-center">
    <div className="text-sky-500 font-mono text-sm tracking-widest animate-pulse">
      [ INITIALIZING L5 SECURE MODULE... ]
    </div>
  </div>
);

export const routes: RouteObject[] = [
  { 
    path: PATHS.login, 
    element: <Suspense fallback={<Loading />}><Login /></Suspense> 
  },
  {
    path: PATHS.commandCenter,
    element: (
      <RequireAuth>
        {/* If you have a global Sidebar/TopBar component, wrap this Outlet inside it! */}
        <div className="app-root min-h-screen bg-[#0B101B]">
          <Suspense fallback={<Loading />}>
            <Outlet />
          </Suspense>
        </div>
      </RequireAuth>
    ),
    children: [
      { index: true, element: <AdminDashboard /> },
      { path: PATHS.accountControl.replace('/', ''), element: <AccountControl /> },
      { path: PATHS.globalFinance.replace('/', ''), element: <FinancialManagement /> },
      { path: PATHS.shipmentControl.replace('/', ''), element: <WayManagement /> },
      // Add the rest of your page mappings here!
    ]
  }
];
