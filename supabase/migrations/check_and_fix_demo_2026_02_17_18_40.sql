-- Check what columns exist in shipments table
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'shipments' 
AND table_schema = 'public';

-- Update RLS policies to be more permissive for demo
DROP POLICY IF EXISTS "Allow authenticated users to view branches" ON public.branches;
CREATE POLICY "Allow authenticated users to view branches" ON public.branches
    FOR ALL USING (true);

-- Update profiles policies to allow viewing all profiles for admin users
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
CREATE POLICY "Users can view own profile" ON public.profiles
    FOR SELECT USING (
        auth.uid() = id OR 
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() 
            AND role IN ('SUPER_ADMIN', 'APP_OWNER', 'OPERATIONS_ADMIN')
        )
    );

-- Allow profile updates
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile" ON public.profiles
    FOR UPDATE USING (
        auth.uid() = id OR 
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() 
            AND role IN ('SUPER_ADMIN', 'APP_OWNER')
        )
    );

-- Allow profile inserts (for new user registration)
CREATE POLICY "Allow profile creation" ON public.profiles
    FOR INSERT WITH CHECK (true);

-- Make sure we have some sample data
INSERT INTO public.branches (name, code, is_active, environment) VALUES
('Head Office', 'HQ', true, 'production'),
('Yangon Branch', 'YGN-001', true, 'production'),
('Mandalay Branch', 'MDY-001', true, 'production')
ON CONFLICT (code) DO NOTHING;