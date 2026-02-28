-- Create admin accounts for Britium Express
-- Super Admin and Admin accounts with default passwords

-- Insert Super Admin account
INSERT INTO public.users (
  firebase_uid,
  email,
  full_name,
  role,
  status,
  language_preference,
  force_password_change,
  created_at
) VALUES (
  'super-admin-mgkyawwanna',
  'mgkyawwanna@gmail.com',
  'Mg Kyaw Wanna',
  'super_admin',
  'active',
  'en',
  true,
  NOW()
) ON CONFLICT (email) DO UPDATE SET
  role = EXCLUDED.role,
  status = EXCLUDED.status,
  force_password_change = EXCLUDED.force_password_change;

-- Insert Admin accounts
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

-- Create user permissions for admin accounts
INSERT INTO public.user_permissions (
  user_id,
  permission,
  resource,
  granted_at
)
SELECT 
  u.id,
  'all',
  'system',
  NOW()
FROM public.users u
WHERE u.email IN (
  'mgkyawwanna@gmail.com',
  'gm@britiumexpress.com', 
  'sai@britiumexpress.com',
  'hod@britiumexpress.com'
)
ON CONFLICT (user_id, permission, resource) DO NOTHING;

-- Update RLS policies to allow admin access
CREATE POLICY "Admins can manage all users" ON public.users
  FOR ALL USING (
    auth.uid() IN (
      SELECT firebase_uid FROM public.users 
      WHERE role IN ('super_admin', 'admin') AND status = 'active'
    )
  );

-- Create admin dashboard access policy
CREATE POLICY "Admin dashboard access" ON public.user_permissions
  FOR SELECT USING (
    auth.uid() IN (
      SELECT firebase_uid FROM public.users 
      WHERE role IN ('super_admin', 'admin', 'manager') AND status = 'active'
    )
  );