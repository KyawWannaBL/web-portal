-- Basic User Management Tables for Britium Express
-- Created: 2026-02-04 05:03 UTC

-- User profiles table
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE, -- Firebase Auth UID
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(50) NOT NULL DEFAULT 'customer' CHECK (role IN ('super_admin', 'admin', 'manager', 'sub_station_manager', 'supervisor', 'warehouse', 'rider', 'merchant', 'vendor', 'accountant', 'customer')),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended', 'pending')),
    avatar_url TEXT,
    branch_id UUID,
    merchant_id UUID,
    last_login TIMESTAMP WITH TIME ZONE,
    email_verified BOOLEAN DEFAULT FALSE,
    phone_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User permissions table
CREATE TABLE IF NOT EXISTS public.user_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    permission_name VARCHAR(100) NOT NULL,
    resource VARCHAR(100) NOT NULL,
    actions TEXT[] NOT NULL, -- ['create', 'read', 'update', 'delete']
    granted_by UUID REFERENCES public.profiles(id),
    granted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Branches table
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

-- Shipments table (basic structure)
CREATE TABLE IF NOT EXISTS public.shipments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tracking_number VARCHAR(50) UNIQUE NOT NULL,
    sender_name VARCHAR(100) NOT NULL,
    sender_phone VARCHAR(20) NOT NULL,
    sender_address TEXT NOT NULL,
    sender_city VARCHAR(100) NOT NULL,
    receiver_name VARCHAR(100) NOT NULL,
    receiver_phone VARCHAR(20) NOT NULL,
    receiver_address TEXT NOT NULL,
    receiver_city VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'picked_up', 'in_transit', 'arrived_at_warehouse', 'out_for_delivery', 'delivered', 'failed', 'cancelled', 'returned')),
    weight DECIMAL(8,2),
    dimensions JSONB, -- {length, width, height}
    price DECIMAL(10,2) NOT NULL,
    cod_amount DECIMAL(10,2) DEFAULT 0,
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded')),
    service_type VARCHAR(50) DEFAULT 'standard',
    priority INTEGER DEFAULT 1 CHECK (priority BETWEEN 1 AND 5),
    special_instructions TEXT,
    branch_id UUID REFERENCES public.branches(id),
    rider_id UUID REFERENCES public.profiles(id),
    merchant_id UUID,
    created_by UUID REFERENCES public.profiles(id),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email);
CREATE INDEX IF NOT EXISTS idx_profiles_role ON public.profiles(role);
CREATE INDEX IF NOT EXISTS idx_profiles_status ON public.profiles(status);
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON public.profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_shipments_tracking ON public.shipments(tracking_number);
CREATE INDEX IF NOT EXISTS idx_shipments_status ON public.shipments(status);
CREATE INDEX IF NOT EXISTS idx_branches_code ON public.branches(branch_code);

-- Insert default admin users
INSERT INTO public.profiles (user_id, email, full_name, role, status, email_verified) VALUES
('admin-001', 'admin@britiumexpress.com', 'System Administrator', 'super_admin', 'active', true),
('admin-002', 'manager@britiumexpress.com', 'Branch Manager', 'admin', 'active', true)
ON CONFLICT (email) DO NOTHING;

-- Insert default branch
INSERT INTO public.branches (branch_code, branch_name, address, city, phone, email) VALUES
('YGN001', 'Yangon Main Branch', 'No. 123, Main Street, Downtown', 'Yangon', '+95-1-234567', 'yangon@britiumexpress.com'),
('MDY001', 'Mandalay Branch', 'No. 456, Central Road, Mandalay', 'Mandalay', '+95-2-345678', 'mandalay@britiumexpress.com')
ON CONFLICT (branch_code) DO NOTHING;

-- Enable RLS (Row Level Security)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shipments ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Users can view their own profile" ON public.profiles
    FOR SELECT USING (auth.uid()::text = user_id OR auth.role() = 'authenticated');

CREATE POLICY "Admins can manage all profiles" ON public.profiles
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE user_id = auth.uid()::text 
            AND role IN ('super_admin', 'admin')
        )
    );

CREATE POLICY "Users can update their own profile" ON public.profiles
    FOR UPDATE USING (auth.uid()::text = user_id);

CREATE POLICY "Authenticated users can view branches" ON public.branches
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Admins can manage branches" ON public.branches
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE user_id = auth.uid()::text 
            AND role IN ('super_admin', 'admin', 'manager')
        )
    );

CREATE POLICY "Authenticated users can view shipments" ON public.shipments
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authorized users can manage shipments" ON public.shipments
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE user_id = auth.uid()::text 
            AND role IN ('super_admin', 'admin', 'manager', 'warehouse', 'rider')
        )
    );