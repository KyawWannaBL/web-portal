-- Create comprehensive admin system with role-based access control
-- Current time: 2026_02_04_16_00

-- Create admin users table with 10-tier hierarchy
CREATE TABLE IF NOT EXISTS public.admin_users_2026_02_04_16_00 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN (
        'super_admin', 'admin', 'manager', 'supervisor', 
        'warehouse_staff', 'rider', 'accountant', 'marketer', 
        'customer_service', 'merchant'
    )),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'pending')),
    hub_assignment VARCHAR(100) DEFAULT 'Global',
    phone VARCHAR(20),
    must_change_password BOOLEAN DEFAULT true,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES public.admin_users_2026_02_04_16_00(id)
);

-- Create bulk upload tracking table
CREATE TABLE IF NOT EXISTS public.bulk_uploads_2026_02_04_16_00 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    total_rows INTEGER NOT NULL,
    valid_rows INTEGER NOT NULL,
    error_rows INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'processing' CHECK (status IN ('processing', 'completed', 'failed')),
    uploaded_by UUID REFERENCES public.admin_users_2026_02_04_16_00(id),
    upload_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    processed_date TIMESTAMP WITH TIME ZONE,
    error_details JSONB
);

-- Create bulk upload items table
CREATE TABLE IF NOT EXISTS public.bulk_upload_items_2026_02_04_16_00 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    upload_id UUID REFERENCES public.bulk_uploads_2026_02_04_16_00(id) ON DELETE CASCADE,
    row_number INTEGER NOT NULL,
    receiver_name VARCHAR(255),
    receiver_phone VARCHAR(20),
    receiver_address TEXT,
    sender_name VARCHAR(255),
    sender_phone VARCHAR(20),
    weight DECIMAL(10,2),
    cod_amount DECIMAL(12,2),
    special_instructions TEXT,
    validation_status VARCHAR(20) DEFAULT 'pending' CHECK (validation_status IN ('valid', 'error', 'pending')),
    validation_errors TEXT[],
    created_shipment_id UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create tariff rates table
CREATE TABLE IF NOT EXISTS public.tariff_rates_2026_02_04_16_00 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    country VARCHAR(100) NOT NULL,
    country_code VARCHAR(3),
    region VARCHAR(50) NOT NULL,
    weight_slab_min DECIMAL(10,2) NOT NULL,
    weight_slab_max DECIMAL(10,2) NOT NULL,
    price_mmk DECIMAL(12,2) NOT NULL,
    price_usd DECIMAL(12,2),
    effective_date DATE DEFAULT CURRENT_DATE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_by UUID REFERENCES public.admin_users_2026_02_04_16_00(id)
);

-- Create system configuration table
CREATE TABLE IF NOT EXISTS public.system_config_2026_02_04_16_00 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    config_key VARCHAR(100) UNIQUE NOT NULL,
    config_value JSONB NOT NULL,
    description TEXT,
    category VARCHAR(50) DEFAULT 'general',
    is_sensitive BOOLEAN DEFAULT false,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_by UUID REFERENCES public.admin_users_2026_02_04_16_00(id)
);

-- Create marketer performance table
CREATE TABLE IF NOT EXISTS public.marketer_performance_2026_02_04_16_00 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    marketer_id UUID REFERENCES public.admin_users_2026_02_04_16_00(id),
    month_year DATE NOT NULL,
    leads_generated INTEGER DEFAULT 0,
    conversions INTEGER DEFAULT 0,
    revenue_generated DECIMAL(15,2) DEFAULT 0,
    campaigns_run INTEGER DEFAULT 0,
    customer_acquisition_cost DECIMAL(10,2) DEFAULT 0,
    conversion_rate DECIMAL(5,2) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(marketer_id, month_year)
);

-- Create customer service interactions table
CREATE TABLE IF NOT EXISTS public.customer_service_interactions_2026_02_04_16_00 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    agent_id UUID REFERENCES public.admin_users_2026_02_04_16_00(id),
    customer_id UUID,
    customer_name VARCHAR(255),
    customer_phone VARCHAR(20),
    customer_email VARCHAR(255),
    interaction_type VARCHAR(50) NOT NULL CHECK (interaction_type IN (
        'inquiry', 'complaint', 'support', 'feedback', 'refund_request', 'tracking_help'
    )),
    priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'resolved', 'closed')),
    subject VARCHAR(255) NOT NULL,
    description TEXT,
    resolution TEXT,
    satisfaction_rating INTEGER CHECK (satisfaction_rating BETWEEN 1 AND 5),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    resolved_at TIMESTAMP WITH TIME ZONE,
    response_time_minutes INTEGER
);

-- Insert sample admin users
INSERT INTO public.admin_users_2026_02_04_16_00 (email, full_name, role, status, hub_assignment, phone) VALUES
('superadmin@britiumexpress.com', 'Super Administrator', 'super_admin', 'active', 'Global', '+95912345678'),
('admin@britiumexpress.com', 'System Administrator', 'admin', 'active', 'Global', '+95912345679'),
('manager.yangon@britiumexpress.com', 'Yangon Manager', 'manager', 'active', 'Yangon Main Hub', '+95912345680'),
('supervisor.downtown@britiumexpress.com', 'Downtown Supervisor', 'supervisor', 'active', 'Downtown Station', '+95912345681'),
('warehouse.staff@britiumexpress.com', 'Warehouse Staff', 'warehouse_staff', 'active', 'Yangon Main Hub', '+95912345682'),
('rider001@britiumexpress.com', 'Kyaw Kyaw (Rider)', 'rider', 'active', 'Downtown Station', '+95912345683'),
('accountant@britiumexpress.com', 'Financial Officer', 'accountant', 'active', 'Global', '+95912345684'),
('marketer001@britiumexpress.com', 'Marketing Specialist', 'marketer', 'active', 'Global', '+95912345685'),
('cs.agent001@britiumexpress.com', 'Customer Service Agent', 'customer_service', 'active', 'Global', '+95912345686'),
('merchant.partner@britiumexpress.com', 'Merchant Partner', 'merchant', 'active', 'Yangon Main Hub', '+95912345687');

-- Insert sample tariff rates
INSERT INTO public.tariff_rates_2026_02_04_16_00 (country, country_code, region, weight_slab_min, weight_slab_max, price_mmk, price_usd) VALUES
('Thailand 🇹🇭', 'TH', 'Asia', 5.0, 10.0, 15000, 7.14),
('Japan 🇯🇵', 'JP', 'Asia', 5.0, 10.0, 65000, 30.95),
('USA 🇺🇸', 'US', 'North America', 5.0, 10.0, 119000, 56.67),
('Australia 🇦🇺', 'AU', 'Oceania', 5.0, 10.0, 95000, 45.24),
('Singapore 🇸🇬', 'SG', 'Asia', 5.0, 10.0, 18000, 8.57),
('Malaysia 🇲🇾', 'MY', 'Asia', 5.0, 10.0, 12000, 5.71),
('China 🇨🇳', 'CN', 'Asia', 5.0, 10.0, 25000, 11.90),
('India 🇮🇳', 'IN', 'Asia', 5.0, 10.0, 22000, 10.48);

-- Insert sample system configuration
INSERT INTO public.system_config_2026_02_04_16_00 (config_key, config_value, description, category) VALUES
('company_name', '"Britium Express"', 'Company name displayed in the system', 'general'),
('default_currency', '"MMK"', 'Default currency for pricing', 'financial'),
('max_cod_amount', '5000000', 'Maximum COD amount allowed', 'operational'),
('working_hours_start', '"09:00"', 'Daily working hours start time', 'operational'),
('working_hours_end', '"18:00"', 'Daily working hours end time', 'operational'),
('sms_notifications_enabled', 'true', 'Enable SMS notifications', 'notifications'),
('email_notifications_enabled', 'true', 'Enable email notifications', 'notifications');

-- Insert sample marketer performance data
INSERT INTO public.marketer_performance_2026_02_04_16_00 (marketer_id, month_year, leads_generated, conversions, revenue_generated, campaigns_run, customer_acquisition_cost, conversion_rate)
SELECT 
    id,
    '2026-01-01'::date,
    FLOOR(RANDOM() * 100 + 50)::INTEGER,
    FLOOR(RANDOM() * 30 + 10)::INTEGER,
    FLOOR(RANDOM() * 1000000 + 500000)::DECIMAL,
    FLOOR(RANDOM() * 10 + 3)::INTEGER,
    FLOOR(RANDOM() * 50000 + 10000)::DECIMAL,
    FLOOR(RANDOM() * 30 + 15)::DECIMAL
FROM public.admin_users_2026_02_04_16_00 
WHERE role = 'marketer';

-- Insert sample customer service interactions
INSERT INTO public.customer_service_interactions_2026_02_04_16_00 (agent_id, customer_name, customer_phone, interaction_type, priority, status, subject, description, satisfaction_rating)
SELECT 
    id,
    'Customer ' || FLOOR(RANDOM() * 1000)::TEXT,
    '+9591' || FLOOR(RANDOM() * 10000000)::TEXT,
    (ARRAY['inquiry', 'complaint', 'support', 'feedback', 'tracking_help'])[FLOOR(RANDOM() * 5 + 1)],
    (ARRAY['low', 'medium', 'high'])[FLOOR(RANDOM() * 3 + 1)],
    (ARRAY['open', 'resolved', 'closed'])[FLOOR(RANDOM() * 3 + 1)],
    'Sample interaction subject',
    'Sample interaction description with customer inquiry details',
    FLOOR(RANDOM() * 5 + 1)::INTEGER
FROM public.admin_users_2026_02_04_16_00 
WHERE role = 'customer_service'
LIMIT 20;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_admin_users_role ON public.admin_users_2026_02_04_16_00(role);
CREATE INDEX IF NOT EXISTS idx_admin_users_status ON public.admin_users_2026_02_04_16_00(status);
CREATE INDEX IF NOT EXISTS idx_admin_users_email ON public.admin_users_2026_02_04_16_00(email);
CREATE INDEX IF NOT EXISTS idx_bulk_uploads_status ON public.bulk_uploads_2026_02_04_16_00(status);
CREATE INDEX IF NOT EXISTS idx_tariff_rates_country ON public.tariff_rates_2026_02_04_16_00(country);
CREATE INDEX IF NOT EXISTS idx_marketer_performance_date ON public.marketer_performance_2026_02_04_16_00(month_year);
CREATE INDEX IF NOT EXISTS idx_cs_interactions_agent ON public.customer_service_interactions_2026_02_04_16_00(agent_id);
CREATE INDEX IF NOT EXISTS idx_cs_interactions_status ON public.customer_service_interactions_2026_02_04_16_00(status);

-- Enable Row Level Security
ALTER TABLE public.admin_users_2026_02_04_16_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bulk_uploads_2026_02_04_16_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bulk_upload_items_2026_02_04_16_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tariff_rates_2026_02_04_16_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.system_config_2026_02_04_16_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.marketer_performance_2026_02_04_16_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customer_service_interactions_2026_02_04_16_00 ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for admin users
CREATE POLICY "Admin users can view all users" ON public.admin_users_2026_02_04_16_00
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Super admin can manage all users" ON public.admin_users_2026_02_04_16_00
    FOR ALL USING (auth.role() = 'service_role');

-- Create RLS policies for other tables
CREATE POLICY "Authenticated users can view bulk uploads" ON public.bulk_uploads_2026_02_04_16_00
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Admin can manage bulk uploads" ON public.bulk_uploads_2026_02_04_16_00
    FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Authenticated users can view tariff rates" ON public.tariff_rates_2026_02_04_16_00
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Admin can manage tariff rates" ON public.tariff_rates_2026_02_04_16_00
    FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Authenticated users can view system config" ON public.system_config_2026_02_04_16_00
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Admin can manage system config" ON public.system_config_2026_02_04_16_00
    FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Users can view their own performance" ON public.marketer_performance_2026_02_04_16_00
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Admin can manage performance data" ON public.marketer_performance_2026_02_04_16_00
    FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Users can view their interactions" ON public.customer_service_interactions_2026_02_04_16_00
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Admin can manage interactions" ON public.customer_service_interactions_2026_02_04_16_00
    FOR ALL USING (auth.role() = 'service_role');