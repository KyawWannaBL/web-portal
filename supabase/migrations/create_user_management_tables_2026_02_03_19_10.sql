-- Britium Express User Management System
-- Create comprehensive user tables with Firebase integration

-- User roles enum
CREATE TYPE user_role AS ENUM (
  'super_admin',
  'admin', 
  'manager',
  'sub_station_manager',
  'supervisor',
  'warehouse_staff',
  'rider',
  'merchant',
  'vendor',
  'accountant',
  'customer',
  'finance_manager'
);

-- User status enum
CREATE TYPE user_status AS ENUM (
  'active',
  'inactive',
  'suspended',
  'pending_verification',
  'password_reset_required'
);

-- Users table with Firebase integration
CREATE TABLE public.users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  firebase_uid TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  phone TEXT,
  role user_role NOT NULL DEFAULT 'customer',
  status user_status NOT NULL DEFAULT 'pending_verification',
  avatar_url TEXT,
  address TEXT,
  city TEXT,
  state TEXT,
  postal_code TEXT,
  country TEXT DEFAULT 'Myanmar',
  language_preference TEXT DEFAULT 'en',
  timezone TEXT DEFAULT 'Asia/Yangon',
  last_login_at TIMESTAMPTZ,
  password_changed_at TIMESTAMPTZ,
  force_password_change BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  created_by UUID REFERENCES public.users(id),
  updated_by UUID REFERENCES public.users(id)
);

-- User permissions table
CREATE TABLE public.user_permissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  permission_name TEXT NOT NULL,
  resource_type TEXT NOT NULL,
  can_create BOOLEAN DEFAULT false,
  can_read BOOLEAN DEFAULT false,
  can_update BOOLEAN DEFAULT false,
  can_delete BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, permission_name, resource_type)
);

-- User sessions table for tracking
CREATE TABLE public.user_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  session_token TEXT NOT NULL,
  device_info JSONB,
  ip_address INET,
  user_agent TEXT,
  is_active BOOLEAN DEFAULT true,
  expires_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Branches/Stations table
CREATE TABLE public.branches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  code TEXT UNIQUE NOT NULL,
  address TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  postal_code TEXT,
  phone TEXT,
  email TEXT,
  manager_id UUID REFERENCES public.users(id),
  is_active BOOLEAN DEFAULT true,
  coordinates POINT,
  coverage_radius INTEGER DEFAULT 5000, -- in meters
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- User branch assignments
CREATE TABLE public.user_branch_assignments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  branch_id UUID NOT NULL REFERENCES public.branches(id) ON DELETE CASCADE,
  is_primary BOOLEAN DEFAULT false,
  assigned_at TIMESTAMPTZ DEFAULT NOW(),
  assigned_by UUID REFERENCES public.users(id),
  UNIQUE(user_id, branch_id)
);

-- Insert predefined admin accounts
INSERT INTO public.users (
  firebase_uid, email, full_name, role, status, force_password_change, created_at
) VALUES 
  ('super_admin_uid', 'md@britiumexpress.com', 'Managing Director', 'super_admin', 'active', true, NOW()),
  ('admin_1_uid', 'sai@britiumexpress.com', 'System Administrator', 'admin', 'active', true, NOW()),
  ('admin_2_uid', 'gm@britiumexpress.com', 'General Manager', 'admin', 'active', true, NOW()),
  ('admin_3_uid', 'hod@britiumexpress.com', 'Head of Department', 'admin', 'active', true, NOW());

-- Create default branch
INSERT INTO public.branches (name, code, address, city, state, phone, email) VALUES 
  ('Britium Express Headquarters', 'HQ001', 'Yangon Central Business District', 'Yangon', 'Yangon Region', '+95 9 123 456 789', 'hq@britiumexpress.com');

-- Create indexes for performance
CREATE INDEX idx_users_firebase_uid ON public.users(firebase_uid);
CREATE INDEX idx_users_email ON public.users(email);
CREATE INDEX idx_users_role ON public.users(role);
CREATE INDEX idx_users_status ON public.users(status);
CREATE INDEX idx_user_permissions_user_id ON public.user_permissions(user_id);
CREATE INDEX idx_user_sessions_user_id ON public.user_sessions(user_id);
CREATE INDEX idx_user_sessions_active ON public.user_sessions(is_active);
CREATE INDEX idx_branches_code ON public.branches(code);
CREATE INDEX idx_user_branch_assignments_user_id ON public.user_branch_assignments(user_id);

-- Enable RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_branch_assignments ENABLE ROW LEVEL SECURITY;

-- RLS Policies for users table
CREATE POLICY "Users can view their own profile" ON public.users
  FOR SELECT USING (auth.uid()::text = firebase_uid);

CREATE POLICY "Admins can view all users" ON public.users
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.users u 
      WHERE u.firebase_uid = auth.uid()::text 
      AND u.role IN ('super_admin', 'admin')
    )
  );

CREATE POLICY "Admins can insert users" ON public.users
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.users u 
      WHERE u.firebase_uid = auth.uid()::text 
      AND u.role IN ('super_admin', 'admin')
    )
  );

CREATE POLICY "Users can update their own profile" ON public.users
  FOR UPDATE USING (auth.uid()::text = firebase_uid);

CREATE POLICY "Admins can update all users" ON public.users
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.users u 
      WHERE u.firebase_uid = auth.uid()::text 
      AND u.role IN ('super_admin', 'admin')
    )
  );

-- RLS Policies for user_permissions
CREATE POLICY "Users can view their own permissions" ON public.user_permissions
  FOR SELECT USING (
    user_id IN (
      SELECT id FROM public.users WHERE firebase_uid = auth.uid()::text
    )
  );

CREATE POLICY "Admins can manage all permissions" ON public.user_permissions
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.users u 
      WHERE u.firebase_uid = auth.uid()::text 
      AND u.role IN ('super_admin', 'admin')
    )
  );

-- RLS Policies for branches
CREATE POLICY "All authenticated users can view branches" ON public.branches
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Admins can manage branches" ON public.branches
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.users u 
      WHERE u.firebase_uid = auth.uid()::text 
      AND u.role IN ('super_admin', 'admin')
    )
  );

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_branches_updated_at BEFORE UPDATE ON public.branches
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();