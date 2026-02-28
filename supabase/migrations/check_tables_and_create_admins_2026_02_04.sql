-- Check existing table structures
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'user_permissions' AND table_schema = 'public';

-- Check users table structure
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'users' AND table_schema = 'public';

-- Create admin accounts for Britium Express (simplified)
INSERT INTO public.users (
  firebase_uid,
  email,
  full_name,
  role,
  status,
  language_preference,
  force_password_change,
  created_at
) VALUES 
(
  'super-admin-mgkyawwanna',
  'mgkyawwanna@gmail.com',
  'Mg Kyaw Wanna',
  'super_admin',
  'active',
  'en',
  true,
  NOW()
),
(
  'admin-gm-britium',
  'gm@britiumexpress.com',
  'General Manager',
  'admin',
  'active',
  'en',
  true,
  NOW()
),
(
  'admin-sai-britium',
  'sai@britiumexpress.com',
  'Sai Admin',
  'admin',
  'active',
  'en',
  true,
  NOW()
),
(
  'admin-hod-britium',
  'hod@britiumexpress.com',
  'Head of Department',
  'admin',
  'active',
  'en',
  true,
  NOW()
)
ON CONFLICT (email) DO UPDATE SET
  role = EXCLUDED.role,
  status = EXCLUDED.status,
  force_password_change = EXCLUDED.force_password_change;