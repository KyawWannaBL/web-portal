-- Create comprehensive rider account system with proper data synchronization

-- 1. Create riders table with detailed profile information
CREATE TABLE IF NOT EXISTS public.riders_2026_02_04_14_23 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    rider_code VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    nrc_number VARCHAR(50),
    address TEXT,
    emergency_contact VARCHAR(20),
    vehicle_type VARCHAR(50) DEFAULT 'motorcycle',
    vehicle_number VARCHAR(20),
    license_number VARCHAR(50),
    zone VARCHAR(50) DEFAULT 'downtown-a',
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
    duty_status VARCHAR(20) DEFAULT 'off_duty' CHECK (duty_status IN ('on_duty', 'off_duty', 'break')),
    rating DECIMAL(3,2) DEFAULT 4.5,
    total_deliveries INTEGER DEFAULT 0,
    successful_deliveries INTEGER DEFAULT 0,
    failed_deliveries INTEGER DEFAULT 0,
    cod_balance DECIMAL(12,2) DEFAULT 0,
    wallet_balance DECIMAL(12,2) DEFAULT 0,
    today_earnings DECIMAL(10,2) DEFAULT 0,
    profile_image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Create rider tasks table for job management
CREATE TABLE IF NOT EXISTS public.rider_tasks_2026_02_04_14_23 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_code VARCHAR(20) UNIQUE NOT NULL,
    rider_id UUID REFERENCES public.riders_2026_02_04_14_23(id) ON DELETE CASCADE,
    type VARCHAR(20) NOT NULL CHECK (type IN ('pickup', 'delivery', 'return')),
    status VARCHAR(30) DEFAULT 'pending' CHECK (status IN ('pending', 'assigned', 'in_progress', 'completed', 'failed', 'cancelled')),
    priority VARCHAR(20) DEFAULT 'normal' CHECK (priority IN ('normal', 'express', 'urgent')),
    customer_name VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(20) NOT NULL,
    pickup_address TEXT,
    delivery_address TEXT NOT NULL,
    cod_amount DECIMAL(10,2) DEFAULT 0,
    delivery_fee DECIMAL(8,2) DEFAULT 0,
    sla_time TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    special_instructions TEXT,
    is_fragile BOOLEAN DEFAULT FALSE,
    weight_kg DECIMAL(5,2),
    dimensions VARCHAR(50),
    proof_photo_url TEXT,
    signature_data TEXT,
    completion_notes TEXT,
    assigned_at TIMESTAMP WITH TIME ZONE,
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Create rider transactions table for financial tracking
CREATE TABLE IF NOT EXISTS public.rider_transactions_2026_02_04_14_23 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    rider_id UUID REFERENCES public.riders_2026_02_04_14_23(id) ON DELETE CASCADE,
    task_id UUID REFERENCES public.rider_tasks_2026_02_04_14_23(id) ON DELETE SET NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('cod_collection', 'delivery_fee', 'cod_remittance', 'wallet_withdrawal', 'bonus', 'penalty')),
    amount DECIMAL(10,2) NOT NULL,
    description TEXT NOT NULL,
    reference_number VARCHAR(50),
    status VARCHAR(20) DEFAULT 'completed' CHECK (status IN ('pending', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Create rider locations table for real-time tracking
CREATE TABLE IF NOT EXISTS public.rider_locations_2026_02_04_14_23 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    rider_id UUID REFERENCES public.riders_2026_02_04_14_23(id) ON DELETE CASCADE,
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    accuracy DECIMAL(8,2),
    speed DECIMAL(6,2),
    heading DECIMAL(6,2),
    battery_level INTEGER,
    is_online BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. Create rider notifications table
CREATE TABLE IF NOT EXISTS public.rider_notifications_2026_02_04_14_23 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    rider_id UUID REFERENCES public.riders_2026_02_04_14_23(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(30) DEFAULT 'info' CHECK (type IN ('info', 'warning', 'success', 'error', 'task_assigned', 'payment')),
    is_read BOOLEAN DEFAULT FALSE,
    action_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_riders_user_id ON public.riders_2026_02_04_14_23(user_id);
CREATE INDEX IF NOT EXISTS idx_riders_rider_code ON public.riders_2026_02_04_14_23(rider_code);
CREATE INDEX IF NOT EXISTS idx_riders_status ON public.riders_2026_02_04_14_23(status);
CREATE INDEX IF NOT EXISTS idx_rider_tasks_rider_id ON public.rider_tasks_2026_02_04_14_23(rider_id);
CREATE INDEX IF NOT EXISTS idx_rider_tasks_status ON public.rider_tasks_2026_02_04_14_23(status);
CREATE INDEX IF NOT EXISTS idx_rider_tasks_type ON public.rider_tasks_2026_02_04_14_23(type);
CREATE INDEX IF NOT EXISTS idx_rider_transactions_rider_id ON public.rider_transactions_2026_02_04_14_23(rider_id);
CREATE INDEX IF NOT EXISTS idx_rider_locations_rider_id ON public.rider_locations_2026_02_04_14_23(rider_id);
CREATE INDEX IF NOT EXISTS idx_rider_notifications_rider_id ON public.rider_notifications_2026_02_04_14_23(rider_id);

-- Insert sample rider account
INSERT INTO public.riders_2026_02_04_14_23 (
    rider_code, full_name, phone, email, nrc_number, address, emergency_contact,
    vehicle_type, vehicle_number, license_number, zone, status, duty_status,
    rating, total_deliveries, successful_deliveries, failed_deliveries,
    cod_balance, wallet_balance, today_earnings
) VALUES (
    'RIDER-MM-0042', 'ကျော်ကျော် (Kyaw Kyaw)', '+95912345678', 'kyawkyaw.rider@britium.com',
    '12/OUKAMA(N)123456', 'No. 123, Pyay Road, Kamayut Township, Yangon',
    '+95987654321', 'motorcycle', 'YGN-12345', 'DL-MM-789456', 'downtown-a',
    'active', 'off_duty', 4.8, 1247, 1198, 49, 125000, 25000, 8500
);

-- Get the rider ID for sample data
DO $$
DECLARE
    sample_rider_id UUID;
BEGIN
    SELECT id INTO sample_rider_id FROM public.riders_2026_02_04_14_23 WHERE rider_code = 'RIDER-MM-0042';
    
    -- Insert sample tasks
    INSERT INTO public.rider_tasks_2026_02_04_14_23 (
        task_code, rider_id, type, status, priority, customer_name, customer_phone,
        pickup_address, delivery_address, cod_amount, delivery_fee, sla_time,
        notes, is_fragile, weight_kg
    ) VALUES 
    ('BE001247', sample_rider_id, 'delivery', 'assigned', 'normal', 'မောင်မောင် (Maung Maung)', '+95912345678',
     'Golden City Condo, Bahan Township', 'Room 5A, Build 12, Hledan Center, Kamayut Tsp', 45000, 1500,
     NOW() + INTERVAL '2 hours', 'Doorbell is broken, please call upon arrival.', TRUE, 2.5),
    ('BE001248', sample_rider_id, 'pickup', 'pending', 'express', 'ဇေယျာ (Zeyar)', '+95987654321',
     'Junction Square, Pyay Road', 'Tech Store, Insein Road', 0, 2000,
     NOW() + INTERVAL '1 hour', 'Fragile electronics items', TRUE, 1.2),
    ('BE001249', sample_rider_id, 'delivery', 'completed', 'normal', 'စုစု (Su Su)', '+95976543210',
     'Fashion Hub, Junction City', 'AD Junction, Hlaing Township', 80000, 1800,
     NOW() - INTERVAL '1 hour', 'Completed successfully', FALSE, 3.0);
    
    -- Insert sample transactions
    INSERT INTO public.rider_transactions_2026_02_04_14_23 (
        rider_id, task_id, transaction_type, amount, description, reference_number
    ) VALUES 
    (sample_rider_id, (SELECT id FROM public.rider_tasks_2026_02_04_14_23 WHERE task_code = 'BE001249'), 
     'cod_collection', 80000, 'COD collected from Su Su - Order BE001249', 'COD-BE001249'),
    (sample_rider_id, (SELECT id FROM public.rider_tasks_2026_02_04_14_23 WHERE task_code = 'BE001249'), 
     'delivery_fee', 1800, 'Delivery fee earned - Order BE001249', 'FEE-BE001249'),
    (sample_rider_id, NULL, 'bonus', 5000, 'Performance bonus for excellent rating', 'BONUS-2026-01');
    
    -- Insert sample notifications
    INSERT INTO public.rider_notifications_2026_02_04_14_23 (
        rider_id, title, message, type, is_read
    ) VALUES 
    (sample_rider_id, 'New Task Assigned', 'You have been assigned delivery task BE001247', 'task_assigned', FALSE),
    (sample_rider_id, 'Payment Processed', 'Your daily earnings of 8,500 Ks have been credited', 'payment', FALSE),
    (sample_rider_id, 'Zone Update', 'You are now assigned to Downtown-A zone', 'info', TRUE);
END $$;

-- Enable Row Level Security
ALTER TABLE public.riders_2026_02_04_14_23 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rider_tasks_2026_02_04_14_23 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rider_transactions_2026_02_04_14_23 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rider_locations_2026_02_04_14_23 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rider_notifications_2026_02_04_14_23 ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for riders (riders can only access their own data)
CREATE POLICY "Riders can view own profile" ON public.riders_2026_02_04_14_23
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Riders can update own profile" ON public.riders_2026_02_04_14_23
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Riders can view own tasks" ON public.rider_tasks_2026_02_04_14_23
    FOR SELECT USING (rider_id IN (SELECT id FROM public.riders_2026_02_04_14_23 WHERE user_id = auth.uid()));

CREATE POLICY "Riders can update own tasks" ON public.rider_tasks_2026_02_04_14_23
    FOR UPDATE USING (rider_id IN (SELECT id FROM public.riders_2026_02_04_14_23 WHERE user_id = auth.uid()));

CREATE POLICY "Riders can view own transactions" ON public.rider_transactions_2026_02_04_14_23
    FOR SELECT USING (rider_id IN (SELECT id FROM public.riders_2026_02_04_14_23 WHERE user_id = auth.uid()));

CREATE POLICY "Riders can insert own transactions" ON public.rider_transactions_2026_02_04_14_23
    FOR INSERT WITH CHECK (rider_id IN (SELECT id FROM public.riders_2026_02_04_14_23 WHERE user_id = auth.uid()));

CREATE POLICY "Riders can manage own locations" ON public.rider_locations_2026_02_04_14_23
    FOR ALL USING (rider_id IN (SELECT id FROM public.riders_2026_02_04_14_23 WHERE user_id = auth.uid()));

CREATE POLICY "Riders can view own notifications" ON public.rider_notifications_2026_02_04_14_23
    FOR SELECT USING (rider_id IN (SELECT id FROM public.riders_2026_02_04_14_23 WHERE user_id = auth.uid()));

CREATE POLICY "Riders can update own notifications" ON public.rider_notifications_2026_02_04_14_23
    FOR UPDATE USING (rider_id IN (SELECT id FROM public.riders_2026_02_04_14_23 WHERE user_id = auth.uid()));

-- Admin policies (simplified without profiles table dependency)
CREATE POLICY "Service role can manage all riders" ON public.riders_2026_02_04_14_23
    FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Service role can manage all rider tasks" ON public.rider_tasks_2026_02_04_14_23
    FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Service role can manage all rider transactions" ON public.rider_transactions_2026_02_04_14_23
    FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Service role can view all rider locations" ON public.rider_locations_2026_02_04_14_23
    FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Service role can manage all rider notifications" ON public.rider_notifications_2026_02_04_14_23
    FOR ALL USING (auth.role() = 'service_role');