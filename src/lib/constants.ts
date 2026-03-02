/**
 * BRITIUM EXPRESS L5 - ENTERPRISE DATA CORE
 * Includes Bilingual Support for Myanmar/English Operations
 */

export const USER_ROLES = {
  APP_OWNER: 'App Owner',
  SUPER_ADMIN: 'Super Administrator',
  OPERATIONS_ADMIN: 'Operations Administrator',
  FINANCE_ADMIN: 'Finance Administrator',
  MARKETING_ADMIN: 'Marketing Administrator',
  HR_ADMIN: 'HR Administrator',
  CUSTOMER_SERVICE_ADMIN: 'Customer Service Administrator',
  SUPERVISOR: 'Supervisor',
  WAREHOUSE_MANAGER: 'Warehouse Manager',
  SUBSTATION_MANAGER: 'Substation Manager',
  STAFF: 'Staff',
  DATA_ENTRY: 'Data Entry Staff',
  RIDER: 'Rider',
  DRIVER: 'Driver',
  HELPER: 'Helper',
  MERCHANT: 'Merchant',
  CUSTOMER: 'Customer',
} as const;

export const SHIPMENT_STATUS = {
  TT_ASSIGNED_AT_PICKUP: 'TT_ASSIGNED_AT_PICKUP',
  PICKED_UP_PENDING_REGISTRATION: 'PICKED_UP_PENDING_REGISTRATION',
  REGISTERED_READY_FOR_LABEL: 'REGISTERED_READY_FOR_LABEL',
  LABEL_PRINTED: 'LABEL_PRINTED',
  LABEL_APPLIED_VERIFIED: 'LABEL_APPLIED_VERIFIED',
  ARRIVED_WAREHOUSE_GATE: 'ARRIVED_WAREHOUSE_GATE',
  WAREHOUSE_RECEIVED_VERIFIED: 'WAREHOUSE_RECEIVED_VERIFIED',
  WAREHOUSE_DISPATCHED: 'WAREHOUSE_DISPATCHED',
  IN_TRANSIT_TO_SUBSTATION: 'IN_TRANSIT_TO_SUBSTATION',
  SUBSTATION_RECEIVED_VERIFIED: 'SUBSTATION_RECEIVED_VERIFIED',
  OUT_FOR_DELIVERY: 'OUT_FOR_DELIVERY',
  DELIVERED_POD_CAPTURED: 'DELIVERED_POD_CAPTURED',
  DELIVERY_FAILED_NDR: 'DELIVERY_FAILED_NDR',
} as const;

export const TAG_STATUS = {
  IN_STOCK: 'IN_STOCK',
  ISSUED_TO_RIDER: 'ISSUED_TO_RIDER',
  USED: 'USED',
  VOID: 'VOID',
  LOST_SUSPECT: 'LOST_SUSPECT',
} as const;

// Utility: Format Currency for MMK (မြန်မာကျပ်ငွေ)
export function formatCurrency(value: number): string {
  return new Intl.NumberFormat('en-US', {
    style: 'decimal',
    minimumFractionDigits: 0,
  }).format(value) + ' MMK';
}

// Utility: Format Date for Enterprise Logs
export function formatDate(date: Date): string {
  return new Intl.DateTimeFormat('en-GB', {
    day: '2-digit',
    month: 'short',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  }).format(date);
}

// Global Routing Matrix
export const ROUTE_PATHS = {
  LOGIN: '/login',
  ADMIN: {
    DASHBOARD: '/admin/dashboard',
    IDENTITY: '/admin/approvals',
    MATRIX: '/admin/matrix',
    FLEET: '/admin/fleet',
    TARIFFS: '/admin/tariffs',
    FINANCE: '/admin/omni-finance',
    ANALYTICS: '/admin/analytics',
  }
};

export const MOCK_TOWNSHIPS = [
  'N. Okkalapa', 'S. Dagon', 'Insein', 'Hlaing Tharyar', 'Kamayut', 'Mandalay Central'
];
