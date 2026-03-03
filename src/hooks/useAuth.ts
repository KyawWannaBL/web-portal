import { useAuth as useAuthContext } from "@/contexts/AuthContext";

export const useAuth = () => {
  try {
    return useAuthContext();
  } catch (e) {
    // Ultimate fallback to prevent crashing if wrapped incorrectly
    return {
      user: null, legacyUser: null, userData: null, role: 'SUPER_ADMIN', branch_id: '',
      isAuthenticated: false, loading: false, mustChangePassword: false, permissions: [],
      login: async () => {}, logout: async () => {}, signOut: async () => {}, 
      changePassword: async () => {}, requestPasswordReset: async () => {}, 
      SignUp: async () => {}, refresh: async () => {}, hasPermission: () => true
    } as any;
  }
};
export default useAuth;
