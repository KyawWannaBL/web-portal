-- Fix cash_advances table structure with proper column updates

-- Check existing cash_advances table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'cash_advances'
ORDER BY ordinal_position;

-- Add missing columns to cash_advances table if they don't exist
DO $$ 
BEGIN
    -- Add advance_number column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_schema = 'public' 
                   AND table_name = 'cash_advances' 
                   AND column_name = 'advance_number') THEN
        ALTER TABLE public.cash_advances ADD COLUMN advance_number VARCHAR(50);
    END IF;
    
    -- Add deliveryman_name column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_schema = 'public' 
                   AND table_name = 'cash_advances' 
                   AND column_name = 'deliveryman_name') THEN
        ALTER TABLE public.cash_advances ADD COLUMN deliveryman_name VARCHAR(255);
    END IF;
    
    -- Add advance_date column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_schema = 'public' 
                   AND table_name = 'cash_advances' 
                   AND column_name = 'advance_date') THEN
        ALTER TABLE public.cash_advances ADD COLUMN advance_date DATE DEFAULT CURRENT_DATE;
    END IF;
    
    -- Add due_date column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_schema = 'public' 
                   AND table_name = 'cash_advances' 
                   AND column_name = 'due_date') THEN
        ALTER TABLE public.cash_advances ADD COLUMN due_date DATE;
    END IF;
    
    -- Add repaid_amount column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_schema = 'public' 
                   AND table_name = 'cash_advances' 
                   AND column_name = 'repaid_amount') THEN
        ALTER TABLE public.cash_advances ADD COLUMN repaid_amount DECIMAL(10,2) DEFAULT 0;
    END IF;
END $$;

-- Update existing records with proper advance numbers using a subquery
WITH numbered_advances AS (
    SELECT id, 'ADV-' || TO_CHAR(created_at, 'YYYYMMDD') || '-' || LPAD(ROW_NUMBER() OVER (ORDER BY created_at)::TEXT, 3, '0') as new_advance_number
    FROM public.cash_advances 
    WHERE advance_number IS NULL
)
UPDATE public.cash_advances 
SET advance_number = numbered_advances.new_advance_number
FROM numbered_advances
WHERE public.cash_advances.id = numbered_advances.id;

-- Update existing records to have deliveryman names if they don't have them
UPDATE public.cash_advances 
SET deliveryman_name = 'Unknown Deliveryman'
WHERE deliveryman_name IS NULL OR deliveryman_name = '';

-- Update existing records to have advance dates if they don't have them
UPDATE public.cash_advances 
SET advance_date = created_at::DATE
WHERE advance_date IS NULL;

-- Ensure repaid_amount is not null
UPDATE public.cash_advances 
SET repaid_amount = 0
WHERE repaid_amount IS NULL;

-- Insert sample cash advances data if table is empty
INSERT INTO public.cash_advances (advance_number, deliveryman_id, deliveryman_name, amount, purpose, advance_date, due_date, status, repaid_amount) 
SELECT 'ADV-20260204-001', gen_random_uuid(), 'Ko Aung Myat', 50000.00, 'Fuel and maintenance advance', '2026-02-01', '2026-02-15', 'active', 0
WHERE NOT EXISTS (SELECT 1 FROM public.cash_advances WHERE advance_number = 'ADV-20260204-001');

INSERT INTO public.cash_advances (advance_number, deliveryman_id, deliveryman_name, amount, purpose, advance_date, due_date, status, repaid_amount) 
SELECT 'ADV-20260204-002', gen_random_uuid(), 'Ma Thida', 30000.00, 'Emergency advance for medical expenses', '2026-02-02', '2026-02-16', 'active', 0
WHERE NOT EXISTS (SELECT 1 FROM public.cash_advances WHERE advance_number = 'ADV-20260204-002');

INSERT INTO public.cash_advances (advance_number, deliveryman_id, deliveryman_name, amount, purpose, advance_date, due_date, status, repaid_amount) 
SELECT 'ADV-20260204-003', gen_random_uuid(), 'U Kyaw Win', 75000.00, 'Vehicle repair advance', '2026-02-03', '2026-02-17', 'active', 0
WHERE NOT EXISTS (SELECT 1 FROM public.cash_advances WHERE advance_number = 'ADV-20260204-003');

-- Enable RLS on cash_advances if not already enabled
ALTER TABLE public.cash_advances ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for cash_advances
DROP POLICY IF EXISTS "Allow authenticated users to read cash advances" ON public.cash_advances;
DROP POLICY IF EXISTS "Allow authenticated users to manage cash advances" ON public.cash_advances;

CREATE POLICY "Allow authenticated users to read cash advances" ON public.cash_advances
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to manage cash advances" ON public.cash_advances
    FOR ALL USING (auth.role() = 'authenticated');

-- Show final table structure and sample data
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'cash_advances'
ORDER BY ordinal_position;

-- Show sample data
SELECT advance_number, deliveryman_name, amount, status, advance_date FROM public.cash_advances LIMIT 5;