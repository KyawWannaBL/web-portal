import React, { Suspense, lazy } from "react";
import type { RouteObject } from "react-router-dom";
import AppLayout from "../ui/AppLayout";
import { PATHS } from "./paths";
import { RequireAuth } from "../state/auth";
import LoginPage from "../views/LoginPage";
import NotFoundPage from "../views/NotFoundPage";

// Lazy load the REAL UI components you uploaded
const AdminDashboard = lazy(() => import("@/pages/AdminDashboard"));
const AccountControl = lazy(() => import("@/pages/AccountControl"));
const AccountingHome = lazy(() => import("@/pages/AccountingHome"));
const WayManagement = lazy(() => import("@/pages/WayManagement"));

// Sleek loading screen for heavy components
const Loading = () => (
  <div className="flex h-full w-full items-center justify-center p-20">
    <div className="text-sky-500 font-mono text-sm tracking-widest animate-pulse">
      [ INITIALIZING L5 SECURE MODULE... ]
    </div>
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
      { path: PATHS.accountControl.slice(1), element: <Suspense fallback={<Loading />}><AccountControl /></Suspense> },
      { path: PATHS.accountApprovals.slice(1), element: <Suspense fallback={<Loading />}><AccountControl /></Suspense> },
      { path: PATHS.globalFinance.slice(1), element: <Suspense fallback={<Loading />}><AccountingHome /></Suspense> },
      { path: PATHS.shipmentControl.slice(1), element: <Suspense fallback={<Loading />}><WayManagement /></Suspense> },
      // Catch-all fallback
      { path: "*", element: <NotFoundPage /> }
    ]
  }
];
