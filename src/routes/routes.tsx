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
      { path: PATHS.accountApprovals.slice(1), element: <GenericPage titleKey="accountApprovals" /> },
      { path: PATHS.shipmentControl.slice(1), element: <GenericPage titleKey="shipmentControl" /> },
      { path: PATHS.fleetCommand.slice(1), element: <GenericPage titleKey="fleetCommand" /> },
      { path: PATHS.globalFinance.slice(1), element: <GenericPage titleKey="globalFinance" /> },
      { path: PATHS.liveTelemetry.slice(1), element: <GenericPage titleKey="liveTelemetry" /> },
      { path: PATHS.systemTariffs.slice(1), element: <GenericPage titleKey="systemTariffs" /> },
      { path: PATHS.accountControl.slice(1), element: <AccountControlPage /> },
      { path: PATHS.hrPortal.slice(1), element: <HRPortalPage /> },
      { path: "*", element: <NotFoundPage /> }
    ]
  }
];
