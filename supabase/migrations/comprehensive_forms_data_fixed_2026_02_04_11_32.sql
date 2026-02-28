-- Comprehensive Forms and Data Management Tables
-- Created: 2026-02-04 11:32 UTC

-- System Configuration Table
CREATE TABLE IF NOT EXISTS public.system_configuration_2026_02_04_11_32 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL UNIQUE,
    setting_value TEXT NOT NULL,
    setting_type VARCHAR(50) DEFAULT 'string',
    description TEXT,
    min_value INTEGER,
    max_value INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Vouchers Table for Accounting
CREATE TABLE IF NOT EXISTS public.vouchers_2026_02_04_11_32 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    voucher_number VARCHAR(50) NOT NULL UNIQUE,
    voucher_type VARCHAR(50) NOT NULL, -- 'income', 'expense', 'transfer'
    amount DECIMAL(15,2) NOT NULL,
    description TEXT,
    reference_number VARCHAR(100),
    branch_id UUID,
    created_by UUID,
    approved_by UUID,
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'approved', 'rejected'
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Cash Advances Table
CREATE TABLE IF NOT EXISTS public.cash_advances_2026_02_04_11_32 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    advance_number VARCHAR(50) NOT NULL UNIQUE,
    deliveryman_id UUID NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    purpose TEXT,
    status VARCHAR(20) DEFAULT 'active', -- 'active', 'repaid', 'written_off'
    advance_date DATE NOT NULL,
    due_date DATE,
    repaid_amount DECIMAL(10,2) DEFAULT 0,
    created_by UUID,
    approved_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Form Submissions Table (for tracking form saves)
CREATE TABLE IF NOT EXISTS public.form_submissions_2026_02_04_11_32 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    form_type VARCHAR(100) NOT NULL,
    form_data JSONB NOT NULL,
    user_id UUID,
    status VARCHAR(20) DEFAULT 'submitted',
    validation_errors JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default system configuration
INSERT INTO public.system_configuration_2026_02_04_11_32 (setting_key, setting_value, setting_type, description, min_value, max_value) VALUES
('wayIdLength', '6', 'integer', 'Number of digits for Way ID generation (4-10)', 4, 10),
('promotionCodeLength', '8', 'integer', 'Length of promotion codes (6-12 characters)', 6, 12),
('contactPhone', '+95 9 123 456789', 'string', 'Customer support contact number', NULL, NULL),
('maxStationDistance', '5000', 'integer', 'Maximum distance between stations in meters', 100, 50000),
('companyName', 'Britium Express Logistics', 'string', 'Company name for documents and communications', NULL, NULL),
('defaultCurrency', 'MMK', 'string', 'Default currency for transactions', NULL, NULL),
('maxCashAdvance', '500000', 'decimal', 'Maximum cash advance amount per deliveryman', NULL, NULL),
('autoApproveLimit', '100000', 'decimal', 'Auto-approve vouchers below this amount', NULL, NULL)
ON CONFLICT (setting_key) DO UPDATE SET
    setting_value = EXCLUDED.setting_value,
    updated_at = NOW();

-- Sample vouchers data
INSERT INTO public.vouchers_2026_02_04_11_32 (voucher_number, voucher_type, amount, description, transaction_date, status) VALUES
('VCH-2026-001', 'income', 250000.00, 'Delivery service payment from ABC Company', '2026-02-01', 'approved'),
('VCH-2026-002', 'expense', 50000.00, 'Fuel expenses for delivery vehicles', '2026-02-01', 'approved'),
('VCH-2026-003', 'income', 180000.00, 'COD collection from customer deliveries', '2026-02-02', 'approved'),
('VCH-2026-004', 'expense', 25000.00, 'Office supplies and stationery', '2026-02-02', 'pending'),
('VCH-2026-005', 'transfer', 100000.00, 'Transfer to petty cash account', '2026-02-03', 'approved');

-- Sample cash advances data (using generated UUIDs)
INSERT INTO public.cash_advances_2026_02_04_11_32 (advance_number, deliveryman_id, amount, purpose, advance_date, due_date, status) VALUES
('ADV-2026-001', gen_random_uuid(), 50000.00, 'Fuel and maintenance advance', '2026-02-01', '2026-02-15', 'active'),
('ADV-2026-002', gen_random_uuid(), 30000.00, 'Emergency advance for medical expenses', '2026-02-02', '2026-02-16', 'active'),
('ADV-2026-003', gen_random_uuid(), 75000.00, 'Vehicle repair advance', '2026-02-03', '2026-02-17', 'active');

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_system_config_key ON public.system_configuration_2026_02_04_11_32(setting_key);
CREATE INDEX IF NOT EXISTS idx_vouchers_type ON public.vouchers_2026_02_04_11_32(voucher_type);
CREATE INDEX IF NOT EXISTS idx_vouchers_status ON public.vouchers_2026_02_04_11_32(status);
CREATE INDEX IF NOT EXISTS idx_vouchers_date ON public.vouchers_2026_02_04_11_32(transaction_date);
CREATE INDEX IF NOT EXISTS idx_cash_advances_deliveryman ON public.cash_advances_2026_02_04_11_32(deliveryman_id);
CREATE INDEX IF NOT EXISTS idx_cash_advances_status ON public.cash_advances_2026_02_04_11_32(status);
CREATE INDEX IF NOT EXISTS idx_form_submissions_type ON public.form_submissions_2026_02_04_11_32(form_type);

-- Enable RLS
ALTER TABLE public.system_configuration_2026_02_04_11_32 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vouchers_2026_02_04_11_32 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cash_advances_2026_02_04_11_32 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.form_submissions_2026_02_04_11_32 ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Allow authenticated users to read system config" ON public.system_configuration_2026_02_04_11_32
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow admins to manage system config" ON public.system_configuration_2026_02_04_11_32
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() 
            AND role IN ('super_admin', 'admin')
        )
    );

CREATE POLICY "Allow authenticated users to read vouchers" ON public.vouchers_2026_02_04_11_32
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow admins to manage vouchers" ON public.vouchers_2026_02_04_11_32
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() 
            AND role IN ('super_admin', 'admin', 'accountant')
        )
    );

CREATE POLICY "Allow authenticated users to read cash advances" ON public.cash_advances_2026_02_04_11_32
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow admins to manage cash advances" ON public.cash_advances_2026_02_04_11_32
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() 
            AND role IN ('super_admin', 'admin', 'manager')
        )
    );

CREATE POLICY "Allow users to submit forms" ON public.form_submissions_2026_02_04_11_32
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Allow users to read their own form submissions" ON public.form_submissions_2026_02_04_11_32
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Allow admins to read all form submissions" ON public.form_submissions_2026_02_04_11_32
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() 
            AND role IN ('super_admin', 'admin')
        )
    );