-- Create auth_users table for demo authentication
CREATE TABLE IF NOT EXISTS public.auth_users_2026_02_17_18_40 (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    email text NOT NULL UNIQUE,
    password_hash text NOT NULL, -- In production, this would be properly hashed
    full_name text NOT NULL,
    role text NOT NULL,
    branch_id uuid REFERENCES public.branches_2026_02_17_18_40(id),
    is_active boolean DEFAULT true,
    must_change_password boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_login_at timestamp with time zone,
    failed_attempts integer DEFAULT 0,
    locked_until timestamp with time zone,
    metadata jsonb DEFAULT '{}',
    CONSTRAINT auth_users_2026_02_17_18_40_pkey PRIMARY KEY (id)
);

-- Enable RLS
ALTER TABLE public.auth_users_2026_02_17_18_40 ENABLE ROW LEVEL SECURITY;

-- Create policy for auth_users (allow all for demo)
CREATE POLICY "Allow all operations on auth_users" ON public.auth_users_2026_02_17_18_40
    FOR ALL USING (true);

-- Insert demo users with simple passwords (for demo only)
INSERT INTO public.auth_users_2026_02_17_18_40 (email, password_hash, full_name, role, branch_id, must_change_password) VALUES
('admin@logistics.com', 'admin123', 'System Administrator', 'SUPER_ADMIN', (SELECT id FROM public.branches_2026_02_17_18_40 WHERE code = 'YGN-001'), false),
('ops.manager@logistics.com', 'ops123', 'Operations Manager', 'OPERATIONS_ADMIN', (SELECT id FROM public.branches_2026_02_17_18_40 WHERE code = 'YGN-001'), true),
('warehouse.staff@logistics.com', 'warehouse123', 'Warehouse Staff', 'WAREHOUSE_STAFF', (SELECT id FROM public.branches_2026_02_17_18_40 WHERE code = 'YGN-001'), true),
('rider.001@logistics.com', 'rider123', 'Delivery Rider 001', 'DELIVERY_RIDER', (SELECT id FROM public.branches_2026_02_17_18_40 WHERE code = 'YGN-001'), true),
('merchant.demo@logistics.com', 'merchant123', 'Demo Merchant', 'MERCHANT', (SELECT id FROM public.branches_2026_02_17_18_40 WHERE code = 'YGN-001'), false);

-- Create login function
CREATE OR REPLACE FUNCTION public.authenticate_user_2026_02_17_18_40(user_email text, user_password text)
RETURNS json AS $$
DECLARE
    user_record public.auth_users_2026_02_17_18_40%ROWTYPE;
    branch_info public.branches_2026_02_17_18_40%ROWTYPE;
    result json;
BEGIN
    -- Get user record
    SELECT * INTO user_record
    FROM public.auth_users_2026_02_17_18_40
    WHERE email = user_email AND is_active = true;
    
    IF NOT FOUND THEN
        RETURN json_build_object('success', false, 'error', 'Invalid credentials');
    END IF;
    
    -- Check if account is locked
    IF user_record.locked_until IS NOT NULL AND user_record.locked_until > now() THEN
        RETURN json_build_object('success', false, 'error', 'Account is temporarily locked');
    END IF;
    
    -- Simple password check (in production, use proper hashing)
    IF user_record.password_hash != user_password THEN
        -- Increment failed attempts
        UPDATE public.auth_users_2026_02_17_18_40
        SET failed_attempts = failed_attempts + 1,
            locked_until = CASE 
                WHEN failed_attempts >= 4 THEN now() + interval '15 minutes'
                ELSE NULL
            END
        WHERE id = user_record.id;
        
        RETURN json_build_object('success', false, 'error', 'Invalid credentials');
    END IF;
    
    -- Get branch info
    SELECT * INTO branch_info
    FROM public.branches_2026_02_17_18_40
    WHERE id = user_record.branch_id;
    
    -- Update successful login
    UPDATE public.auth_users_2026_02_17_18_40
    SET last_login_at = now(), 
        updated_at = now(),
        failed_attempts = 0,
        locked_until = NULL
    WHERE id = user_record.id;
    
    -- Build success result
    result := json_build_object(
        'success', true,
        'user', json_build_object(
            'id', user_record.id,
            'email', user_record.email,
            'full_name', user_record.full_name,
            'role', user_record.role,
            'branch_name', COALESCE(branch_info.name, 'Unknown Branch'),
            'branch_code', COALESCE(branch_info.code, 'UNK'),
            'must_change_password', user_record.must_change_password,
            'is_active', user_record.is_active,
            'last_login_at', user_record.last_login_at
        )
    );
    
    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create password change function
CREATE OR REPLACE FUNCTION public.change_user_password_2026_02_17_18_40(user_id uuid, new_password text)
RETURNS json AS $$
BEGIN
    UPDATE public.auth_users_2026_02_17_18_40
    SET password_hash = new_password,
        must_change_password = false,
        updated_at = now()
    WHERE id = user_id AND is_active = true;
    
    IF FOUND THEN
        RETURN json_build_object('success', true, 'message', 'Password changed successfully');
    ELSE
        RETURN json_build_object('success', false, 'error', 'User not found');
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;