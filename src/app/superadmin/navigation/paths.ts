export const PATHS = {
  commandCenter: "/command-center",

  approvals: {
    accounts: "/approvals/accounts",
  },

  operations: {
    shipments: "/operations/shipments",
    fleet: "/operations/fleet",
    hubs: "/operations/hubs",
    warehouses: "/operations/warehouses",
  },

  finance: {
    overview: "/finance/overview",
    billing: "/finance/billing",
  },

  telemetry: {
    live: "/telemetry/live",
    monitoring: "/telemetry/monitoring",
  },

  admin: {
    tenants: "/admin/tenants",
    users: "/admin/users",
    roles: "/admin/roles",
    audit: "/admin/audit",
    apiKeys: "/admin/api-keys",
    integrations: "/admin/integrations",
  },

  system: {
    settingsHome: "/system/settings",
    tariffs: "/system/settings/tariffs",
    shippingCalculator: "/system/settings/shipping-calculator",
    featureFlags: "/system/settings/feature-flags",
    notifications: "/system/settings/notifications",
    security: "/system/settings/security",
    localization: "/system/settings/localization",
  },

  reports: "/reports",
} as const;

export type PathValue =
  | typeof PATHS.commandCenter
  | typeof PATHS.approvals.accounts
  | typeof PATHS.operations.shipments
  | typeof PATHS.operations.fleet
  | typeof PATHS.operations.hubs
  | typeof PATHS.operations.warehouses
  | typeof PATHS.finance.overview
  | typeof PATHS.finance.billing
  | typeof PATHS.telemetry.live
  | typeof PATHS.telemetry.monitoring
  | typeof PATHS.admin.tenants
  | typeof PATHS.admin.users
  | typeof PATHS.admin.roles
  | typeof PATHS.admin.audit
  | typeof PATHS.admin.apiKeys
  | typeof PATHS.admin.integrations
  | typeof PATHS.system.settingsHome
  | typeof PATHS.system.tariffs
  | typeof PATHS.system.shippingCalculator
  | typeof PATHS.system.featureFlags
  | typeof PATHS.system.notifications
  | typeof PATHS.system.security
  | typeof PATHS.system.localization
  | typeof PATHS.reports;
