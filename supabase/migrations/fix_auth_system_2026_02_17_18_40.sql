-- Drop existing permissions table and recreate
DROP TABLE IF EXISTS public.permissions_2026_02_17_18_40 CASCADE;
DROP TABLE IF EXISTS public.permissions CASCADE;

-- Create the proper profiles table that extends auth.users
CREATE TABLE IF NOT EXISTS public.profiles (
    id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    email text NOT NULL,
    full_name text,
    role text NOT NULL DEFAULT 'STAFF',
    branch_id uuid,
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
INSERT INTO public.permissions (code, description) VALUES
('dashboard.view', 'View dashboard'),
('shipments.create', 'Create shipments'),
('shipments.view', 'View shipments'),
('shipments.edit', 'Edit shipments'),
('shipments.delete', 'Delete shipments'),
('fleet.view', 'View fleet status'),
('fleet.manage', 'Manage fleet operations'),
('warehouse.view', 'View warehouse operations'),
('warehouse.manage', 'Manage warehouse operations'),
('delivery.view', 'View delivery operations'),
('delivery.manage', 'Manage delivery operations'),
('analytics.view', 'View analytics'),
('users.view', 'View users'),
('users.manage', 'Manage users'),
('settings.view', 'View settings'),
('settings.manage', 'Manage settings')
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