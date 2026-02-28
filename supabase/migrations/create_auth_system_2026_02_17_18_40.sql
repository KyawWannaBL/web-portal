-- Create profiles table that extends Supabase auth.users
CREATE TABLE IF NOT EXISTS public.profiles_2026_02_17_18_40 (
    id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    email text NOT NULL,
    full_name text,
    role text NOT NULL DEFAULT 'OPERATIONS_STAFF',
    branch_id uuid REFERENCES public.branches_2026_02_17_18_40(id),
    is_active boolean DEFAULT true,
    must_change_password boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_login_at timestamp with time zone,
    failed_attempts integer DEFAULT 0,
    locked_until timestamp with time zone,
    metadata jsonb DEFAULT '{}',
    CONSTRAINT profiles_2026_02_17_18_40_pkey PRIMARY KEY (id)
);

-- Enable RLS on profiles
ALTER TABLE public.profiles_2026_02_17_18_40 ENABLE ROW LEVEL SECURITY;

-- Create policy for profiles
CREATE POLICY "Users can view own profile" ON public.profiles_2026_02_17_18_40
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.profiles_2026_02_17_18_40
    FOR UPDATE USING (auth.uid() = id);

-- Create function to handle new user creation
CREATE OR REPLACE FUNCTION public.handle_new_user_2026_02_17_18_40()
RETURNS trigger AS $$
BEGIN
    INSERT INTO public.profiles_2026_02_17_18_40 (id, email, full_name, role)
    VALUES (
        new.id,
        new.email,
        COALESCE(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)),
        COALESCE(new.raw_user_meta_data->>'role', 'OPERATIONS_STAFF')
    );
    RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new user creation
DROP TRIGGER IF EXISTS on_auth_user_created_2026_02_17_18_40 ON auth.users;
CREATE TRIGGER on_auth_user_created_2026_02_17_18_40
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user_2026_02_17_18_40();

-- Insert demo users into auth.users and profiles
-- Note: In production, users would be created through Supabase Auth
-- For demo purposes, we'll create some test profiles

-- First, let's create some demo auth users (this is a simplified approach for demo)
-- In a real system, these would be created through Supabase Auth signup

-- Create demo profiles directly (simulating what would happen after auth signup)
INSERT INTO public.profiles_2026_02_17_18_40 (id, email, full_name, role, branch_id, must_change_password) VALUES
(gen_random_uuid(), 'admin@logistics.com', 'System Administrator', 'SUPER_ADMIN', (SELECT id FROM public.branches_2026_02_17_18_40 WHERE code = 'YGN-001'), false),
(gen_random_uuid(), 'ops.manager@logistics.com', 'Operations Manager', 'OPERATIONS_ADMIN', (SELECT id FROM public.branches_2026_02_17_18_40 WHERE code = 'YGN-001'), true),
(gen_random_uuid(), 'warehouse.staff@logistics.com', 'Warehouse Staff', 'WAREHOUSE_STAFF', (SELECT id FROM public.branches_2026_02_17_18_40 WHERE code = 'YGN-001'), true),
(gen_random_uuid(), 'rider.001@logistics.com', 'Delivery Rider 001', 'DELIVERY_RIDER', (SELECT id FROM public.branches_2026_02_17_18_40 WHERE code = 'YGN-001'), true),
(gen_random_uuid(), 'merchant.demo@logistics.com', 'Demo Merchant', 'MERCHANT', (SELECT id FROM public.branches_2026_02_17_18_40 WHERE code = 'YGN-001'), false)
ON CONFLICT (id) DO NOTHING;

-- Create a function to simulate login (for demo purposes)
CREATE OR REPLACE FUNCTION public.demo_login_2026_02_17_18_40(user_email text)
RETURNS json AS $$
DECLARE
    user_profile public.profiles_2026_02_17_18_40%ROWTYPE;
    branch_info public.branches_2026_02_17_18_40%ROWTYPE;
    result json;
BEGIN
    -- Get user profile
    SELECT * INTO user_profile
    FROM public.profiles_2026_02_17_18_40
    WHERE email = user_email AND is_active = true;
    
    IF NOT FOUND THEN
        RETURN json_build_object('error', 'User not found or inactive');
    END IF;
    
    -- Get branch info
    SELECT * INTO branch_info
    FROM public.branches_2026_02_17_18_40
    WHERE id = user_profile.branch_id;
    
    -- Update last login
    UPDATE public.profiles_2026_02_17_18_40
    SET last_login_at = now(), updated_at = now()
    WHERE id = user_profile.id;
    
    -- Build result
    result := json_build_object(
        'id', user_profile.id,
        'email', user_profile.email,
        'full_name', user_profile.full_name,
        'role', user_profile.role,
        'branch_name', COALESCE(branch_info.name, 'Unknown Branch'),
        'branch_code', COALESCE(branch_info.code, 'UNK'),
        'must_change_password', user_profile.must_change_password,
        'is_active', user_profile.is_active,
        'last_login_at', user_profile.last_login_at
    );
    
    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create password change function
CREATE OR REPLACE FUNCTION public.change_password_2026_02_17_18_40(user_id uuid)
RETURNS boolean AS $$
BEGIN
    UPDATE public.profiles_2026_02_17_18_40
    SET must_change_password = false, updated_at = now()
    WHERE id = user_id;
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;