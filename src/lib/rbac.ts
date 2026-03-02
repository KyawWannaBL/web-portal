// 1. Define the Matrix based on your enterprise documentation
export const ROLE_MATRIX: any = {
  // L5 = Full Access (God Mode)
  SYS: { level: 'L5', scope: 'S5', permissions: ['*'] },
  APP_OWNER: { level: 'L5', scope: 'S5', permissions: ['*'] },
  SUPER_ADMIN: { level: 'L5', scope: 'S5', permissions: ['*'] },
  
  // L0-L1 Operational Roles
  RDR: { level: 'L1', scope: 'S1', permissions: ['PUP-01', 'DLV-OUTFORDELIVERY', 'POD-SIGN'] },
  MER: { level: 'L0', scope: 'S1', permissions: ['EXT-01', 'EXT-03', 'EXT-05'] },
  CUR: { level: 'L1', scope: 'S1', permissions: ['PUP-01', 'PUP-04'] },
  CUS: { level: 'L0', scope: 'S1', permissions: ['EXT-01', 'EXT-02'] }
};

/**
 * Required by RbacProvider.tsx to clean the database string
 */
export const normalizeRole = (role: string | null | undefined) => {
  if (!role) return null;
  return role.trim().toUpperCase();
};

/**
 * Required by RbacProvider.tsx to load user permissions
 */
export const getEffectivePermissions = (role: string | null | undefined) => {
  const cleanRole = normalizeRole(role);
  if (!cleanRole) return [];
  
  // Grant universal access to L5 high-clearance roles
  if (cleanRole === 'SYS' || cleanRole === 'APP_OWNER' || cleanRole === 'SUPER_ADMIN') {
    return ['*'];
  }
  
  return ROLE_MATRIX[cleanRole]?.permissions || [];
};

/**
 * Standard gatekeeper function for individual permission checks
 */
export const checkPermission = (role: string | null | undefined, perm: string) => {
  if (!role) return false;
  const cleanRole = normalizeRole(role);

  // Administrative bypass
  if (cleanRole === 'SYS' || cleanRole === 'APP_OWNER' || cleanRole === 'SUPER_ADMIN') {
    return true;
  }

  const roleData = ROLE_MATRIX[cleanRole!];
  return roleData?.permissions.includes(perm) || roleData?.permissions.includes('*') || false;
};