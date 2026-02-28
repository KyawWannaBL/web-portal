-- Create multiple demo user accounts for testing
-- This approach manually creates profiles that can be used for testing

-- First, let's create profiles directly (bypassing auth.users for now)
-- This allows immediate testing without email verification

-- Clear any existing demo profiles
DELETE FROM public.profiles WHERE email LIKE '%@britiumexpress.com';

-- Create demo user profiles for testing
INSERT INTO public.profiles (id, email, full_name, role, is_active, must_change_password) VALUES
-- Super Admin
(gen_random_uuid(), 'admin@britiumexpress.com', 'System Administrator', 'SUPER_ADMIN', true, false),
-- Operations Admin
(gen_random_uuid(), 'ops@britiumexpress.com', 'Operations Manager', 'OPERATIONS_ADMIN', true, false),
-- Warehouse Manager
(gen_random_uuid(), 'warehouse@britiumexpress.com', 'Warehouse Manager', 'WAREHOUSE_MANAGER', true, false),
-- Supervisor
(gen_random_uuid(), 'supervisor@britiumexpress.com', 'Site Supervisor', 'SUPERVISOR', true, false),
-- Rider/Driver
(gen_random_uuid(), 'rider@britiumexpress.com', 'Delivery Rider', 'RIDER', true, false),
-- Customer Service
(gen_random_uuid(), 'support@britiumexpress.com', 'Customer Support', 'CUSTOMER_SERVICE', true, false),
-- Finance Staff
(gen_random_uuid(), 'finance@britiumexpress.com', 'Finance Officer', 'FINANCE_STAFF', true, false),
-- HR Admin
(gen_random_uuid(), 'hr@britiumexpress.com', 'HR Manager', 'HR_ADMIN', true, false),
-- Data Entry
(gen_random_uuid(), 'data@britiumexpress.com', 'Data Entry Clerk', 'DATA_ENTRY', true, false),
-- Merchant
(gen_random_uuid(), 'merchant@britiumexpress.com', 'Business Partner', 'MERCHANT', true, false),
-- Customer
(gen_random_uuid(), 'customer@britiumexpress.com', 'Regular Customer', 'CUSTOMER', true, false);

-- Create a temporary bypass authentication function
CREATE OR REPLACE FUNCTION public.bypass_login(user_email TEXT)
RETURNS TABLE(
    id UUID,
    email TEXT,
    full_name TEXT,
    role TEXT,
    avatar_url TEXT,
    is_active BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id,
        p.email,
        p.full_name,
        p.role,
        p.avatar_url,
        p.is_active
    FROM public.profiles p
    WHERE p.email = user_email AND p.is_active = true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission on the bypass function
GRANT EXECUTE ON FUNCTION public.bypass_login(TEXT) TO anon, authenticated;

-- Temporarily make RLS policies more permissive for testing
DROP POLICY IF EXISTS "authenticated_select_profiles" ON public.profiles;
DROP POLICY IF EXISTS "authenticated_insert_profiles" ON public.profiles;
DROP POLICY IF EXISTS "users_update_own_profile" ON public.profiles;

-- Create very permissive policies for testing
CREATE POLICY "allow_all_select_profiles" ON public.profiles
    FOR SELECT USING (true);

CREATE POLICY "allow_all_insert_profiles" ON public.profiles
    FOR INSERT WITH CHECK (true);

CREATE POLICY "allow_all_update_profiles" ON public.profiles
    FOR UPDATE USING (true);

-- Also make branches and shipments accessible
DROP POLICY IF EXISTS "Allow authenticated users to view branches" ON public.branches;
CREATE POLICY "allow_all_select_branches" ON public.branches
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow authenticated users to view shipments" ON public.shipments;
DROP POLICY IF EXISTS "Allow authenticated users to insert shipments" ON public.shipments;
DROP POLICY IF EXISTS "Allow authenticated users to update shipments" ON public.shipments;

CREATE POLICY "allow_all_select_shipments" ON public.shipments
    FOR SELECT USING (true);

CREATE POLICY "allow_all_insert_shipments" ON public.shipments
    FOR INSERT WITH CHECK (true);

CREATE POLICY "allow_all_update_shipments" ON public.shipments
    FOR UPDATE USING (true);

-- Add some sample shipments for testing
INSERT INTO public.shipments (tracking_number, sender_name, sender_phone, sender_address, recipient_name, recipient_phone, recipient_address, status, weight, origin_branch_id, destination_branch_id) 
SELECT 
    'BX' || LPAD((ROW_NUMBER() OVER())::TEXT, 6, '0'),
    'Sender ' || (ROW_NUMBER() OVER()),
    '+95-9-' || LPAD((ROW_NUMBER() OVER())::TEXT, 8, '0'),
    'Address ' || (ROW_NUMBER() OVER()) || ', Yangon',
    'Recipient ' || (ROW_NUMBER() OVER()),
    '+95-9-' || LPAD((ROW_NUMBER() OVER() + 1000)::TEXT, 8, '0'),
    'Delivery Address ' || (ROW_NUMBER() OVER()) || ', Mandalay',
    CASE (ROW_NUMBER() OVER()) % 4
        WHEN 0 THEN 'PENDING'
        WHEN 1 THEN 'IN_TRANSIT'
        WHEN 2 THEN 'DELIVERED'
        ELSE 'PROCESSING'
    END,
    (RANDOM() * 10 + 1)::DECIMAL(10,2),
    (SELECT id FROM public.branches WHERE code = 'YGN-HQ' LIMIT 1),
    (SELECT id FROM public.branches WHERE code = 'MDL-01' LIMIT 1)
FROM generate_series(1, 20);

-- Show created demo accounts
SELECT 
    email,
    full_name,
    role,
    is_active,
    'Password: Use bypass login' as login_method
FROM public.profiles 
WHERE email LIKE '%@britiumexpress.com'
ORDER BY 
    CASE role
        WHEN 'SUPER_ADMIN' THEN 1
        WHEN 'OPERATIONS_ADMIN' THEN 2
        WHEN 'WAREHOUSE_MANAGER' THEN 3
        WHEN 'SUPERVISOR' THEN 4
        WHEN 'RIDER' THEN 5
        WHEN 'CUSTOMER_SERVICE' THEN 6
        WHEN 'FINANCE_STAFF' THEN 7
        WHEN 'HR_ADMIN' THEN 8
        WHEN 'DATA_ENTRY' THEN 9
        WHEN 'MERCHANT' THEN 10
        ELSE 11
    END;

-- Show summary
SELECT 
    'Demo Accounts Created' as status,
    COUNT(*) as total_accounts
FROM public.profiles 
WHERE email LIKE '%@britiumexpress.com'
UNION ALL
SELECT 
    'Sample Shipments Created' as status,
    COUNT(*) as total_shipments
FROM public.shipments
UNION ALL
SELECT 
    'Branches Available' as status,
    COUNT(*) as total_branches
FROM public.branches;