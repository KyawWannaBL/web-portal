-- Check existing table structures and create missing tables
-- Show all existing tables
SELECT table_name, column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name IN ('system_configuration', 'vouchers', 'cash_advances', 'form_submissions')
ORDER BY table_name, ordinal_position;

-- Create system_configuration table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.system_configuration (
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

-- Create vouchers table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.vouchers (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    voucher_number VARCHAR(50) NOT NULL UNIQUE,
    voucher_type VARCHAR(50) NOT NULL CHECK (voucher_type IN ('income', 'expense', 'transfer')),
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    description TEXT,
    reference_number VARCHAR(100),
    branch_id UUID,
    created_by UUID,
    approved_by UUID,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create form_submissions table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.form_submissions (
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
INSERT INTO public.system_configuration (setting_key, setting_value, setting_type, description, min_value, max_value) VALUES
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
    description = EXCLUDED.description,
    min_value = EXCLUDED.min_value,
    max_value = EXCLUDED.max_value,
    updated_at = NOW();

-- Sample vouchers data
INSERT INTO public.vouchers (voucher_number, voucher_type, amount, description, transaction_date, status) VALUES
('VCH-20260204-001', 'income', 250000.00, 'Delivery service payment from ABC Company', '2026-02-01', 'approved'),
('VCH-20260204-002', 'expense', 50000.00, 'Fuel expenses for delivery vehicles', '2026-02-01', 'approved'),
('VCH-20260204-003', 'income', 180000.00, 'COD collection from customer deliveries', '2026-02-02', 'approved'),
('VCH-20260204-004', 'expense', 25000.00, 'Office supplies and stationery', '2026-02-02', 'pending'),
('VCH-20260204-005', 'transfer', 100000.00, 'Transfer to petty cash account', '2026-02-03', 'approved')
ON CONFLICT (voucher_number) DO NOTHING;

-- Enable RLS
ALTER TABLE public.system_configuration ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vouchers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.form_submissions ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
DROP POLICY IF EXISTS "Allow authenticated users to read system config" ON public.system_configuration;
DROP POLICY IF EXISTS "Allow authenticated users to manage system config" ON public.system_configuration;
DROP POLICY IF EXISTS "Allow authenticated users to read vouchers" ON public.vouchers;
DROP POLICY IF EXISTS "Allow authenticated users to manage vouchers" ON public.vouchers;
DROP POLICY IF EXISTS "Allow authenticated users to manage form submissions" ON public.form_submissions;

CREATE POLICY "Allow authenticated users to read system config" ON public.system_configuration
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to manage system config" ON public.system_configuration
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to read vouchers" ON public.vouchers
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to manage vouchers" ON public.vouchers
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to manage form submissions" ON public.form_submissions
    FOR ALL USING (auth.role() = 'authenticated');