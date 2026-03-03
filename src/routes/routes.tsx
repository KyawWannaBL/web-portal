import React, { Suspense, lazy } from "react";
import type { RouteObject } from "react-router-dom";
import AppLayout from "../ui/AppLayout";
import { PATHS } from "./paths";
import { RequireAuth } from "../state/auth";
import LoginPage from "../views/LoginPage";
import NotFoundPage from "../views/NotFoundPage";

// Lazy load the REAL UI components you built
const AdminDashboard = lazy(() => import("@/pages/AdminDashboard"));
const AccountControl = lazy(() => import("@/pages/AccountControl"));
const AccountingHome = lazy(() => import("@/pages/AccountingHome"));
const WayManagement = lazy(() => import("@/pages/WayManagement"));

// Sleek loading screen for heavy components
const Loading = () => (
  <div style={{ display: 'flex', height: '100%', minHeight: '50vh', width: '100%', alignItems: 'center', justifyContent: 'center', color: '#0ea5e9', fontFamily: 'monospace', letterSpacing: '0.1em' }}>
    [ INITIALIZING SECURE MODULE... ]
  </div>
);

export const routes: RouteObject[] = [
  { path: PATHS.login, element: <LoginPage /> },
  {
    path: PATHS.commandCenter,
    element: (
      <RequireAuth>
        <AppLayout />
      </RequireAuth>
    ),
    children: [
      { index: true, element: <Suspense fallback={<Loading />}><AdminDashboard /></Suspense> },
      { path: "account-control", element: <Suspense fallback={<Loading />}><AccountControl /></Suspense> },
      { path: "account-approvals", element: <Suspense fallback={<Loading />}><AccountControl /></Suspense> },
      { path: "global-finance", element: <Suspense fallback={<Loading />}><AccountingHome /></Suspense> },
      { path: "shipment-control", element: <Suspense fallback={<Loading />}><WayManagement /></Suspense> },
      // Catch-all fallback
      { path: "*", element: <NotFoundPage /> }
    ]
  }
];