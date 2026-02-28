-- Basic Tables for Britium Express (No FK constraints initially)
-- Created: 2026-02-04 05:03 UTC

-- User profiles table
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT UNIQUE, -- Firebase Auth UID as text
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(50) NOT NULL DEFAULT 'customer' CHECK (role IN ('super_admin', 'admin', 'manager', 'sub_station_manager', 'supervisor', 'warehouse', 'rider', 'merchant', 'vendor', 'accountant', 'customer')),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended', 'pending')),
    avatar_url TEXT,
    branch_id UUID,
    merchant_id UUID,
    last_login TIMESTAMP WITH TIME ZONE,
    email_verified BOOLEAN DEFAULT FALSE,
    phone_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Branches table
CREATE TABLE IF NOT EXISTS public.branches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_code VARCHAR(20) UNIQUE NOT NULL,
    branch_name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    manager_id UUID,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'closed')),
    opening_date DATE DEFAULT CURRENT_DATE,
    coverage_areas TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Shipments table
CREATE TABLE IF NOT EXISTS public.shipments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tracking_number VARCHAR(50) UNIQUE NOT NULL,
    sender_name VARCHAR(100) NOT NULL,
    sender_phone VARCHAR(20) NOT NULL,
    sender_address TEXT NOT NULL,
    sender_city VARCHAR(100) NOT NULL,
    receiver_name VARCHAR(100) NOT NULL,
    receiver_phone VARCHAR(20) NOT NULL,
    receiver_address TEXT NOT NULL,
    receiver_city VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'picked_up', 'in_transit', 'arrived_at_warehouse', 'out_for_delivery', 'delivered', 'failed', 'cancelled', 'returned')),
    weight DECIMAL(8,2),
    dimensions JSONB,
    price DECIMAL(10,2) NOT NULL,
    cod_amount DECIMAL(10,2) DEFAULT 0,
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded')),
    service_type VARCHAR(50) DEFAULT 'standard',
    priority INTEGER DEFAULT 1 CHECK (priority BETWEEN 1 AND 5),
    special_instructions TEXT,
    branch_id UUID,
    rider_id UUID,
    merchant_id UUID,
    created_by UUID,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Way Management Tables
CREATE TABLE IF NOT EXISTS public.delivery_ways (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tracking_number VARCHAR(50) UNIQUE NOT NULL,
    shipment_id UUID,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'in_transit', 'delivered', 'failed', 'returned')),
    pickup_address TEXT NOT NULL,
    delivery_address TEXT NOT NULL,
    pickup_date TIMESTAMP WITH TIME ZONE,
    delivery_date TIMESTAMP WITH TIME ZONE,
    estimated_delivery TIMESTAMP WITH TIME ZONE,
    rider_id UUID,
    vehicle_type VARCHAR(50),
    route_id UUID,
    priority INTEGER DEFAULT 1 CHECK (priority BETWEEN 1 AND 5),
    special_instructions TEXT,
    cod_amount DECIMAL(10,2) DEFAULT 0,
    delivery_fee DECIMAL(10,2) NOT NULL,
    weight DECIMAL(8,2),
    dimensions JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.failed_deliveries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    delivery_way_id UUID,
    failure_reason VARCHAR(100) NOT NULL,
    failure_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    retry_count INTEGER DEFAULT 0,
    next_retry_date TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    resolved BOOLEAN DEFAULT FALSE,
    resolved_date TIMESTAMP WITH TIME ZONE,
    resolved_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.return_shipments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    original_shipment_id UUID,
    return_reason VARCHAR(100) NOT NULL,
    return_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    return_status VARCHAR(20) DEFAULT 'initiated' CHECK (return_status IN ('initiated', 'in_transit', 'completed', 'cancelled')),
    refund_amount DECIMAL(10,2),
    refund_status VARCHAR(20) DEFAULT 'pending' CHECK (refund_status IN ('pending', 'processed', 'cancelled')),
    processed_by UUID,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Merchant Management Tables
CREATE TABLE IF NOT EXISTS public.merchants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID,
    business_name VARCHAR(200) NOT NULL,
    business_type VARCHAR(100),
    registration_number VARCHAR(100),
    tax_id VARCHAR(100),
    contact_person VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    country VARCHAR(100) DEFAULT 'Myanmar',
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended', 'pending')),
    credit_limit DECIMAL(12,2) DEFAULT 0,
    current_balance DECIMAL(12,2) DEFAULT 0,
    payment_terms INTEGER DEFAULT 30,
    commission_rate DECIMAL(5,2) DEFAULT 0,
    total_orders INTEGER DEFAULT 0,
    total_revenue DECIMAL(12,2) DEFAULT 0,
    registration_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_order_date TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Deliveryman Management Tables
CREATE TABLE IF NOT EXISTS public.deliverymen (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID,
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
    license_expiry DATE,
    zone_id UUID,
    base_salary DECIMAL(10,2) DEFAULT 0,
    commission_rate DECIMAL(5,2) DEFAULT 0,
    total_deliveries INTEGER DEFAULT 0,
    successful_deliveries INTEGER DEFAULT 0,
    failed_deliveries INTEGER DEFAULT 0,
    total_earnings DECIMAL(12,2) DEFAULT 0,
    current_cash_advance DECIMAL(10,2) DEFAULT 0,
    max_cash_advance DECIMAL(10,2) DEFAULT 50000,
    performance_rating DECIMAL(3,2) DEFAULT 0,
    last_active TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Broadcast Messages Tables
CREATE TABLE IF NOT EXISTS public.broadcast_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_title VARCHAR(200) NOT NULL,
    message_content TEXT NOT NULL,
    message_type VARCHAR(50) DEFAULT 'general' CHECK (message_type IN ('general', 'urgent', 'maintenance', 'promotion', 'system')),
    target_audience VARCHAR(50) NOT NULL CHECK (target_audience IN ('all_users', 'merchants', 'deliverymen', 'customers', 'admins', 'custom')),
    target_user_ids UUID[],
    delivery_method VARCHAR(50) DEFAULT 'in_app' CHECK (delivery_method IN ('in_app', 'email', 'sms', 'push', 'all')),
    scheduled_send_time TIMESTAMP WITH TIME ZONE,
    sent_time TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'scheduled', 'sending', 'sent', 'failed', 'cancelled')),
    total_recipients INTEGER DEFAULT 0,
    successful_deliveries INTEGER DEFAULT 0,
    failed_deliveries INTEGER DEFAULT 0,
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- System Settings Tables
CREATE TABLE IF NOT EXISTS public.system_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    setting_category VARCHAR(50) NOT NULL,
    setting_key VARCHAR(100) NOT NULL,
    setting_value TEXT,
    setting_type VARCHAR(20) DEFAULT 'string' CHECK (setting_type IN ('string', 'number', 'boolean', 'json')),
    description TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    updated_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(setting_category, setting_key)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email);
CREATE INDEX IF NOT EXISTS idx_profiles_role ON public.profiles(role);
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON public.profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_shipments_tracking ON public.shipments(tracking_number);
CREATE INDEX IF NOT EXISTS idx_delivery_ways_status ON public.delivery_ways(status);
CREATE INDEX IF NOT EXISTS idx_merchants_status ON public.merchants(status);
CREATE INDEX IF NOT EXISTS idx_deliverymen_status ON public.deliverymen(employment_status);
CREATE INDEX IF NOT EXISTS idx_broadcast_messages_status ON public.broadcast_messages(status);

-- Insert sample data
INSERT INTO public.profiles (user_id, email, full_name, role, status, email_verified) VALUES
('admin-001', 'admin@britiumexpress.com', 'System Administrator', 'super_admin', 'active', true),
('admin-002', 'manager@britiumexpress.com', 'Branch Manager', 'admin', 'active', true)
ON CONFLICT (email) DO NOTHING;

INSERT INTO public.branches (branch_code, branch_name, address, city, phone, email) VALUES
('YGN001', 'Yangon Main Branch', 'No. 123, Main Street, Downtown', 'Yangon', '+95-1-234567', 'yangon@britiumexpress.com'),
('MDY001', 'Mandalay Branch', 'No. 456, Central Road, Mandalay', 'Mandalay', '+95-2-345678', 'mandalay@britiumexpress.com')
ON CONFLICT (branch_code) DO NOTHING;

INSERT INTO public.system_settings (setting_category, setting_key, setting_value, setting_type, description, is_public) VALUES
('general', 'company_name', 'Britium Express', 'string', 'Company Name', true),
('general', 'default_currency', 'MMK', 'string', 'Default Currency', true),
('delivery', 'default_delivery_fee', '2000', 'number', 'Default Delivery Fee in MMK', false),
('notification', 'email_enabled', 'true', 'boolean', 'Enable Email Notifications', false)
ON CONFLICT (setting_category, setting_key) DO NOTHING;

-- Sample merchants
INSERT INTO public.merchants (business_name, contact_person, phone, email, address, city, status) VALUES
('Golden Shop Myanmar', 'Mg Thant', '+95-9-123456789', 'contact@goldenshop.mm', '123 Merchant Street', 'Yangon', 'active'),
('Tech Solutions Ltd', 'Ma Aye', '+95-9-987654321', 'info@techsolutions.mm', '456 Business Avenue', 'Mandalay', 'active')
ON CONFLICT DO NOTHING;

-- Sample deliverymen
INSERT INTO public.deliverymen (employee_id, full_name, phone, email, vehicle_type, vehicle_number, employment_status) VALUES
('DEL001', 'Ko Aung', '+95-9-111222333', 'aung@britiumexpress.com', 'Motorcycle', '1A-2345', 'active'),
('DEL002', 'Ko Thura', '+95-9-444555666', 'thura@britiumexpress.com', 'Van', '2B-6789', 'active')
ON CONFLICT (employee_id) DO NOTHING;