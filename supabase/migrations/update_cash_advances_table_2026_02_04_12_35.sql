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
        ALTER TABLE public.cash_advances ADD COLUMN advance_number VARCHAR(50) UNIQUE;
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

-- Update existing records to have advance numbers if they don't have them
UPDATE public.cash_advances 
SET advance_number = 'ADV-' || TO_CHAR(created_at, 'YYYYMMDD') || '-' || LPAD(ROW_NUMBER() OVER (ORDER BY created_at)::TEXT, 3, '0')
WHERE advance_number IS NULL;

-- Update existing records to have deliveryman names if they don't have them
UPDATE public.cash_advances 
SET deliveryman_name = COALESCE(deliveryman_name, 'Unknown Deliveryman')
WHERE deliveryman_name IS NULL OR deliveryman_name = '';

-- Update existing records to have advance dates if they don't have them
UPDATE public.cash_advances 
SET advance_date = COALESCE(advance_date, created_at::DATE)
WHERE advance_date IS NULL;

-- Ensure repaid_amount is not null
UPDATE public.cash_advances 
SET repaid_amount = COALESCE(repaid_amount, 0)
WHERE repaid_amount IS NULL;

-- Add constraints after data is cleaned up
ALTER TABLE public.cash_advances ALTER COLUMN advance_number SET NOT NULL;
ALTER TABLE public.cash_advances ALTER COLUMN deliveryman_name SET NOT NULL;
ALTER TABLE public.cash_advances ALTER COLUMN advance_date SET NOT NULL;

-- Create unique constraint on advance_number if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'cash_advances_advance_number_key') THEN
        ALTER TABLE public.cash_advances ADD CONSTRAINT cash_advances_advance_number_key UNIQUE (advance_number);
    END IF;
END $$;

-- Show final table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'cash_advances'
ORDER BY ordinal_position;