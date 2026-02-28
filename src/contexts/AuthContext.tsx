import React, { createContext, useContext, useState, useEffect } from 'react';
import { supabase } from '@/integrations/supabase/client';
import type { User, AuthState, AppRole } from '@/types/roles';

interface AuthContextType extends AuthState {
  login: (email: string, password: string) => Promise<{ success: boolean; message: string }>;
  logout: () => void;
  signup: (email: string, password: string, fullName: string) => Promise<{ success: boolean; message: string }>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [authState, setAuthState] = useState<AuthState>({
    user: null,
    isAuthenticated: false,
    isLoading: true,
  });

  // Check for existing session on mount
  useEffect(() => {
    const checkSession = () => {
      const savedUser = localStorage.getItem('demo_user');
      if (savedUser) {
        try {
          const user = JSON.parse(savedUser);
          setAuthState({
            user,
            isAuthenticated: true,
            isLoading: false,
          });
        } catch (error) {
          console.error('Error parsing saved user:', error);
          localStorage.removeItem('demo_user');
          setAuthState(prev => ({ ...prev, isLoading: false }));
        }
      } else {
        setAuthState(prev => ({ ...prev, isLoading: false }));
      }
    };

    checkSession();
  }, []);

  const login = async (email: string, password: string): Promise<{ success: boolean; message: string }> => {
    try {
      setAuthState(prev => ({ ...prev, isLoading: true }));

      console.log('Attempting login with:', { email, password: '***' });

      // Call the demo authentication function
      const { data, error } = await supabase.rpc('authenticate_demo_user_2026_02_19_14_00', {
        p_email: email,
        p_password: password
      });

      console.log('Supabase response:', { data, error });

      if (error) {
        console.error('Authentication error:', error);
        setAuthState(prev => ({ ...prev, isLoading: false }));
        return { success: false, message: `Authentication failed: ${error.message}` };
      }

      if (data && data.length > 0) {
        const authResult = data[0];
        
        if (authResult.success) {
          const user: User = {
            id: authResult.user_id,
            email: authResult.email,
            full_name: authResult.full_name,
            role: authResult.role as AppRole,
            is_active: true,
            created_at: new Date().toISOString(),
          };

          // Save to localStorage for demo purposes
          localStorage.setItem('demo_user', JSON.stringify(user));

          setAuthState({
            user,
            isAuthenticated: true,
            isLoading: false,
          });

          return { success: true, message: 'Login successful!' };
        } else {
          setAuthState(prev => ({ ...prev, isLoading: false }));
          return { success: false, message: authResult.message || 'Invalid credentials' };
        }
      }

      // Fallback: Try direct table query if function fails
      console.log('Function returned no data, trying direct query...');
      const { data: directData, error: directError } = await supabase
        .from('demo_login_credentials_2026_02_19_14_00')
        .select('*')
        .eq('email', email)
        .eq('password_hash', password)
        .eq('is_active', true)
        .single();

      if (directError) {
        console.error('Direct query error:', directError);
        setAuthState(prev => ({ ...prev, isLoading: false }));
        return { success: false, message: 'Invalid email or password' };
      }

      if (directData) {
        const user: User = {
          id: directData.id,
          email: directData.email,
          full_name: directData.full_name,
          role: directData.role as AppRole,
          is_active: true,
          created_at: new Date().toISOString(),
        };

        // Save to localStorage for demo purposes
        localStorage.setItem('demo_user', JSON.stringify(user));

        setAuthState({
          user,
          isAuthenticated: true,
          isLoading: false,
        });

        return { success: true, message: 'Login successful!' };
      }

      setAuthState(prev => ({ ...prev, isLoading: false }));
      return { success: false, message: 'Authentication failed' };
    } catch (error) {
      console.error('Login error:', error);
      setAuthState(prev => ({ ...prev, isLoading: false }));
      return { success: false, message: 'An error occurred during login' };
    }
  };

  const logout = () => {
    localStorage.removeItem('demo_user');
    setAuthState({
      user: null,
      isAuthenticated: false,
      isLoading: false,
    });
  };

  const signup = async (email: string, password: string, fullName: string): Promise<{ success: boolean; message: string }> => {
    try {
      setAuthState(prev => ({ ...prev, isLoading: true }));

      // For demo purposes, we'll create a new user with CUSTOMER role by default
      const { data, error } = await supabase
        .from('demo_login_credentials_2026_02_19_14_00')
        .insert([{
          email,
          password_hash: password, // In real app, this would be properly hashed
          role: 'CUSTOMER',
          full_name: fullName,
          is_active: false, // Requires admin approval
        }])
        .select()
        .single();

      if (error) {
        console.error('Signup error:', error);
        setAuthState(prev => ({ ...prev, isLoading: false }));
        
        if (error.code === '23505') { // Unique constraint violation
          return { success: false, message: 'Email already exists' };
        }
        
        return { success: false, message: 'Signup failed. Please try again.' };
      }

      setAuthState(prev => ({ ...prev, isLoading: false }));
      return { 
        success: true, 
        message: 'Account created successfully! Please wait for administrator approval before logging in.' 
      };
    } catch (error) {
      console.error('Signup error:', error);
      setAuthState(prev => ({ ...prev, isLoading: false }));
      return { success: false, message: 'An error occurred during signup' };
    }
  };

  const value: AuthContextType = {
    ...authState,
    login,
    logout,
    signup,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}