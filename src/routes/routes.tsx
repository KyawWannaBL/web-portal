import type { RouteObject } from "react-router-dom";
import AppLayout from "../ui/AppLayout";
import { PATHS } from "./paths";

import LoginPage from "../views/LoginPage";
import CommandCenterPage from "../views/CommandCenterPage";
import GenericPage from "../views/GenericPage";
import AccountControlPage from "../views/AccountControlPage";
import HRPortalPage from "../views/HRPortalPage";
import NotFoundPage from "../views/NotFoundPage";
import { RequireAuth } from "../state/auth";

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
      { index: true, element: <CommandCenterPage /> },
      // Fixed: Using absolute paths directly without .slice(1)
      { path: PATHS.accountApprovals, element: <GenericPage titleKey="accountApprovals" /> },
      { path: PATHS.shipmentControl, element: <GenericPage titleKey="shipmentControl" /> },
      { path: PATHS.fleetCommand, element: <GenericPage titleKey="fleetCommand" /> },
      { path: PATHS.globalFinance, element: <GenericPage titleKey="globalFinance" /> },
      { path: PATHS.liveTelemetry, element: <GenericPage titleKey="liveTelemetry" /> },
      { path: PATHS.systemTariffs, element: <GenericPage titleKey="systemTariffs" /> },
      { path: PATHS.accountControl, element: <AccountControlPage /> },
      { path: PATHS.hrPortal, element: <HRPortalPage /> },
      { path: "*", element: <NotFoundPage /> }
    ]
  }
];