import React, { Suspense, lazy } from "react";
import type { RouteObject } from "react-router-dom";
import { PATHS } from "./paths";
import { RequireAuth } from "../state/auth";
import AppLayout from "../ui/AppLayout";

// Lazy load your actual production components
const Login = lazy(() => import("@/pages/Login"));
const AdminDashboard = lazy(() => import("@/pages/AdminDashboard"));
const AccountControl = lazy(() => import("@/pages/AccountControl"));
const FinancialManagement = lazy(() => import("@/pages/admin/accounting/FinancialManagementPage"));
const WayManagement = lazy(() => import("@/pages/WayManagement"));

// A sleek loading screen while your heavy components load
const Loading = () => (
  <div className="flex h-[50vh] w-full items-center justify-center">
    <div className="text-sky-500 font-mono text-sm tracking-widest animate-pulse">
      [ INITIALIZING SECURE MODULE... ]
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
        <AppLayout />
      </RequireAuth>
    ),
    children: [
      { index: true, element: <Suspense fallback={<Loading />}><AdminDashboard /></Suspense> },
      { path: PATHS.accountControl.replace('/', ''), element: <Suspense fallback={<Loading />}><AccountControl /></Suspense> },
      { path: PATHS.globalFinance.replace('/', ''), element: <Suspense fallback={<Loading />}><FinancialManagement /></Suspense> },
      { path: PATHS.shipmentControl.replace('/', ''), element: <Suspense fallback={<Loading />}><WayManagement /></Suspense> },
      
      // Catch-all route to prevent blank screens if a module isn't linked yet
      { path: "*", element: <Suspense fallback={<Loading />}><AdminDashboard /></Suspense> }
    ]
  }
];
