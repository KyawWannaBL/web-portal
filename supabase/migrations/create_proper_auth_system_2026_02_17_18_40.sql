-- Drop the old auth table since we'll use Supabase Auth + profiles
DROP TABLE IF EXISTS public.auth_users_2026_02_17_18_40 CASCADE;

-- Create the proper profiles table that extends auth.users
CREATE TABLE IF NOT EXISTS public.profiles (
    id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    email text NOT NULL,
    full_name text,
    role text NOT NULL DEFAULT 'STAFF',
    branch_id uuid REFERENCES public.branches_2026_02_17_18_40(id),
    is_active boolean DEFAULT true,
    must_change_password boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    environment text DEFAULT 'PROD-ENTERPRISE',
    CONSTRAINT profiles_pkey PRIMARY KEY (id)
);

-- Create permissions table
CREATE TABLE IF NOT EXISTS public.permissions (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE,
    description text,
    category text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT permissions_pkey PRIMARY KEY (id)
);

-- Create role_permissions table
CREATE TABLE IF NOT EXISTS public.role_permissions (
    role text NOT NULL,
    permission_id uuid NOT NULL REFERENCES public.permissions(id),
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT role_permissions_pkey PRIMARY KEY (role, permission_id)
);

-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.role_permissions ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Users can view own profile" ON public.profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Allow authenticated users to view permissions" ON public.permissions
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to view role permissions" ON public.role_permissions
    FOR SELECT USING (auth.role() = 'authenticated');

-- Insert core permissions
INSERT INTO public.permissions (code, description, category) VALUES
('dashboard.view', 'View dashboard', 'Dashboard'),
('shipments.create', 'Create shipments', 'Shipments'),
('shipments.view', 'View shipments', 'Shipments'),
('shipments.edit', 'Edit shipments', 'Shipments'),
('shipments.delete', 'Delete shipments', 'Shipments'),
('fleet.view', 'View fleet status', 'Fleet'),
('fleet.manage', 'Manage fleet operations', 'Fleet'),
('warehouse.view', 'View warehouse operations', 'Warehouse'),
('warehouse.manage', 'Manage warehouse operations', 'Warehouse'),
('delivery.view', 'View delivery operations', 'Delivery'),
('delivery.manage', 'Manage delivery operations', 'Delivery'),
('analytics.view', 'View analytics', 'Analytics'),
('users.view', 'View users', 'User Management'),
('users.manage', 'Manage users', 'User Management'),
('settings.view', 'View settings', 'Settings'),
('settings.manage', 'Manage settings', 'Settings')
ON CONFLICT (code) DO NOTHING;

-- Create function to handle new user creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name, role)
    VALUES (
        new.id,
        new.email,
        COALESCE(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)),
        COALESCE(new.raw_user_meta_data->>'role', 'STAFF')
    );
    RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new user creation
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Rename existing tables to match the dashboard expectations
ALTER TABLE public.branches_2026_02_17_18_40 RENAME TO branches;
ALTER TABLE public.shipments_2026_02_17_18_40 RENAME TO shipments;
ALTER TABLE public.shipment_status_history_2026_02_17_18_40 RENAME TO shipment_status_history;
ALTER TABLE public.delivery_records_2026_02_17_18_40 RENAME TO delivery_records;
ALTER TABLE public.audit_logs_2026_02_17_18_40 RENAME TO audit_logs;
ALTER TABLE public.tamper_tags_2026_02_17_18_40 RENAME TO tamper_tags;

-- Update foreign key references
ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS profiles_branch_id_fkey;
ALTER TABLE public.profiles ADD CONSTRAINT profiles_branch_id_fkey 
    FOREIGN KEY (branch_id) REFERENCES public.branches(id);

-- Update RLS policies for renamed tables
DROP POLICY IF EXISTS "Allow authenticated users to view branches" ON public.branches;
CREATE POLICY "Allow authenticated users to view branches" ON public.branches
    FOR SELECT USING (auth.role() = 'authenticated');

DROP POLICY IF EXISTS "Allow authenticated users to view shipments" ON public.shipments;
CREATE POLICY "Allow authenticated users to view shipments" ON public.shipments
    FOR SELECT USING (auth.role() = 'authenticated');