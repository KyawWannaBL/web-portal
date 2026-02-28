-- Check cash_advances table structure and add only necessary columns

-- Show existing cash_advances table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'cash_advances'
ORDER BY ordinal_position;

-- Add missing columns one by one with error handling
DO $$ 
BEGIN
    -- Add advance_number column if it doesn't exist
    BEGIN
        ALTER TABLE public.cash_advances ADD COLUMN advance_number VARCHAR(50);
    EXCEPTION WHEN duplicate_column THEN
        -- Column already exists, do nothing
    END;
    
    -- Add deliveryman_name column if it doesn't exist
    BEGIN
        ALTER TABLE public.cash_advances ADD COLUMN deliveryman_name VARCHAR(255);
    EXCEPTION WHEN duplicate_column THEN
        -- Column already exists, do nothing
    END;
    
    -- Add advance_date column if it doesn't exist
    BEGIN
        ALTER TABLE public.cash_advances ADD COLUMN advance_date DATE DEFAULT CURRENT_DATE;
    EXCEPTION WHEN duplicate_column THEN
        -- Column already exists, do nothing
    END;
    
    -- Add due_date column if it doesn't exist
    BEGIN
        ALTER TABLE public.cash_advances ADD COLUMN due_date DATE;
    EXCEPTION WHEN duplicate_column THEN
        -- Column already exists, do nothing
    END;
    
    -- Add repaid_amount column if it doesn't exist
    BEGIN
        ALTER TABLE public.cash_advances ADD COLUMN repaid_amount DECIMAL(10,2) DEFAULT 0;
    EXCEPTION WHEN duplicate_column THEN
        -- Column already exists, do nothing
    END;
    
    -- Add purpose column if it doesn't exist
    BEGIN
        ALTER TABLE public.cash_advances ADD COLUMN purpose TEXT;
    EXCEPTION WHEN duplicate_column THEN
        -- Column already exists, do nothing
    END;
END $$;

-- Update existing records with advance numbers if they don't have them
UPDATE public.cash_advances 
SET advance_number = 'ADV-' || TO_CHAR(COALESCE(created_at, NOW()), 'YYYYMMDD') || '-' || LPAD((random() * 999 + 1)::INTEGER::TEXT, 3, '0')
WHERE advance_number IS NULL OR advance_number = '';

-- Update existing records to have deliveryman names if they don't have them
UPDATE public.cash_advances 
SET deliveryman_name = 'Unknown Deliveryman'
WHERE deliveryman_name IS NULL OR deliveryman_name = '';

-- Update existing records to have advance dates if they don't have them
UPDATE public.cash_advances 
SET advance_date = COALESCE(created_at::DATE, CURRENT_DATE)
WHERE advance_date IS NULL;

-- Ensure repaid_amount is not null
UPDATE public.cash_advances 
SET repaid_amount = 0
WHERE repaid_amount IS NULL;

-- Enable RLS on cash_advances
ALTER TABLE public.cash_advances ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for cash_advances
DROP POLICY IF EXISTS "Allow authenticated users to read cash advances" ON public.cash_advances;
DROP POLICY IF EXISTS "Allow authenticated users to manage cash advances" ON public.cash_advances;

CREATE POLICY "Allow authenticated users to read cash advances" ON public.cash_advances
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to manage cash advances" ON public.cash_advances
    FOR ALL USING (auth.role() = 'authenticated');

-- Show final table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'cash_advances'
ORDER BY ordinal_position;

-- Count records in cash_advances table
SELECT COUNT(*) as total_cash_advances FROM public.cash_advances;