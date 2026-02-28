export const ROLE_MATRIX: any = {
  SYS: { level: 'L5', scope: 'S5', permissions: ['*'] },
  MER: { level: 'L0', scope: 'S1', permissions: ['EXT-01'] },
  CUR: { level: 'L1', scope: 'S1', permissions: ['PUP-01'] },
  CUS: { level: 'L0', scope: 'S1', permissions: ['EXT-01'] }
};
export const checkPermission = (role: string, perm: string) => {
  if (role === 'SYS') return true;
  return ROLE_MATRIX[role]?.permissions.includes(perm) || false;
};
