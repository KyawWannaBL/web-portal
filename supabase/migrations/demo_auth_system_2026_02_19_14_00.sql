-- Create demo user accounts for each role with proper UUIDs
-- Insert demo profiles with different roles for testing

-- Create a simple login credentials table for demo purposes
CREATE TABLE IF NOT EXISTS demo_login_credentials_2026_02_19_14_00 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL, -- In real app, this would be properly hashed
  role TEXT NOT NULL,
  full_name TEXT NOT NULL,
  is_active BOOLEAN DEFAULT true,
  last_login TIMESTAMPTZ,
  login_attempts INTEGER DEFAULT 0,
  locked_until TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE demo_login_credentials_2026_02_19_14_00 ENABLE ROW LEVEL SECURITY;

-- RLS Policies for demo login credentials - Allow public access for demo
CREATE POLICY "Public access for demo" ON demo_login_credentials_2026_02_19_14_00
  FOR ALL USING (true);

-- Insert demo login credentials (password is 'demo123' for all accounts)
INSERT INTO demo_login_credentials_2026_02_19_14_00 (email, password_hash, role, full_name) VALUES
('owner@britiumexpress.com', 'demo123', 'APP_OWNER', 'Application Owner'),
('admin@britiumexpress.com', 'demo123', 'SUPER_ADMIN', 'Super Administrator'),
('operations@britiumexpress.com', 'demo123', 'OPERATIONS_ADMIN', 'Operations Administrator'),
('supervisor@britiumexpress.com', 'demo123', 'SUPERVISOR', 'Operations Supervisor'),
('warehouse@britiumexpress.com', 'demo123', 'WAREHOUSE_MANAGER', 'Warehouse Manager'),
('substation@britiumexpress.com', 'demo123', 'SUBSTATION_MANAGER', 'Substation Manager'),
('rider@britiumexpress.com', 'demo123', 'RIDER', 'Delivery Rider'),
('dataentry@britiumexpress.com', 'demo123', 'DATA_ENTRY', 'Data Entry Clerk'),
('finance@britiumexpress.com', 'demo123', 'FINANCE_STAFF', 'Finance Staff'),
('financeuser@britiumexpress.com', 'demo123', 'FINANCE_USER', 'Finance User'),
('hr@britiumexpress.com', 'demo123', 'HR_ADMIN', 'HR Administrator'),
('marketing@britiumexpress.com', 'demo123', 'MARKETING_ADMIN', 'Marketing Administrator'),
('support@britiumexpress.com', 'demo123', 'CUSTOMER_SERVICE', 'Customer Service Rep'),
('merchant@britiumexpress.com', 'demo123', 'MERCHANT', 'Premium Merchant'),
('customer@britiumexpress.com', 'demo123', 'CUSTOMER', 'VIP Customer')
ON CONFLICT (email) DO NOTHING;

-- Create function to authenticate demo users
CREATE OR REPLACE FUNCTION authenticate_demo_user_2026_02_19_14_00(
  p_email TEXT,
  p_password TEXT
)
RETURNS TABLE(
  success BOOLEAN,
  user_id UUID,
  email TEXT,
  role TEXT,
  full_name TEXT,
  message TEXT
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Check if user exists and password matches
  SELECT 
    true,
    dlc.id,
    dlc.email,
    dlc.role,
    dlc.full_name,
    'Login successful'
  INTO success, user_id, email, role, full_name, message
  FROM demo_login_credentials_2026_02_19_14_00 dlc
  WHERE dlc.email = p_email 
    AND dlc.password_hash = p_password 
    AND dlc.is_active = true;

  -- If no match found
  IF NOT FOUND THEN
    SELECT false, NULL, NULL, NULL, NULL, 'Invalid email or password'
    INTO success, user_id, email, role, full_name, message;
  ELSE
    -- Update last login
    UPDATE demo_login_credentials_2026_02_19_14_00 
    SET last_login = NOW(), login_attempts = 0
    WHERE email = p_email;
  END IF;

  RETURN NEXT;
END;
$$;