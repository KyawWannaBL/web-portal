export const ROLE_MATRIX: any = {
  // L5 = Full Access (God Mode)
  SYS: { level: 'L5', scope: 'S5', permissions: ['*'] },
  APP_OWNER: { level: 'L5', scope: 'S5', permissions: ['*'] },
  SUPER_ADMIN: { level: 'L5', scope: 'S5', permissions: ['*'] },
  
  // Operational Roles
  MER: { level: 'L0', scope: 'S1', permissions: ['EXT-01'] },
  CUR: { level: 'L1', scope: 'S1', permissions: ['PUP-01'] }
};

// This function is CALLED by RbacProvider.tsx
export const normalizeRole = (role: string | null | undefined) => {
  if (!role) return null;
  return role.trim().toUpperCase();
};

// This function is CALLED by RbacProvider.tsx to set permissions
export const getEffectivePermissions = (role: string | null | undefined) => {
  const cleanRole = normalizeRole(role);
  if (!cleanRole) return [];
  
  // Grant '*' (all) permissions to your admin roles
  if (cleanRole === 'SYS' || cleanRole === 'APP_OWNER' || cleanRole === 'SUPER_ADMIN') {
    return ['*'];
  }
  
  return ROLE_MATRIX[cleanRole]?.permissions || [];
};

// Gatekeeper for components
export const checkPermission = (role: string | null | undefined, perm: string) => {
  if (!role) return false;
  const cleanRole = normalizeRole(role);
  if (cleanRole === 'SYS' || cleanRole === 'APP_OWNER' || cleanRole === 'SUPER_ADMIN') return true;
  return ROLE_MATRIX[cleanRole]?.permissions.includes(perm) || false;
};