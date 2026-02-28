-- New BE App Pages Tables for Britium Express
-- Created: 2026-02-04 05:03 UTC

-- Way Management Tables (New)
CREATE TABLE IF NOT EXISTS public.delivery_ways (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tracking_number VARCHAR(50) UNIQUE NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'in_transit', 'delivered', 'failed', 'returned')),
    pickup_address TEXT NOT NULL,
    delivery_address TEXT NOT NULL,
    pickup_date TIMESTAMP WITH TIME ZONE,
    delivery_date TIMESTAMP WITH TIME ZONE,
    rider_name VARCHAR(100),
    vehicle_type VARCHAR(50),
    priority INTEGER DEFAULT 1 CHECK (priority BETWEEN 1 AND 5),
    cod_amount DECIMAL(10,2) DEFAULT 0,
    delivery_fee DECIMAL(10,2) NOT NULL,
    weight DECIMAL(8,2),
    special_instructions TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.failed_deliveries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tracking_number VARCHAR(50) NOT NULL,
    failure_reason VARCHAR(100) NOT NULL,
    failure_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    retry_count INTEGER DEFAULT 0,
    next_retry_date TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    resolved BOOLEAN DEFAULT FALSE,
    resolved_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.return_shipments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    original_tracking_number VARCHAR(50) NOT NULL,
    return_reason VARCHAR(100) NOT NULL,
    return_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    return_status VARCHAR(20) DEFAULT 'initiated' CHECK (return_status IN ('initiated', 'in_transit', 'completed', 'cancelled')),
    refund_amount DECIMAL(10,2),
    refund_status VARCHAR(20) DEFAULT 'pending' CHECK (refund_status IN ('pending', 'processed', 'cancelled')),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Merchant Management Tables (New)
CREATE TABLE IF NOT EXISTS public.merchants_be (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_name VARCHAR(200) NOT NULL,
    business_type VARCHAR(100),
    registration_number VARCHAR(100),
    contact_person VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended', 'pending')),
    credit_limit DECIMAL(12,2) DEFAULT 0,
    current_balance DECIMAL(12,2) DEFAULT 0,
    payment_terms INTEGER DEFAULT 30,
    total_orders INTEGER DEFAULT 0,
    total_revenue DECIMAL(12,2) DEFAULT 0,
    registration_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_order_date TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.merchant_bank_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID NOT NULL,
    bank_name VARCHAR(100) NOT NULL,
    account_number VARCHAR(50) NOT NULL,
    account_holder_name VARCHAR(100) NOT NULL,
    account_type VARCHAR(50) DEFAULT 'savings',
    branch_name VARCHAR(100),
    is_primary BOOLEAN DEFAULT FALSE,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.merchant_receipts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID NOT NULL,
    receipt_number VARCHAR(50) UNIQUE NOT NULL,
    receipt_type VARCHAR(50) NOT NULL CHECK (receipt_type IN ('payment', 'refund', 'commission', 'adjustment')),
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'MMK',
    payment_method VARCHAR(50),
    description TEXT,
    receipt_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    due_date TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'overdue', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Deliveryman Management Tables (New)
CREATE TABLE IF NOT EXISTS public.deliverymen_be (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    employee_id VARCHAR(50) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    address TEXT,
    city VARCHAR(100),
    date_of_birth DATE,
    hire_date DATE DEFAULT CURRENT_DATE,
    employment_status VARCHAR(20) DEFAULT 'active' CHECK (employment_status IN ('active', 'inactive', 'suspended', 'terminated')),
    vehicle_type VARCHAR(50),
    vehicle_number VARCHAR(50),
    license_number VARCHAR(50),
    zone_assignment VARCHAR(100),
    base_salary DECIMAL(10,2) DEFAULT 0,
    total_deliveries INTEGER DEFAULT 0,
    successful_deliveries INTEGER DEFAULT 0,
    failed_deliveries INTEGER DEFAULT 0,
    total_earnings DECIMAL(12,2) DEFAULT 0,
    current_cash_advance DECIMAL(10,2) DEFAULT 0,
    performance_rating DECIMAL(3,2) DEFAULT 0,
    last_active TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.cash_advances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    deliveryman_id UUID NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    advance_type VARCHAR(20) DEFAULT 'regular' CHECK (advance_type IN ('regular', 'emergency', 'salary_advance')),
    reason TEXT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'disbursed', 'repaid')),
    disbursement_date TIMESTAMP WITH TIME ZONE,
    remaining_balance DECIMAL(10,2),
    interest_rate DECIMAL(5,2) DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Broadcast Messages Tables (New)
CREATE TABLE IF NOT EXISTS public.broadcast_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_title VARCHAR(200) NOT NULL,
    message_content TEXT NOT NULL,
    message_type VARCHAR(50) DEFAULT 'general' CHECK (message_type IN ('general', 'urgent', 'maintenance', 'promotion', 'system')),
    target_audience VARCHAR(50) NOT NULL CHECK (target_audience IN ('all_users', 'merchants', 'deliverymen', 'customers', 'admins', 'custom')),
    delivery_method VARCHAR(50) DEFAULT 'in_app' CHECK (delivery_method IN ('in_app', 'email', 'sms', 'push', 'all')),
    scheduled_send_time TIMESTAMP WITH TIME ZONE,
    sent_time TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'scheduled', 'sending', 'sent', 'failed', 'cancelled')),
    total_recipients INTEGER DEFAULT 0,
    successful_deliveries INTEGER DEFAULT 0,
    failed_deliveries INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- System Settings Tables (New)
CREATE TABLE IF NOT EXISTS public.system_settings_be (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    setting_category VARCHAR(50) NOT NULL,
    setting_key VARCHAR(100) NOT NULL,
    setting_value TEXT,
    setting_type VARCHAR(20) DEFAULT 'string' CHECK (setting_type IN ('string', 'number', 'boolean', 'json')),
    description TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(setting_category, setting_key)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_delivery_ways_status ON public.delivery_ways(status);
CREATE INDEX IF NOT EXISTS idx_delivery_ways_tracking ON public.delivery_ways(tracking_number);
CREATE INDEX IF NOT EXISTS idx_merchants_be_status ON public.merchants_be(status);
CREATE INDEX IF NOT EXISTS idx_deliverymen_be_status ON public.deliverymen_be(employment_status);
CREATE INDEX IF NOT EXISTS idx_broadcast_messages_status ON public.broadcast_messages(status);

-- Insert sample data for delivery ways
INSERT INTO public.delivery_ways (tracking_number, pickup_address, delivery_address, delivery_fee, status, rider_name, vehicle_type, weight, cod_amount) VALUES
('BE2026020401', '123 Sender Street, Yangon', '456 Receiver Road, Mandalay', 5000, 'in_transit', 'Ko Aung Kyaw', 'Motorcycle', 2.5, 25000),
('BE2026020402', '789 Shop Avenue, Yangon', '321 Customer Lane, Yangon', 2000, 'delivered', 'Ko Thura Min', 'Van', 5.0, 0),
('BE2026020403', '555 Business Plaza, Mandalay', '777 Home Street, Yangon', 4500, 'pending', 'Ma Aye Aye', 'Motorcycle', 1.8, 15000),
('BE2026020404', '111 Market Street, Yangon', '222 Office Tower, Mandalay', 6000, 'failed', 'Ko Aung Kyaw', 'Van', 8.2, 45000),
('BE2026020405', '333 Shopping Mall, Mandalay', '444 Residential Area, Yangon', 3500, 'returned', 'Ko Thura Min', 'Motorcycle', 3.1, 18000)
ON CONFLICT (tracking_number) DO NOTHING;

-- Insert sample merchants
INSERT INTO public.merchants_be (business_name, business_type, contact_person, phone, email, address, city, status, total_orders, total_revenue, credit_limit, current_balance) VALUES
('Golden Shop Myanmar', 'Electronics', 'Mg Thant Zin', '+95-9-123456789', 'contact@goldenshop.mm', '123 Merchant Street, Downtown', 'Yangon', 'active', 150, 2500000, 500000, 125000),
('Tech Solutions Ltd', 'IT Services', 'Ma Aye Thant', '+95-9-987654321', 'info@techsolutions.mm', '456 Business Avenue, Central', 'Mandalay', 'active', 89, 1800000, 300000, 75000),
('Fashion World', 'Clothing', 'Ko Min Thant', '+95-9-555666777', 'sales@fashionworld.mm', '789 Style Street, Fashion District', 'Yangon', 'active', 203, 3200000, 800000, 200000),
('Food Paradise', 'Restaurant', 'Ma Khin Swe', '+95-9-111333555', 'orders@foodparadise.mm', '321 Food Court, City Center', 'Mandalay', 'active', 67, 950000, 200000, 45000),
('Book Haven', 'Books & Stationery', 'Ko Zaw Win', '+95-9-777999111', 'info@bookhaven.mm', '654 Education Street, University Area', 'Yangon', 'pending', 12, 180000, 100000, 0)
ON CONFLICT DO NOTHING;

-- Insert sample deliverymen
INSERT INTO public.deliverymen_be (employee_id, full_name, phone, email, vehicle_type, vehicle_number, employment_status, zone_assignment, total_deliveries, successful_deliveries, failed_deliveries, performance_rating, total_earnings) VALUES
('DEL001', 'Ko Aung Kyaw Thant', '+95-9-111222333', 'aung.kyaw@britiumexpress.com', 'Motorcycle', '1A-2345', 'active', 'Yangon Central', 245, 230, 15, 4.2, 1250000),
('DEL002', 'Ko Thura Min Oo', '+95-9-444555666', 'thura.min@britiumexpress.com', 'Van', '2B-6789', 'active', 'Mandalay North', 189, 175, 14, 3.8, 980000),
('DEL003', 'Ma Aye Aye Mon', '+95-9-777888999', 'aye.aye@britiumexpress.com', 'Motorcycle', '3C-1234', 'active', 'Yangon East', 156, 148, 8, 4.5, 850000),
('DEL004', 'Ko Zaw Zaw Win', '+95-9-222444666', 'zaw.zaw@britiumexpress.com', 'Van', '4D-5678', 'active', 'Mandalay South', 134, 125, 9, 4.0, 720000),
('DEL005', 'Ma Thin Thin Aye', '+95-9-333555777', 'thin.thin@britiumexpress.com', 'Motorcycle', '5E-9012', 'inactive', 'Yangon West', 98, 89, 9, 3.5, 520000)
ON CONFLICT (employee_id) DO NOTHING;

-- Insert sample failed deliveries
INSERT INTO public.failed_deliveries (tracking_number, failure_reason, retry_count, notes, resolved) VALUES
('BE2026020404', 'Customer not available', 2, 'Tried calling multiple times, no response', false),
('BE2026020406', 'Wrong address provided', 1, 'Address incomplete, need customer clarification', false),
('BE2026020407', 'Access restricted area', 1, 'Security checkpoint denied entry', true),
('BE2026020408', 'Package damaged in transit', 0, 'Need to return to sender for replacement', false)
ON CONFLICT DO NOTHING;

-- Insert sample return shipments
INSERT INTO public.return_shipments (original_tracking_number, return_reason, return_status, refund_amount, notes) VALUES
('BE2026020405', 'Damaged package', 'completed', 15000, 'Full refund processed'),
('BE2026020409', 'Customer refused delivery', 'in_transit', 8500, 'Package being returned to sender'),
('BE2026020410', 'Wrong item delivered', 'initiated', 22000, 'Customer reported wrong product'),
('BE2026020411', 'Quality issues', 'completed', 12500, 'Merchant approved return and refund')
ON CONFLICT DO NOTHING;

-- Insert sample cash advances
INSERT INTO public.cash_advances (deliveryman_id, amount, advance_type, reason, status, remaining_balance) VALUES
((SELECT id FROM public.deliverymen_be WHERE employee_id = 'DEL001'), 50000, 'regular', 'Monthly salary advance', 'disbursed', 25000),
((SELECT id FROM public.deliverymen_be WHERE employee_id = 'DEL002'), 30000, 'emergency', 'Medical emergency', 'approved', 30000),
((SELECT id FROM public.deliverymen_be WHERE employee_id = 'DEL003'), 25000, 'regular', 'Festival advance', 'repaid', 0),
((SELECT id FROM public.deliverymen_be WHERE employee_id = 'DEL004'), 40000, 'salary_advance', 'Family emergency', 'disbursed', 35000)
ON CONFLICT DO NOTHING;

-- Insert sample broadcast messages
INSERT INTO public.broadcast_messages (message_title, message_content, message_type, target_audience, status, total_recipients, successful_deliveries) VALUES
('System Maintenance Notice', 'System will be under maintenance on Sunday 2AM-4AM. All services will be temporarily unavailable.', 'maintenance', 'all_users', 'sent', 1250, 1180),
('New Delivery Zones Added', 'We are excited to announce that we now deliver to 5 new townships in Yangon region.', 'general', 'merchants', 'sent', 450, 425),
('Performance Bonus Announcement', 'Top performing delivery staff will receive performance bonus this month. Keep up the great work!', 'general', 'deliverymen', 'sent', 85, 82),
('Holiday Schedule Update', 'Please note the updated delivery schedule for upcoming holidays.', 'general', 'all_users', 'draft', 0, 0),
('New COD Limits', 'COD limits have been updated. Please check the new limits in your merchant dashboard.', 'system', 'merchants', 'scheduled', 450, 0)
ON CONFLICT DO NOTHING;

-- Insert sample system settings
INSERT INTO public.system_settings_be (setting_category, setting_key, setting_value, setting_type, description, is_public) VALUES
('general', 'company_name', 'Britium Express', 'string', 'Company Name', true),
('general', 'default_currency', 'MMK', 'string', 'Default Currency', true),
('general', 'timezone', 'Asia/Yangon', 'string', 'System Timezone', false),
('delivery', 'default_delivery_fee', '2000', 'number', 'Default Delivery Fee in MMK', false),
('delivery', 'max_cod_amount', '500000', 'number', 'Maximum COD Amount', false),
('delivery', 'max_weight_kg', '50', 'number', 'Maximum Package Weight in KG', false),
('notification', 'email_enabled', 'true', 'boolean', 'Enable Email Notifications', false),
('notification', 'sms_enabled', 'true', 'boolean', 'Enable SMS Notifications', false),
('notification', 'push_enabled', 'true', 'boolean', 'Enable Push Notifications', false),
('security', 'session_timeout', '3600', 'number', 'Session Timeout in Seconds', false),
('security', 'max_login_attempts', '5', 'number', 'Maximum Login Attempts', false),
('backup', 'auto_backup_enabled', 'true', 'boolean', 'Enable Automatic Backups', false),
('backup', 'backup_retention_days', '30', 'number', 'Backup Retention Period in Days', false),
('api', 'rate_limit_per_minute', '100', 'number', 'API Rate Limit per Minute', false),
('api', 'webhook_timeout', '30', 'number', 'Webhook Timeout in Seconds', false)
ON CONFLICT (setting_category, setting_key) DO NOTHING;