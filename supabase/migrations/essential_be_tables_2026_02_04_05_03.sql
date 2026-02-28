-- Essential Tables for Britium Express BE App Pages
-- Created: 2026-02-04 05:03 UTC

-- Drop existing tables if they exist to avoid conflicts
DROP TABLE IF EXISTS public.delivery_ways CASCADE;
DROP TABLE IF EXISTS public.failed_deliveries CASCADE;
DROP TABLE IF EXISTS public.return_shipments CASCADE;
DROP TABLE IF EXISTS public.merchants CASCADE;
DROP TABLE IF EXISTS public.deliverymen CASCADE;
DROP TABLE IF EXISTS public.broadcast_messages CASCADE;
DROP TABLE IF EXISTS public.system_settings CASCADE;

-- Create profiles table if not exists
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT UNIQUE,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(50) NOT NULL DEFAULT 'customer',
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create branches table if not exists
CREATE TABLE IF NOT EXISTS public.branches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_code VARCHAR(20) UNIQUE NOT NULL,
    branch_name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Way Management Tables
CREATE TABLE public.delivery_ways (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tracking_number VARCHAR(50) UNIQUE NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    pickup_address TEXT NOT NULL,
    delivery_address TEXT NOT NULL,
    pickup_date TIMESTAMP WITH TIME ZONE,
    delivery_date TIMESTAMP WITH TIME ZONE,
    rider_name VARCHAR(100),
    vehicle_type VARCHAR(50),
    priority INTEGER DEFAULT 1,
    cod_amount DECIMAL(10,2) DEFAULT 0,
    delivery_fee DECIMAL(10,2) NOT NULL,
    weight DECIMAL(8,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.failed_deliveries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tracking_number VARCHAR(50) NOT NULL,
    failure_reason VARCHAR(100) NOT NULL,
    failure_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    retry_count INTEGER DEFAULT 0,
    next_retry_date TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    resolved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.return_shipments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    original_tracking_number VARCHAR(50) NOT NULL,
    return_reason VARCHAR(100) NOT NULL,
    return_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    return_status VARCHAR(20) DEFAULT 'initiated',
    refund_amount DECIMAL(10,2),
    refund_status VARCHAR(20) DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Merchant Management Tables
CREATE TABLE public.merchants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_name VARCHAR(200) NOT NULL,
    business_type VARCHAR(100),
    contact_person VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'active',
    credit_limit DECIMAL(12,2) DEFAULT 0,
    current_balance DECIMAL(12,2) DEFAULT 0,
    total_orders INTEGER DEFAULT 0,
    total_revenue DECIMAL(12,2) DEFAULT 0,
    registration_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.merchant_bank_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID NOT NULL,
    bank_name VARCHAR(100) NOT NULL,
    account_number VARCHAR(50) NOT NULL,
    account_holder_name VARCHAR(100) NOT NULL,
    account_type VARCHAR(50) DEFAULT 'savings',
    is_primary BOOLEAN DEFAULT FALSE,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Deliveryman Management Tables
CREATE TABLE public.deliverymen (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    employee_id VARCHAR(50) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    address TEXT,
    city VARCHAR(100),
    hire_date DATE DEFAULT CURRENT_DATE,
    employment_status VARCHAR(20) DEFAULT 'active',
    vehicle_type VARCHAR(50),
    vehicle_number VARCHAR(50),
    zone_assignment VARCHAR(100),
    total_deliveries INTEGER DEFAULT 0,
    successful_deliveries INTEGER DEFAULT 0,
    failed_deliveries INTEGER DEFAULT 0,
    total_earnings DECIMAL(12,2) DEFAULT 0,
    current_cash_advance DECIMAL(10,2) DEFAULT 0,
    performance_rating DECIMAL(3,2) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.cash_advances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    deliveryman_id UUID NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    advance_type VARCHAR(20) DEFAULT 'regular',
    reason TEXT,
    status VARCHAR(20) DEFAULT 'pending',
    disbursement_date TIMESTAMP WITH TIME ZONE,
    remaining_balance DECIMAL(10,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Accounting Tables
CREATE TABLE public.chart_of_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    account_code VARCHAR(20) UNIQUE NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    account_type VARCHAR(50) NOT NULL,
    parent_account_code VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.financial_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_number VARCHAR(50) UNIQUE NOT NULL,
    transaction_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    transaction_type VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'MMK',
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Reporting Tables
CREATE TABLE public.report_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    template_name VARCHAR(100) NOT NULL,
    report_type VARCHAR(50) NOT NULL,
    template_config JSONB NOT NULL,
    is_system_template BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Broadcast Messages Tables
CREATE TABLE public.broadcast_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_title VARCHAR(200) NOT NULL,
    message_content TEXT NOT NULL,
    message_type VARCHAR(50) DEFAULT 'general',
    target_audience VARCHAR(50) NOT NULL,
    delivery_method VARCHAR(50) DEFAULT 'in_app',
    scheduled_send_time TIMESTAMP WITH TIME ZONE,
    sent_time TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'draft',
    total_recipients INTEGER DEFAULT 0,
    successful_deliveries INTEGER DEFAULT 0,
    failed_deliveries INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- System Settings Tables
CREATE TABLE public.system_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    setting_category VARCHAR(50) NOT NULL,
    setting_key VARCHAR(100) NOT NULL,
    setting_value TEXT,
    setting_type VARCHAR(20) DEFAULT 'string',
    description TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(setting_category, setting_key)
);

-- Create indexes for performance
CREATE INDEX idx_delivery_ways_status ON public.delivery_ways(status);
CREATE INDEX idx_delivery_ways_tracking ON public.delivery_ways(tracking_number);
CREATE INDEX idx_merchants_status ON public.merchants(status);
CREATE INDEX idx_deliverymen_status ON public.deliverymen(employment_status);
CREATE INDEX idx_broadcast_messages_status ON public.broadcast_messages(status);

-- Insert sample data
INSERT INTO public.profiles (user_id, email, full_name, role, status) VALUES
('admin-001', 'admin@britiumexpress.com', 'System Administrator', 'super_admin', 'active'),
('admin-002', 'manager@britiumexpress.com', 'Branch Manager', 'admin', 'active')
ON CONFLICT (email) DO NOTHING;

INSERT INTO public.branches (branch_code, branch_name, address, city, phone) VALUES
('YGN001', 'Yangon Main Branch', 'No. 123, Main Street, Downtown', 'Yangon', '+95-1-234567'),
('MDY001', 'Mandalay Branch', 'No. 456, Central Road, Mandalay', 'Mandalay', '+95-2-345678')
ON CONFLICT (branch_code) DO NOTHING;

-- Sample delivery ways
INSERT INTO public.delivery_ways (tracking_number, pickup_address, delivery_address, delivery_fee, status, rider_name, vehicle_type) VALUES
('BE2026020401', '123 Sender Street, Yangon', '456 Receiver Road, Mandalay', 5000, 'in_transit', 'Ko Aung', 'Motorcycle'),
('BE2026020402', '789 Shop Avenue, Yangon', '321 Customer Lane, Yangon', 2000, 'delivered', 'Ko Thura', 'Van'),
('BE2026020403', '555 Business Plaza, Mandalay', '777 Home Street, Yangon', 4500, 'pending', 'Ma Aye', 'Motorcycle');

-- Sample merchants
INSERT INTO public.merchants (business_name, contact_person, phone, email, address, city, status, total_orders, total_revenue) VALUES
('Golden Shop Myanmar', 'Mg Thant', '+95-9-123456789', 'contact@goldenshop.mm', '123 Merchant Street', 'Yangon', 'active', 150, 2500000),
('Tech Solutions Ltd', 'Ma Aye', '+95-9-987654321', 'info@techsolutions.mm', '456 Business Avenue', 'Mandalay', 'active', 89, 1800000),
('Fashion World', 'Ko Min', '+95-9-555666777', 'sales@fashionworld.mm', '789 Style Street', 'Yangon', 'active', 203, 3200000);

-- Sample deliverymen
INSERT INTO public.deliverymen (employee_id, full_name, phone, email, vehicle_type, vehicle_number, employment_status, total_deliveries, successful_deliveries, performance_rating) VALUES
('DEL001', 'Ko Aung Kyaw', '+95-9-111222333', 'aung@britiumexpress.com', 'Motorcycle', '1A-2345', 'active', 245, 230, 4.2),
('DEL002', 'Ko Thura Min', '+95-9-444555666', 'thura@britiumexpress.com', 'Van', '2B-6789', 'active', 189, 175, 3.8),
('DEL003', 'Ma Aye Aye', '+95-9-777888999', 'aye@britiumexpress.com', 'Motorcycle', '3C-1234', 'active', 156, 148, 4.5);

-- Sample failed deliveries
INSERT INTO public.failed_deliveries (tracking_number, failure_reason, retry_count, notes) VALUES
('BE2026020404', 'Customer not available', 2, 'Tried calling multiple times'),
('BE2026020405', 'Wrong address', 1, 'Address incomplete, need clarification');

-- Sample return shipments
INSERT INTO public.return_shipments (original_tracking_number, return_reason, return_status, refund_amount) VALUES
('BE2026020406', 'Damaged package', 'completed', 15000),
('BE2026020407', 'Customer refused', 'in_transit', 8500);

-- Chart of accounts
INSERT INTO public.chart_of_accounts (account_code, account_name, account_type, description) VALUES
('1000', 'Assets', 'asset', 'Main Assets Account'),
('1100', 'Cash and Bank', 'asset', 'Cash and Bank Accounts'),
('1200', 'Accounts Receivable', 'asset', 'Customer Receivables'),
('2000', 'Liabilities', 'liability', 'Main Liabilities Account'),
('2100', 'Accounts Payable', 'liability', 'Supplier Payables'),
('3000', 'Equity', 'equity', 'Owner Equity'),
('4000', 'Revenue', 'revenue', 'Main Revenue Account'),
('4100', 'Delivery Revenue', 'revenue', 'Revenue from Deliveries'),
('5000', 'Expenses', 'expense', 'Main Expense Account'),
('5100', 'Operating Expenses', 'expense', 'Operating Expenses')
ON CONFLICT (account_code) DO NOTHING;

-- System settings
INSERT INTO public.system_settings (setting_category, setting_key, setting_value, setting_type, description, is_public) VALUES
('general', 'company_name', 'Britium Express', 'string', 'Company Name', true),
('general', 'default_currency', 'MMK', 'string', 'Default Currency', true),
('delivery', 'default_delivery_fee', '2000', 'number', 'Default Delivery Fee in MMK', false),
('delivery', 'max_cod_amount', '500000', 'number', 'Maximum COD Amount', false),
('notification', 'email_enabled', 'true', 'boolean', 'Enable Email Notifications', false),
('notification', 'sms_enabled', 'true', 'boolean', 'Enable SMS Notifications', false)
ON CONFLICT (setting_category, setting_key) DO NOTHING;

-- Sample broadcast messages
INSERT INTO public.broadcast_messages (message_title, message_content, message_type, target_audience, status, total_recipients) VALUES
('System Maintenance Notice', 'System will be under maintenance on Sunday 2AM-4AM', 'maintenance', 'all_users', 'sent', 1250),
('New Delivery Zones Added', 'We now deliver to 5 new townships in Yangon', 'general', 'merchants', 'sent', 450),
('Performance Bonus Announcement', 'Top performers will receive bonus this month', 'general', 'deliverymen', 'draft', 0);

-- Report templates
INSERT INTO public.report_templates (template_name, report_type, template_config, is_system_template) VALUES
('Daily Delivery Report', 'delivery', '{"columns": ["tracking_number", "status", "delivery_date", "rider_name"], "filters": ["date_range", "status"]}', true),
('Monthly Merchant Report', 'merchant', '{"columns": ["business_name", "total_orders", "total_revenue"], "filters": ["date_range", "status"]}', true),
('Financial Summary', 'financial', '{"columns": ["account_name", "debit_total", "credit_total"], "filters": ["date_range", "account_type"]}', true)
ON CONFLICT DO NOTHING;