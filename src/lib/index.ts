export const ROUTE_PATHS = {
  LOGIN: '/login',
  DASHBOARD: '/',
  RIDER: {
    TAGS: '/rider/tags',
    PICKUP: '/rider/pickup',
    LABEL: '/rider/label',
    WAREHOUSE: '/rider/warehouse',
    DELIVERY: '/rider/delivery',
  },
  OFFICE: {
    QUEUE: '/office/queue',
    REGISTRATION: '/office/registration/:ttId',
  },
  WAREHOUSE: {
    RECEIVING: '/warehouse/receiving',
    DISPATCH: '/warehouse/dispatch',
  },
  SUBSTATION: {
    RECEIVING: '/substation/receiving',
  },
  SUPERVISOR: {
    INVENTORY: '/supervisor/inventory',
    AUDIT: '/supervisor/audit',
  },
} as const;

export const USER_ROLES = {
  RDR: 'Rider',
  DES: 'Data Entry Staff',
  WH: 'Warehouse Staff',
  DRV: 'Driver',
  SSM: 'Substation Manager',
  SSR: 'Substation Rider',
  SUP: 'Supervisor',
  SUPER_ADMIN: 'Super Administrator',
  FINANCE_ADMIN: 'Finance Administrator',
  OPERATIONS_ADMIN: 'Operations Administrator',
  MARKETING_ADMIN: 'Marketing Administrator',
  CUSTOMER_SERVICE_ADMIN: 'Customer Service Administrator',
  MERCHANT: 'Merchant',
  CUSTOMER: 'Customer',
  MARKETING: 'Marketing Manager',
  CUSTOMER_SERVICE: 'Customer Service',
  FINANCE_USER: 'Finance User',
  ANALYST: 'Business Analyst',
  ADMIN: 'Administrator',
} as const;

export type UserRole = keyof typeof USER_ROLES | string;

export const PERMISSIONS = {
  TAG_ISSUE: 'TAG-ISSUE',
  TAG_VIEW: 'TAG-VIEW',
  TAG_VOID_REQ: 'TAG-VOID-REQ',
  TAG_VOID_APP: 'TAG-VOID-APP',
  TAG_LOST_MARK: 'TAG-LOST-MARK',
  TAG_EOD_RECON: 'TAG-EOD-RECON',
  TAG_EOD_APP: 'TAG-EOD-APP',
  PUP_TT_ASSIGN: 'PUP-TT-ASSIGN',
  PUP_PHOTO_CAPTURE: 'PUP-PHOTO-CAPTURE',
  PUP_QUICK_EDIT: 'PUP-QUICK-EDIT',
  REG_FULL_CREATE: 'REG-FULL-CREATE',
  REG_FULL_EDIT: 'REG-FULL-EDIT',
  LBL_PRINT: 'LBL-PRINT',
  LBL_REPRINT: 'LBL-REPRINT',
  LBL_ACTIVATE: 'LBL-ACTIVATE',
  LOC_SCAN: 'LOC-SCAN',
  WH_RECEIVE: 'WH-RECEIVE',
  WH_DISPATCH: 'WH-DISPATCH',
  SS_RECEIVE: 'SS-RECEIVE',
  POD_SIGN: 'POD-SIGN',
  POD_OTP: 'POD-OTP',
  POD_PHOTO: 'POD-PHOTO',
  NDR_CREATE: 'NDR-CREATE',
  AUD_VIEW: 'AUD-VIEW',
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

// Alias to prevent SHIPMENT_STATUSES typo errors
export const SHIPMENT_STATUSES = SHIPMENT_STATUS;
export type ShipmentStatus = keyof typeof SHIPMENT_STATUS | string;

export const TAG_STATUS = {
  IN_STOCK: 'IN_STOCK',
  ISSUED_TO_RIDER: 'ISSUED_TO_RIDER',
  USED: 'USED',
  VOID: 'VOID',
  LOST_SUSPECT: 'LOST_SUSPECT',
  RETURNED_TO_STOCK: 'RETURNED_TO_STOCK',
} as const;

export type TagStatus = keyof typeof TAG_STATUS | string;

export type BadgeVariant = "default" | "secondary" | "destructive" | "outline" | "ghost" | "link";

export type FleetVehicleType = "TRUCK" | "VAN" | "MOTORCYCLE";
export type FleetVehicleStatus = "ACTIVE" | "IN_USE" | "MAINTENANCE" | "INACTIVE" | string;

export interface FleetVehicle {
  id: string;
  plateNumber: string;
  type: FleetVehicleType | string;
  status: FleetVehicleStatus;
  currentLocation?: { lat: number; lng: number };
  assignedRiderId?: string;
  fuelLevel?: number;
  lastService?: string;
}

export type FormatWeightOptions = {
  locale?: string;
  unit?: "kg" | "g";
  maximumFractionDigits?: number;
};

export function formatWeight(
  value: number | string | null | undefined,
  options: FormatWeightOptions = {}
): string {
  const num = typeof value === "string" ? Number(value) : typeof value === "number" ? value : 0;
  const safe = Number.isFinite(num) ? num : 0;
  const { locale = "en-US", unit = "kg", maximumFractionDigits = 2 } = options;
  const formatted = new Intl.NumberFormat(locale, { maximumFractionDigits }).format(safe);
  return `${formatted} ${unit}`;
}

export function generateTrackingNumber(prefix = "TRK"): string {
  const d = new Date();
  const yyyy = String(d.getFullYear());
  const mm = String(d.getMonth() + 1).padStart(2, "0");
  const dd = String(d.getDate()).padStart(2, "0");
  const rand = String(Math.floor(Math.random() * 1_000_000)).padStart(6, "0");
  return `${prefix}-${yyyy}${mm}${dd}-${rand}`;
}

export function getStatusVariant(status: string): BadgeVariant {
  const s = String(status).toUpperCase();
  if (s.includes("FAILED") || s.includes("NDR") || s.includes("VOID") || s.includes("LOST")) return "destructive";
  if (s.includes("DELIVERED") || s.includes("VERIFIED") || s.includes("USED") || s.includes("ACTIVE")) return "default";
  if (s.includes("PENDING") || s.includes("IN_STOCK") || s.includes("ISSUED")) return "secondary";
  return "outline";
}

export interface TamperTag {
  id: string;
  status: TagStatus;
  batchId: string;
  issuedTo: string;
  issueDate: string;
  voidReason?: string;
  voidPhoto?: string;
}

export interface Shipment {
  id: string;
  awb?: string;
  awb_number?: string;
  trackingNumber?: string;
  tamperTagId?: string;
  status: any;
  pieces?: number;
  type?: 'box' | 'bag' | 'document' | 'other' | string;
  condition?: 'OK' | 'Damaged' | string;
  cod?: { required: boolean; amount?: number; currency?: string; };
  cod_amount?: number;
  destinationTownship?: string;
  origin?: string;
  destination?: string;
  senderName?: string;
  senderAddress?: string;
  senderPhone?: string;
  receiverName?: string;
  receiverAddress?: string;
  receiverPhone?: string;
  receiverCity?: string;
  sender?: { name?: string; phone?: string; };
  receiver?: { name?: string; phone?: string; address?: string; township?: string; city?: string; };
  pickup_address?: any;
  delivery_address?: any;
  package_details?: any;
  weight?: number;
  dimensions?: string;
  priority?: string;
  isPriority?: boolean;
  photos?: string[];
  riderId?: string;
  createdAt?: string;
  created_at?: string;
  updated_at?: string;
  registeredAt?: string;
  estimated_delivery?: string;
  labelPrintedCount?: number;
  lastLocation?: string;
  history?: any[];
  metadata?: any;
}

export interface PickupRecord {
  ttId: string;
  timestamp: string;
  gps: string;
  riderId: string;
  photos: string[];
  details: {
    pieces: number;
    type: string;
    condition: string;
    codAmount?: number;
    destinationTownship?: string;
  };
}

export interface PODRecord {
  shipmentId: string;
  recipientName: string;
  relationship: string;
  signature: string;
  photo?: string;
  timestamp: string;
  gps: string;
  otpVerified: boolean;
}

export const MOCK_TOWNSHIPS = [
  'Downtown', 'North District', 'South District', 'East Industrial', 'West Waterfront', 'Airport Zone',
];

export const NDR_REASONS = [
  'No answer', 'Refused by recipient', 'Address not found', 'COD amount dispute', 'Customer rescheduled', 'Restricted access',
];

export interface User {
  id: string;
  name?: string;
  email?: string;
  role?: UserRole;
  permissions?: string[];
  isActive?: boolean;
  is_active?: boolean;
  createdAt?: Date | string;
  lastLogin?: Date | string;
  batchId?: string;
  branchId?: string;
  branch_id?: string;
  full_name?: string;
  fullName?: string;
  status?: string;
  phoneNumber?: string;
  avatarUrl?: string;
  user_metadata?: any;
  branches?: { name: string }[];
}

export type UserProfile = User;

export type FormatCurrencyOptions = {
  locale?: string;
  currency?: string;
  minimumFractionDigits?: number;
  maximumFractionDigits?: number;
};

export function formatCurrency(
  value: number | string | null | undefined,
  options: FormatCurrencyOptions = {}
): string {
  const num = typeof value === "string" ? Number(value) : typeof value === "number" ? value : 0;
  const safe = Number.isFinite(num) ? num : 0;
  const { locale = "en-US", currency = "MMK", minimumFractionDigits = 0, maximumFractionDigits = 0 } = options;
  try {
    return new Intl.NumberFormat(locale, { style: "currency", currency, minimumFractionDigits, maximumFractionDigits }).format(safe);
  } catch {
    return `${safe}`;
  }
}

export type FormatDateOptions = {
  locale?: string;
  timeZone?: string;
  dateStyle?: "full" | "long" | "medium" | "short";
  timeStyle?: "full" | "long" | "medium" | "short";
};

export function formatDate(
  value: Date | string | number | null | undefined,
  options: FormatDateOptions = {}
): string {
  if (value === null || value === undefined) return "";
  const date = value instanceof Date ? value : new Date(value);
  if (Number.isNaN(date.getTime())) return "";
  const { locale = "en-US", timeZone, dateStyle = "medium", timeStyle } = options;
  try {
    return new Intl.DateTimeFormat(locale, { ...(timeZone ? { timeZone } : {}), dateStyle, ...(timeStyle ? { timeStyle } : {}) }).format(date);
  } catch {
    return date.toISOString();
  }
}
