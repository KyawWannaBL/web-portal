-- Comprehensive Britium Express Database Schema
-- Created: 2026-02-04 05:03 UTC
-- Purpose: Support all BE_app_pages functionality

-- Way Management Tables
CREATE TABLE IF NOT EXISTS public.delivery_ways (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tracking_number VARCHAR(50) UNIQUE NOT NULL,
    shipment_id UUID REFERENCES public.shipments(id),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'in_transit', 'delivered', 'failed', 'returned')),
    pickup_address TEXT NOT NULL,
    delivery_address TEXT NOT NULL,
    pickup_date TIMESTAMP WITH TIME ZONE,
    delivery_date TIMESTAMP WITH TIME ZONE,
    estimated_delivery TIMESTAMP WITH TIME ZONE,
    rider_id UUID REFERENCES public.profiles(id),
    vehicle_type VARCHAR(50),
    route_id UUID,
    priority INTEGER DEFAULT 1 CHECK (priority BETWEEN 1 AND 5),
    special_instructions TEXT,
    cod_amount DECIMAL(10,2) DEFAULT 0,
    delivery_fee DECIMAL(10,2) NOT NULL,
    weight DECIMAL(8,2),
    dimensions JSONB, -- {length, width, height}
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.failed_deliveries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    delivery_way_id UUID REFERENCES public.delivery_ways(id),
    failure_reason VARCHAR(100) NOT NULL,
    failure_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    retry_count INTEGER DEFAULT 0,
    next_retry_date TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    resolved BOOLEAN DEFAULT FALSE,
    resolved_date TIMESTAMP WITH TIME ZONE,
    resolved_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.return_shipments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    original_shipment_id UUID REFERENCES public.shipments(id),
    return_reason VARCHAR(100) NOT NULL,
    return_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    return_status VARCHAR(20) DEFAULT 'initiated' CHECK (return_status IN ('initiated', 'in_transit', 'completed', 'cancelled')),
    refund_amount DECIMAL(10,2),
    refund_status VARCHAR(20) DEFAULT 'pending' CHECK (refund_status IN ('pending', 'processed', 'cancelled')),
    processed_by UUID REFERENCES public.profiles(id),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.parcel_operations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operation_type VARCHAR(20) NOT NULL CHECK (operation_type IN ('parcel_in', 'parcel_out')),
    shipment_id UUID REFERENCES public.shipments(id),
    tracking_number VARCHAR(50) NOT NULL,
    operator_id UUID REFERENCES public.profiles(id),
    operation_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    location VARCHAR(100) NOT NULL,
    weight_recorded DECIMAL(8,2),
    condition_notes TEXT,
    scan_data JSONB, -- barcode/QR scan information
    manifest_id UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.transit_routes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    route_name VARCHAR(100) NOT NULL,
    origin_branch_id UUID REFERENCES public.branches(id),
    destination_branch_id UUID REFERENCES public.branches(id),
    vehicle_id UUID,
    driver_id UUID REFERENCES public.profiles(id),
    departure_time TIMESTAMP WITH TIME ZONE,
    arrival_time TIMESTAMP WITH TIME ZONE,
    estimated_duration INTERVAL,
    route_status VARCHAR(20) DEFAULT 'planned' CHECK (route_status IN ('planned', 'in_progress', 'completed', 'cancelled')),
    waypoints JSONB, -- GPS coordinates array
    distance_km DECIMAL(8,2),
    fuel_cost DECIMAL(10,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Merchant Management Tables
CREATE TABLE IF NOT EXISTS public.merchants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.profiles(id),
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
    payment_terms INTEGER DEFAULT 30, -- days
    commission_rate DECIMAL(5,2) DEFAULT 0, -- percentage
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
    merchant_id UUID REFERENCES public.merchants(id),
    bank_name VARCHAR(100) NOT NULL,
    account_number VARCHAR(50) NOT NULL,
    account_holder_name VARCHAR(100) NOT NULL,
    account_type VARCHAR(50) DEFAULT 'savings',
    branch_name VARCHAR(100),
    swift_code VARCHAR(20),
    is_primary BOOLEAN DEFAULT FALSE,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.merchant_receipts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID REFERENCES public.merchants(id),
    receipt_number VARCHAR(50) UNIQUE NOT NULL,
    receipt_type VARCHAR(50) NOT NULL CHECK (receipt_type IN ('payment', 'refund', 'commission', 'adjustment')),
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'MMK',
    payment_method VARCHAR(50),
    reference_number VARCHAR(100),
    description TEXT,
    receipt_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    due_date TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'overdue', 'cancelled')),
    created_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.invoice_schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID REFERENCES public.merchants(id),
    schedule_name VARCHAR(100) NOT NULL,
    frequency VARCHAR(20) NOT NULL CHECK (frequency IN ('daily', 'weekly', 'monthly', 'quarterly')),
    day_of_week INTEGER, -- 1-7 for weekly
    day_of_month INTEGER, -- 1-31 for monthly
    auto_generate BOOLEAN DEFAULT TRUE,
    email_notification BOOLEAN DEFAULT TRUE,
    sms_notification BOOLEAN DEFAULT FALSE,
    last_generated TIMESTAMP WITH TIME ZONE,
    next_generation TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'paused')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Deliveryman Management Tables
CREATE TABLE IF NOT EXISTS public.deliverymen (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.profiles(id),
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

CREATE TABLE IF NOT EXISTS public.cash_advances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    deliveryman_id UUID REFERENCES public.deliverymen(id),
    amount DECIMAL(10,2) NOT NULL,
    advance_type VARCHAR(20) DEFAULT 'regular' CHECK (advance_type IN ('regular', 'emergency', 'salary_advance')),
    reason TEXT,
    approved_by UUID REFERENCES public.profiles(id),
    approval_date TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'disbursed', 'repaid')),
    disbursement_date TIMESTAMP WITH TIME ZONE,
    repayment_schedule JSONB, -- installment details
    remaining_balance DECIMAL(10,2),
    interest_rate DECIMAL(5,2) DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Accounting Tables
CREATE TABLE IF NOT EXISTS public.chart_of_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    account_code VARCHAR(20) UNIQUE NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    account_type VARCHAR(50) NOT NULL CHECK (account_type IN ('asset', 'liability', 'equity', 'revenue', 'expense')),
    parent_account_id UUID REFERENCES public.chart_of_accounts(id),
    is_active BOOLEAN DEFAULT TRUE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.financial_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_number VARCHAR(50) UNIQUE NOT NULL,
    transaction_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    transaction_type VARCHAR(50) NOT NULL CHECK (transaction_type IN ('journal', 'cash', 'bank', 'adjustment')),
    reference_number VARCHAR(100),
    description TEXT NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'MMK',
    branch_id UUID REFERENCES public.branches(id),
    created_by UUID REFERENCES public.profiles(id),
    approved_by UUID REFERENCES public.profiles(id),
    approval_date TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'posted')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.transaction_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_id UUID REFERENCES public.financial_transactions(id),
    account_id UUID REFERENCES public.chart_of_accounts(id),
    debit_amount DECIMAL(12,2) DEFAULT 0,
    credit_amount DECIMAL(12,2) DEFAULT 0,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Reporting Tables
CREATE TABLE IF NOT EXISTS public.report_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    template_name VARCHAR(100) NOT NULL,
    report_type VARCHAR(50) NOT NULL CHECK (report_type IN ('delivery', 'merchant', 'financial', 'performance', 'custom')),
    template_config JSONB NOT NULL, -- report parameters and structure
    is_system_template BOOLEAN DEFAULT FALSE,
    created_by UUID REFERENCES public.profiles(id),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.generated_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    report_name VARCHAR(100) NOT NULL,
    report_type VARCHAR(50) NOT NULL,
    template_id UUID REFERENCES public.report_templates(id),
    parameters JSONB, -- report generation parameters
    file_path VARCHAR(500),
    file_format VARCHAR(20) DEFAULT 'pdf' CHECK (file_format IN ('pdf', 'excel', 'csv')),
    generation_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    generated_by UUID REFERENCES public.profiles(id),
    status VARCHAR(20) DEFAULT 'generating' CHECK (status IN ('generating', 'completed', 'failed')),
    file_size BIGINT,
    download_count INTEGER DEFAULT 0,
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Broadcast Messages Tables
CREATE TABLE IF NOT EXISTS public.broadcast_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_title VARCHAR(200) NOT NULL,
    message_content TEXT NOT NULL,
    message_type VARCHAR(50) DEFAULT 'general' CHECK (message_type IN ('general', 'urgent', 'maintenance', 'promotion', 'system')),
    target_audience VARCHAR(50) NOT NULL CHECK (target_audience IN ('all_users', 'merchants', 'deliverymen', 'customers', 'admins', 'custom')),
    target_user_ids UUID[], -- for custom targeting
    delivery_method VARCHAR(50) DEFAULT 'in_app' CHECK (delivery_method IN ('in_app', 'email', 'sms', 'push', 'all')),
    scheduled_send_time TIMESTAMP WITH TIME ZONE,
    sent_time TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'scheduled', 'sending', 'sent', 'failed', 'cancelled')),
    total_recipients INTEGER DEFAULT 0,
    successful_deliveries INTEGER DEFAULT 0,
    failed_deliveries INTEGER DEFAULT 0,
    created_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.message_recipients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_id UUID REFERENCES public.broadcast_messages(id),
    recipient_id UUID REFERENCES public.profiles(id),
    delivery_status VARCHAR(20) DEFAULT 'pending' CHECK (delivery_status IN ('pending', 'sent', 'delivered', 'read', 'failed')),
    sent_time TIMESTAMP WITH TIME ZONE,
    delivered_time TIMESTAMP WITH TIME ZONE,
    read_time TIMESTAMP WITH TIME ZONE,
    error_message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
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
    updated_by UUID REFERENCES public.profiles(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(setting_category, setting_key)
);

-- Branches Table (if not exists)
CREATE TABLE IF NOT EXISTS public.branches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    branch_code VARCHAR(20) UNIQUE NOT NULL,
    branch_name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    manager_id UUID REFERENCES public.profiles(id),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'closed')),
    opening_date DATE DEFAULT CURRENT_DATE,
    coverage_areas TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_delivery_ways_status ON public.delivery_ways(status);
CREATE INDEX IF NOT EXISTS idx_delivery_ways_rider ON public.delivery_ways(rider_id);
CREATE INDEX IF NOT EXISTS idx_delivery_ways_tracking ON public.delivery_ways(tracking_number);
CREATE INDEX IF NOT EXISTS idx_merchants_status ON public.merchants(status);
CREATE INDEX IF NOT EXISTS idx_merchants_user ON public.merchants(user_id);
CREATE INDEX IF NOT EXISTS idx_deliverymen_status ON public.deliverymen(employment_status);
CREATE INDEX IF NOT EXISTS idx_deliverymen_user ON public.deliverymen(user_id);
CREATE INDEX IF NOT EXISTS idx_financial_transactions_date ON public.financial_transactions(transaction_date);
CREATE INDEX IF NOT EXISTS idx_financial_transactions_branch ON public.financial_transactions(branch_id);
CREATE INDEX IF NOT EXISTS idx_broadcast_messages_status ON public.broadcast_messages(status);
CREATE INDEX IF NOT EXISTS idx_broadcast_messages_target ON public.broadcast_messages(target_audience);

-- Insert default chart of accounts
INSERT INTO public.chart_of_accounts (account_code, account_name, account_type, description) VALUES
('1000', 'Assets', 'asset', 'Main Assets Account'),
('1100', 'Current Assets', 'asset', 'Current Assets'),
('1110', 'Cash and Bank', 'asset', 'Cash and Bank Accounts'),
('1120', 'Accounts Receivable', 'asset', 'Customer Receivables'),
('1130', 'Inventory', 'asset', 'Inventory Assets'),
('2000', 'Liabilities', 'liability', 'Main Liabilities Account'),
('2100', 'Current Liabilities', 'liability', 'Current Liabilities'),
('2110', 'Accounts Payable', 'liability', 'Supplier Payables'),
('2120', 'Accrued Expenses', 'liability', 'Accrued Expenses'),
('3000', 'Equity', 'equity', 'Owner Equity'),
('4000', 'Revenue', 'revenue', 'Main Revenue Account'),
('4100', 'Delivery Revenue', 'revenue', 'Revenue from Deliveries'),
('4200', 'Commission Revenue', 'revenue', 'Commission from Merchants'),
('5000', 'Expenses', 'expense', 'Main Expense Account'),
('5100', 'Operating Expenses', 'expense', 'Operating Expenses'),
('5110', 'Fuel Expenses', 'expense', 'Vehicle Fuel Costs'),
('5120', 'Salary Expenses', 'expense', 'Employee Salaries'),
('5130', 'Maintenance Expenses', 'expense', 'Vehicle and Equipment Maintenance')
ON CONFLICT (account_code) DO NOTHING;

-- Insert default system settings
INSERT INTO public.system_settings (setting_category, setting_key, setting_value, setting_type, description, is_public) VALUES
('general', 'company_name', 'Britium Express', 'string', 'Company Name', true),
('general', 'default_currency', 'MMK', 'string', 'Default Currency', true),
('general', 'timezone', 'Asia/Yangon', 'string', 'System Timezone', false),
('delivery', 'default_delivery_fee', '2000', 'number', 'Default Delivery Fee in MMK', false),
('delivery', 'max_cod_amount', '500000', 'number', 'Maximum COD Amount', false),
('notification', 'email_enabled', 'true', 'boolean', 'Enable Email Notifications', false),
('notification', 'sms_enabled', 'true', 'boolean', 'Enable SMS Notifications', false),
('security', 'session_timeout', '3600', 'number', 'Session Timeout in Seconds', false),
('backup', 'auto_backup_enabled', 'true', 'boolean', 'Enable Automatic Backups', false),
('backup', 'backup_retention_days', '30', 'number', 'Backup Retention Period in Days', false)
ON CONFLICT (setting_category, setting_key) DO NOTHING;

-- Insert default report templates
INSERT INTO public.report_templates (template_name, report_type, template_config, is_system_template) VALUES
('Daily Delivery Report', 'delivery', '{"columns": ["tracking_number", "status", "delivery_date", "rider_name"], "filters": ["date_range", "status"], "groupBy": "status"}', true),
('Monthly Merchant Report', 'merchant', '{"columns": ["merchant_name", "total_orders", "total_revenue", "commission"], "filters": ["date_range", "merchant_status"], "groupBy": "merchant_name"}', true),
('Financial Summary Report', 'financial', '{"columns": ["account_name", "debit_total", "credit_total", "balance"], "filters": ["date_range", "account_type"], "groupBy": "account_type"}', true),
('Performance Dashboard', 'performance', '{"metrics": ["delivery_success_rate", "average_delivery_time", "customer_satisfaction"], "charts": ["line", "bar", "pie"], "period": "monthly"}', true)
ON CONFLICT DO NOTHING;