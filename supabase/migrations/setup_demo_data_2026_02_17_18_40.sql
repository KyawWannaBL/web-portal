-- Update RLS policies to be more permissive for demo
DROP POLICY IF EXISTS "Allow authenticated users to view branches" ON public.branches;
CREATE POLICY "Allow authenticated users to view branches" ON public.branches
    FOR ALL USING (true);

DROP POLICY IF EXISTS "Allow authenticated users to view shipments" ON public.shipments;
CREATE POLICY "Allow authenticated users to view shipments" ON public.shipments
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

-- Add some sample shipments
INSERT INTO public.shipments (
    awb_number,
    status,
    pickup_address,
    delivery_address,
    package_details,
    estimated_delivery,
    created_at
) VALUES
('AWB001234567', 'IN_TRANSIT', 
 '{"address": "123 Main St, Yangon", "contact": "+95912345678"}',
 '{"address": "456 Oak Ave, Mandalay", "contact": "+95987654321"}',
 '{"weight": 2.5, "dimensions": "30x20x15cm", "description": "Electronics"}',
 now() + interval '2 days',
 now()
),
('AWB001234568', 'DELIVERED',
 '{"address": "789 Pine St, Yangon", "contact": "+95911111111"}',
 '{"address": "321 Elm St, Yangon", "contact": "+95922222222"}',
 '{"weight": 1.2, "dimensions": "20x15x10cm", "description": "Documents"}',
 now() - interval '1 day',
 now() - interval '3 days'
),
('AWB001234569', 'PENDING_PICKUP',
 '{"address": "555 Cedar Rd, Mandalay", "contact": "+95933333333"}',
 '{"address": "777 Birch Ln, Yangon", "contact": "+95944444444"}',
 '{"weight": 5.0, "dimensions": "40x30x25cm", "description": "Clothing"}',
 now() + interval '3 days',
 now()
)
ON CONFLICT DO NOTHING;