export const ROLE_MATRIX: any = {
  // L5 = Full Access (God Mode)
  SYS: { level: 'L5', scope: 'S5', permissions: ['*'] },
  APP_OWNER: { level: 'L5', scope: 'S5', permissions: ['*'] },
  SUPER_ADMIN: { level: 'L5', scope: 'S5', permissions: ['*'] },
  
  // Standard Operational Roles
  MER: { level: 'L0', scope: 'S1', permissions: ['EXT-01'] },
  CUR: { level: 'L1', scope: 'S1', permissions: ['PUP-01'] },
  CUS: { level: 'L0', scope: 'S1', permissions: ['EXT-01'] }
};

/**
 * Normalizes the role string from the database to match Matrix keys.
 * Used by RbacProvider to set the active role state.
 */
export const normalizeRole = (role: string | null | undefined) => {
  if (!role) return null;
  return role.trim().toUpperCase();
};

/**
 * Returns the full permission array for a given role.
 * Used by RbacProvider to grant UI-level access.
 */
export const getEffectivePermissions = (role: string | null | undefined) => {
  const cleanRole = normalizeRole(role);
  if (!cleanRole) return [];
  
  // Grant universal access to L5 roles
  if (cleanRole === 'SYS' || cleanRole === 'APP_OWNER' || cleanRole === 'SUPER_ADMIN') {
    return ['*'];
  }
  
  return ROLE_MATRIX[cleanRole]?.permissions || [];
};

/**
 * Primary gatekeeper function for individual permission checks.
 */
export const checkPermission = (role: string | null | undefined, perm: string) => {
  if (!role) return false;

  const cleanRole = normalizeRole(role);

  // Immediate bypass for high-clearance administrative roles
  if (cleanRole === 'SYS' || cleanRole === 'APP_OWNER' || cleanRole === 'SUPER_ADMIN') {
    return true;
  }

  const roleData = ROLE_MATRIX[cleanRole!];
  return (
    roleData?.permissions.includes(perm) || 
    roleData?.permissions.includes('*') || 
    false
  );
};