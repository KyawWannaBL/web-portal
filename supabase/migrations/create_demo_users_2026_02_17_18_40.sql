-- First, let's create some demo users directly in the auth.users table for testing
-- Note: In production, you would use the edge function, but for demo we'll create them directly

-- Insert demo users into auth.users (this simulates what Supabase Auth would do)
-- Note: These are demo passwords, in production they would be properly hashed
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
    role
) VALUES 
(
    gen_random_uuid(),
    '00000000-0000-0000-0000-000000000000',
    'admin@logistics.com',
    crypt('admin123', gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"role": "SUPER_ADMIN", "full_name": "System Administrator"}',
    false,
    'authenticated'
),
(
    gen_random_uuid(),
    '00000000-0000-0000-0000-000000000000',
    'ops.manager@logistics.com',
    crypt('ops123', gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"role": "OPERATIONS_ADMIN", "full_name": "Operations Manager"}',
    false,
    'authenticated'
),
(
    gen_random_uuid(),
    '00000000-0000-0000-0000-000000000000',
    'warehouse.staff@logistics.com',
    crypt('warehouse123', gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"role": "WAREHOUSE_MANAGER", "full_name": "Warehouse Staff"}',
    false,
    'authenticated'
),
(
    gen_random_uuid(),
    '00000000-0000-0000-0000-000000000000',
    'rider.001@logistics.com',
    crypt('rider123', gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"role": "RIDER", "full_name": "Delivery Rider 001"}',
    false,
    'authenticated'
)
ON CONFLICT (email) DO NOTHING;

-- The trigger will automatically create profiles for these users