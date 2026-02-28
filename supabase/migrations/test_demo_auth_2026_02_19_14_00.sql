-- Test the demo authentication system
-- First, let's check if our demo credentials table exists and has data
SELECT 
  email, 
  role, 
  full_name, 
  is_active,
  created_at
FROM demo_login_credentials_2026_02_19_14_00 
ORDER BY created_at;

-- Test the authentication function with a sample user
SELECT * FROM authenticate_demo_user_2026_02_19_14_00('admin@britiumexpress.com', 'demo123');