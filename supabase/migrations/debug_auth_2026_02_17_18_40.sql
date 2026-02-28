-- Check if the admin user exists
SELECT email, password_hash, full_name, role, is_active, must_change_password 
FROM public.auth_users_2026_02_17_18_40 
WHERE email = 'admin@logistics.com';

-- Test the authentication function directly
SELECT public.authenticate_user_2026_02_17_18_40('admin@logistics.com', 'admin123');