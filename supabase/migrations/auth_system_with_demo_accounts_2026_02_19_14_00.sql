-- Create demo user accounts for each role
-- Insert demo profiles with different roles for testing

-- First, let's ensure we have all the necessary roles in our profiles table
INSERT INTO profiles_2026_02_19_13_00 (
  id,
  email,
  full_name,
  phone,
  role,
  department,
  branch_id,
  employee_id,
  status,
  permissions,
  address,
  created_at,
  updated_at
) VALUES 
-- APP_OWNER
('demo-app-owner-001', 'owner@britiumexpress.com', 'Application Owner', '+95-9-111-111-111', 'APP_OWNER', 'Executive', (SELECT id FROM branches_2026_02_19_13_00 LIMIT 1), 'EMP-001', 'ACTIVE', '{"all": true}', 'Yangon, Myanmar', NOW(), NOW()),

-- SUPER_ADMIN
('demo-super-admin-001', 'admin@britiumexpress.com', 'Super Administrator', '+95-9-222-222-222', 'SUPER_ADMIN', 'IT', (SELECT id FROM branches_2026_02_19_13_00 LIMIT 1), 'EMP-002', 'ACTIVE', '{"admin": true}', 'Yangon, Myanmar', NOW(), NOW()),

-- OPERATIONS_ADMIN
('demo-ops-admin-001', 'operations@britiumexpress.com', 'Operations Administrator', '+95-9-333-333-333', 'OPERATIONS_ADMIN', 'Operations', (SELECT id FROM branches_2026_02_19_13_00 LIMIT 1), 'EMP-003', 'ACTIVE', '{"operations": true}', 'Yangon, Myanmar', NOW(), NOW()),

-- SUPERVISOR
('demo-supervisor-001', 'supervisor@britiumexpress.com', 'Operations Supervisor', '+95-9-444-444-444', 'SUPERVISOR', 'Operations', (SELECT id FROM branches_2026_02_19_13_00 LIMIT 1), 'EMP-004', 'ACTIVE', '{"supervise": true}', 'Yangon, Myanmar', NOW(), NOW()),

-- WAREHOUSE_MANAGER
('demo-warehouse-mgr-001', 'warehouse@britiumexpress.com', 'Warehouse Manager', '+95-9-555-555-555', 'WAREHOUSE_MANAGER', 'Warehouse', (SELECT id FROM branches_2026_02_19_13_00 LIMIT 1), 'EMP-005', 'ACTIVE', '{"warehouse": true}', 'Yangon, Myanmar', NOW(), NOW()),

-- SUBSTATION_MANAGER
('demo-substation-mgr-001', 'substation@britiumexpress.com', 'Substation Manager', '+95-9-666-666-666', 'SUBSTATION_MANAGER', 'Substation', (SELECT id FROM branches_2026_02_19_13_00 OFFSET 1 LIMIT 1), 'EMP-006', 'ACTIVE', '{"substation": true}', 'Mandalay, Myanmar', NOW(), NOW()),

-- RIDER
('demo-rider-001', 'rider@britiumexpress.com', 'Delivery Rider', '+95-9-777-777-777', 'RIDER', 'Delivery', (SELECT id FROM branches_2026_02_19_13_00 LIMIT 1), 'EMP-007', 'ACTIVE', '{"delivery": true}', 'Yangon, Myanmar', NOW(), NOW()),

-- DATA_ENTRY
('demo-data-entry-001', 'dataentry@britiumexpress.com', 'Data Entry Clerk', '+95-9-888-888-888', 'DATA_ENTRY', 'Operations', (SELECT id FROM branches_2026_02_19_13_00 LIMIT 1), 'EMP-008', 'ACTIVE', '{"data_entry": true}', 'Yangon, Myanmar', NOW(), NOW()),

-- FINANCE_STAFF
('demo-finance-001', 'finance@britiumexpress.com', 'Finance Staff', '+95-9-999-999-999', 'FINANCE_STAFF', 'Finance', (SELECT id FROM branches_2026_02_19_13_00 LIMIT 1), 'EMP-009', 'ACTIVE', '{"finance": true}', 'Yangon, Myanmar', NOW(), NOW()),

-- FINANCE_USER
('demo-finance-user-001', 'financeuser@britiumexpress.com', 'Finance User', '+95-9-101-101-101', 'FINANCE_USER', 'Finance', (SELECT id FROM branches_2026_02_19_13_00 LIMIT 1), 'EMP-010', 'ACTIVE', '{"finance_view": true}', 'Yangon, Myanmar', NOW(), NOW()),

-- HR_ADMIN
('demo-hr-admin-001', 'hr@britiumexpress.com', 'HR Administrator', '+95-9-202-202-202', 'HR_ADMIN', 'Human Resources', (SELECT id FROM branches_2026_02_19_13_00 LIMIT 1), 'EMP-011', 'ACTIVE', '{"hr": true}', 'Yangon, Myanmar', NOW(), NOW()),

-- MARKETING_ADMIN
('demo-marketing-001', 'marketing@britiumexpress.com', 'Marketing Administrator', '+95-9-303-303-303', 'MARKETING_ADMIN', 'Marketing', (SELECT id FROM branches_2026_02_19_13_00 LIMIT 1), 'EMP-012', 'ACTIVE', '{"marketing": true}', 'Yangon, Myanmar', NOW(), NOW()),

-- CUSTOMER_SERVICE
('demo-cs-001', 'support@britiumexpress.com', 'Customer Service Rep', '+95-9-404-404-404', 'CUSTOMER_SERVICE', 'Customer Service', (SELECT id FROM branches_2026_02_19_13_00 LIMIT 1), 'EMP-013', 'ACTIVE', '{"customer_service": true}', 'Yangon, Myanmar', NOW(), NOW()),

-- MERCHANT
('demo-merchant-001', 'merchant@britiumexpress.com', 'Premium Merchant', '+95-9-505-505-505', 'MERCHANT', 'External', NULL, 'MERCH-001', 'ACTIVE', '{"merchant": true}', 'Yangon, Myanmar', NOW(), NOW()),

-- CUSTOMER
('demo-customer-001', 'customer@britiumexpress.com', 'VIP Customer', '+95-9-606-606-606', 'CUSTOMER', 'External', NULL, 'CUST-001', 'ACTIVE', '{"customer": true}', 'Yangon, Myanmar', NOW(), NOW())

ON CONFLICT (id) DO UPDATE SET
  email = EXCLUDED.email,
  full_name = EXCLUDED.full_name,
  phone = EXCLUDED.phone,
  role = EXCLUDED.role,
  department = EXCLUDED.department,
  updated_at = NOW();

-- Create a simple login credentials table for demo purposes
CREATE TABLE IF NOT EXISTS demo_login_credentials_2026_02_19_14_00 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID REFERENCES profiles_2026_02_19_13_00(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL, -- In real app, this would be properly hashed
  is_active BOOLEAN DEFAULT true,
  last_login TIMESTAMPTZ,
  login_attempts INTEGER DEFAULT 0,
  locked_until TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE demo_login_credentials_2026_02_19_14_00 ENABLE ROW LEVEL SECURITY;

-- RLS Policies for demo login credentials
CREATE POLICY "Users can view own credentials" ON demo_login_credentials_2026_02_19_14_00
  FOR SELECT USING (auth.uid()::text = profile_id::text);

CREATE POLICY "Admins can manage all credentials" ON demo_login_credentials_2026_02_19_14_00
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM profiles_2026_02_19_13_00 
      WHERE id::text = auth.uid()::text 
      AND role IN ('APP_OWNER', 'SUPER_ADMIN')
    )
  );

-- Insert demo login credentials (password is 'demo123' for all accounts)
INSERT INTO demo_login_credentials_2026_02_19_14_00 (profile_id, email, password_hash) VALUES
('demo-app-owner-001', 'owner@britiumexpress.com', 'demo123'),
('demo-super-admin-001', 'admin@britiumexpress.com', 'demo123'),
('demo-ops-admin-001', 'operations@britiumexpress.com', 'demo123'),
('demo-supervisor-001', 'supervisor@britiumexpress.com', 'demo123'),
('demo-warehouse-mgr-001', 'warehouse@britiumexpress.com', 'demo123'),
('demo-substation-mgr-001', 'substation@britiumexpress.com', 'demo123'),
('demo-rider-001', 'rider@britiumexpress.com', 'demo123'),
('demo-data-entry-001', 'dataentry@britiumexpress.com', 'demo123'),
('demo-finance-001', 'finance@britiumexpress.com', 'demo123'),
('demo-finance-user-001', 'financeuser@britiumexpress.com', 'demo123'),
('demo-hr-admin-001', 'hr@britiumexpress.com', 'demo123'),
('demo-marketing-001', 'marketing@britiumexpress.com', 'demo123'),
('demo-cs-001', 'support@britiumexpress.com', 'demo123'),
('demo-merchant-001', 'merchant@britiumexpress.com', 'demo123'),
('demo-customer-001', 'customer@britiumexpress.com', 'demo123')
ON CONFLICT (email) DO NOTHING;