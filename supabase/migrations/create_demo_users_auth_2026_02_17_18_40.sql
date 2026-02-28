-- Create demo users directly in auth.users table for testing
-- Note: This is a simplified approach for demo purposes

-- First, let's check if we have any users
SELECT COUNT(*) as user_count FROM auth.users;

-- Insert demo users into auth.users table
-- Note: In production, users would sign up through the UI
INSERT INTO auth.users (
    id,
    instance_id,
    email,
    encrypted_password,
    email_confirmed_at,
    created_at,
    updated_at,
    raw_user_meta_data,
    is_super_admin,
    role,
    aud
) VALUES 
-- Admin user
(
    gen_random_uuid(),
    '00000000-0000-0000-0000-000000000000',
    'admin@britium.com',
    crypt('admin123', gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"role": "SUPER_ADMIN", "full_name": "System Administrator"}',
    false,
    'authenticated',
    'authenticated'
),
-- Operations Manager
(
    gen_random_uuid(),
    '00000000-0000-0000-0000-000000000000',
    'ops@britium.com',
    crypt('ops123', gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"role": "OPERATIONS_ADMIN", "full_name": "Operations Manager"}',
    false,
    'authenticated',
    'authenticated'
),
-- Warehouse Manager
(
    gen_random_uuid(),
    '00000000-0000-0000-0000-000000000000',
    'warehouse@britium.com',
    crypt('warehouse123', gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"role": "WAREHOUSE_MANAGER", "full_name": "Warehouse Manager"}',
    false,
    'authenticated',
    'authenticated'
),
-- Delivery Rider
(
    gen_random_uuid(),
    '00000000-0000-0000-0000-000000000000',
    'rider@britium.com',
    crypt('rider123', gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"role": "RIDER", "full_name": "Delivery Rider"}',
    false,
    'authenticated',
    'authenticated'
)
ON CONFLICT (email) DO NOTHING;

-- The trigger should automatically create profiles for these users
-- Let's also manually ensure profiles exist
INSERT INTO public.profiles (
    id,
    email,
    full_name,
    role,
    is_active,
    must_change_password
)
SELECT 
    u.id,
    u.email,
    u.raw_user_meta_data->>'full_name',
    u.raw_user_meta_data->>'role',
    true,
    false
FROM auth.users u
WHERE u.email IN ('admin@britium.com', 'ops@britium.com', 'warehouse@britium.com', 'rider@britium.com')
ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    full_name = EXCLUDED.full_name,
    role = EXCLUDED.role,
    is_active = EXCLUDED.is_active,
    must_change_password = EXCLUDED.must_change_password;

-- Check what we created
SELECT 
    u.email,
    u.created_at,
    p.role,
    p.full_name,
    p.is_active
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.id
WHERE u.email LIKE '%@britium.com'
ORDER BY u.created_at;