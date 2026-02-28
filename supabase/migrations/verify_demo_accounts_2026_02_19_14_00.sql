-- Verify all demo accounts exist and are active
SELECT 
  email,
  role,
  full_name,
  is_active,
  created_at
FROM demo_login_credentials_2026_02_19_14_00 
WHERE is_active = true
ORDER BY 
  CASE role
    WHEN 'APP_OWNER' THEN 1
    WHEN 'SUPER_ADMIN' THEN 2
    WHEN 'OPERATIONS_ADMIN' THEN 3
    WHEN 'SUPERVISOR' THEN 4
    WHEN 'WAREHOUSE_MANAGER' THEN 5
    WHEN 'SUBSTATION_MANAGER' THEN 6
    WHEN 'RIDER' THEN 7
    WHEN 'DATA_ENTRY' THEN 8
    WHEN 'FINANCE_STAFF' THEN 9
    WHEN 'FINANCE_USER' THEN 10
    WHEN 'HR_ADMIN' THEN 11
    WHEN 'MARKETING_ADMIN' THEN 12
    WHEN 'CUSTOMER_SERVICE' THEN 13
    WHEN 'MERCHANT' THEN 14
    WHEN 'CUSTOMER' THEN 15
    ELSE 99
  END;

-- Test authentication for a few key roles
SELECT 'Testing APP_OWNER' as test_case, * FROM authenticate_demo_user_2026_02_19_14_00('owner@britiumexpress.com', 'demo123')
UNION ALL
SELECT 'Testing SUPER_ADMIN' as test_case, * FROM authenticate_demo_user_2026_02_19_14_00('admin@britiumexpress.com', 'demo123')
UNION ALL
SELECT 'Testing RIDER' as test_case, * FROM authenticate_demo_user_2026_02_19_14_00('rider@britiumexpress.com', 'demo123')
UNION ALL
SELECT 'Testing CUSTOMER' as test_case, * FROM authenticate_demo_user_2026_02_19_14_00('customer@britiumexpress.com', 'demo123');