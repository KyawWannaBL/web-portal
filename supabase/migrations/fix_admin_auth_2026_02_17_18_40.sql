-- Delete existing admin user if exists
DELETE FROM public.auth_users_2026_02_17_18_40 WHERE email = 'admin@logistics.com';

-- Insert admin user again with explicit values
INSERT INTO public.auth_users_2026_02_17_18_40 (
    email, 
    password_hash, 
    full_name, 
    role, 
    branch_id, 
    must_change_password,
    is_active
) VALUES (
    'admin@logistics.com', 
    'admin123', 
    'System Administrator', 
    'SUPER_ADMIN', 
    (SELECT id FROM public.branches_2026_02_17_18_40 WHERE code = 'YGN-001' LIMIT 1), 
    false,
    true
);

-- Test authentication again
SELECT public.authenticate_user_2026_02_17_18_40('admin@logistics.com', 'admin123') as auth_result;

-- Also check all users to see what we have
SELECT email, password_hash, role, is_active, must_change_password 
FROM public.auth_users_2026_02_17_18_40 
ORDER BY email;