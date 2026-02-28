import { DEFAULT_ROLE_PERMISSIONS, RoleCode, type PermissionCode } from "@britium/shared";

export type RbacSnapshot = {
  role: RoleCode | null;
  permissions: PermissionCode[];
};

function isRoleCode(value: unknown): value is RoleCode {
  return typeof value === "string" && Object.values(RoleCode).includes(value as RoleCode);
}

export function normalizeRole(raw: unknown): RoleCode | null {
  if (isRoleCode(raw)) return raw;
  return null;
}

export function getEffectivePermissions(role: RoleCode | null): PermissionCode[] {
  if (!role) return [];
  return DEFAULT_ROLE_PERMISSIONS[role] ?? [];
}

export function hasAll(perms: PermissionCode[], required: PermissionCode[]): boolean {
  if (required.length === 0) return true;
  const s = new Set(perms);
  return required.every((p) => s.has(p));
}

export function hasAny(perms: PermissionCode[], required: PermissionCode[]): boolean {
  if (required.length === 0) return true;
  const s = new Set(perms);
  return required.some((p) => s.has(p));
}
