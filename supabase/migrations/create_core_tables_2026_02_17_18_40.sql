-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom types
DO $$ BEGIN
    CREATE TYPE app_role AS ENUM (
        'SUPER_ADMIN',
        'OPERATIONS_ADMIN', 
        'OPERATIONS_STAFF',
        'SUBSTATION_MANAGER',
        'FINANCE_ADMIN',
        'FINANCE_STAFF', 
        'FINANCE_USER',
        'MARKETING_ADMIN',
        'MARKETING',
        'HR_ADMIN',
        'WAREHOUSE_STAFF',
        'DELIVERY_RIDER',
        'CUSTOMER_SERVICE',
        'MERCHANT',
        'CUSTOMER'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Create branches table
CREATE TABLE IF NOT EXISTS public.branches_2026_02_17_18_40 (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    name text NOT NULL,
    code text NOT NULL UNIQUE,
    address jsonb,
    contact_info jsonb,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    environment text DEFAULT 'production'::text,
    CONSTRAINT branches_2026_02_17_18_40_pkey PRIMARY KEY (id)
);

-- Create users table
CREATE TABLE IF NOT EXISTS public.users_2026_02_17_18_40 (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    email character varying NOT NULL UNIQUE,
    username character varying NOT NULL UNIQUE,
    name character varying NOT NULL,
    role app_role NOT NULL,
    branch_id uuid,
    permissions text[] DEFAULT '{}',
    is_active boolean DEFAULT true,
    is_blocked boolean DEFAULT false,
    blocked_reason text,
    blocked_by uuid,
    blocked_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_login timestamp with time zone,
    login_attempts integer DEFAULT 0,
    metadata jsonb DEFAULT '{}',
    CONSTRAINT users_2026_02_17_18_40_pkey PRIMARY KEY (id),
    CONSTRAINT users_2026_02_17_18_40_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches_2026_02_17_18_40(id),
    CONSTRAINT users_2026_02_17_18_40_blocked_by_fkey FOREIGN KEY (blocked_by) REFERENCES public.users_2026_02_17_18_40(id)
);

-- Create permissions table
CREATE TABLE IF NOT EXISTS public.permissions_2026_02_17_18_40 (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE,
    description text,
    category text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT permissions_2026_02_17_18_40_pkey PRIMARY KEY (id)
);

-- Create role_permissions table
CREATE TABLE IF NOT EXISTS public.role_permissions_2026_02_17_18_40 (
    role app_role NOT NULL,
    permission_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT role_permissions_2026_02_17_18_40_pkey PRIMARY KEY (role, permission_id),
    CONSTRAINT role_permissions_2026_02_17_18_40_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions_2026_02_17_18_40(id)
);

-- Create tamper_tags table
CREATE TABLE IF NOT EXISTS public.tamper_tags_2026_02_17_18_40 (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    tag_code character varying NOT NULL UNIQUE,
    batch_id character varying,
    status character varying DEFAULT 'available',
    assigned_to uuid,
    assigned_at timestamp with time zone,
    activated_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    metadata jsonb DEFAULT '{}',
    CONSTRAINT tamper_tags_2026_02_17_18_40_pkey PRIMARY KEY (id),
    CONSTRAINT tamper_tags_2026_02_17_18_40_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users_2026_02_17_18_40(id)
);

-- Create shipments table
CREATE TABLE IF NOT EXISTS public.shipments_2026_02_17_18_40 (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    awb_number character varying NOT NULL UNIQUE,
    merchant_id uuid,
    customer_id uuid,
    tamper_tag_id uuid,
    pickup_address jsonb NOT NULL,
    delivery_address jsonb NOT NULL,
    package_details jsonb NOT NULL,
    status character varying DEFAULT 'registered',
    priority character varying DEFAULT 'standard',
    cod_amount numeric DEFAULT 0,
    shipping_cost numeric NOT NULL,
    estimated_delivery timestamp with time zone,
    actual_delivery timestamp with time zone,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    metadata jsonb DEFAULT '{}',
    CONSTRAINT shipments_2026_02_17_18_40_pkey PRIMARY KEY (id),
    CONSTRAINT shipments_2026_02_17_18_40_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES public.users_2026_02_17_18_40(id),
    CONSTRAINT shipments_2026_02_17_18_40_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.users_2026_02_17_18_40(id),
    CONSTRAINT shipments_2026_02_17_18_40_tamper_tag_id_fkey FOREIGN KEY (tamper_tag_id) REFERENCES public.tamper_tags_2026_02_17_18_40(id),
    CONSTRAINT shipments_2026_02_17_18_40_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users_2026_02_17_18_40(id)
);

-- Insert sample branches
INSERT INTO public.branches_2026_02_17_18_40 (name, code, address, contact_info) VALUES
('Yangon Central Hub', 'YGN-001', '{"street": "Main Road", "city": "Yangon", "country": "Myanmar"}', '{"phone": "+95-1-234567", "email": "yangon@logistics.com"}'),
('Mandalay Distribution Center', 'MDY-001', '{"street": "Industrial Zone", "city": "Mandalay", "country": "Myanmar"}', '{"phone": "+95-2-234567", "email": "mandalay@logistics.com"}'),
('Naypyidaw Operations', 'NPT-001', '{"street": "Government Quarter", "city": "Naypyidaw", "country": "Myanmar"}', '{"phone": "+95-67-234567", "email": "naypyidaw@logistics.com"}');

-- Insert core permissions
INSERT INTO public.permissions_2026_02_17_18_40 (code, description, category) VALUES
('dashboard.view', 'View dashboard', 'Dashboard'),
('shipments.create', 'Create shipments', 'Shipments'),
('shipments.view', 'View shipments', 'Shipments'),
('shipments.edit', 'Edit shipments', 'Shipments'),
('shipments.delete', 'Delete shipments', 'Shipments'),
('fleet.view', 'View fleet status', 'Fleet'),
('fleet.manage', 'Manage fleet operations', 'Fleet'),
('warehouse.view', 'View warehouse operations', 'Warehouse'),
('warehouse.manage', 'Manage warehouse operations', 'Warehouse'),
('delivery.view', 'View delivery operations', 'Delivery'),
('delivery.manage', 'Manage delivery operations', 'Delivery'),
('analytics.view', 'View analytics', 'Analytics'),
('users.view', 'View users', 'User Management'),
('users.manage', 'Manage users', 'User Management'),
('settings.view', 'View settings', 'Settings'),
('settings.manage', 'Manage settings', 'Settings');

-- Insert sample users
INSERT INTO public.users_2026_02_17_18_40 (email, username, name, role, branch_id) VALUES
('admin@logistics.com', 'admin', 'System Administrator', 'SUPER_ADMIN', (SELECT id FROM public.branches_2026_02_17_18_40 WHERE code = 'YGN-001')),
('ops.manager@logistics.com', 'ops_manager', 'Operations Manager', 'OPERATIONS_ADMIN', (SELECT id FROM public.branches_2026_02_17_18_40 WHERE code = 'YGN-001')),
('warehouse.staff@logistics.com', 'warehouse_001', 'Warehouse Staff', 'WAREHOUSE_STAFF', (SELECT id FROM public.branches_2026_02_17_18_40 WHERE code = 'YGN-001')),
('rider.001@logistics.com', 'rider_001', 'Delivery Rider 001', 'DELIVERY_RIDER', (SELECT id FROM public.branches_2026_02_17_18_40 WHERE code = 'YGN-001')),
('merchant.demo@logistics.com', 'merchant_demo', 'Demo Merchant', 'MERCHANT', (SELECT id FROM public.branches_2026_02_17_18_40 WHERE code = 'YGN-001'));

-- Enable Row Level Security
ALTER TABLE public.branches_2026_02_17_18_40 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.users_2026_02_17_18_40 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.permissions_2026_02_17_18_40 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.role_permissions_2026_02_17_18_40 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tamper_tags_2026_02_17_18_40 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shipments_2026_02_17_18_40 ENABLE ROW LEVEL SECURITY;

-- Create basic RLS policies (allow authenticated users to read)
CREATE POLICY "Allow authenticated users to view branches" ON public.branches_2026_02_17_18_40
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to view users" ON public.users_2026_02_17_18_40
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to view permissions" ON public.permissions_2026_02_17_18_40
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to view role permissions" ON public.role_permissions_2026_02_17_18_40
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to view tamper tags" ON public.tamper_tags_2026_02_17_18_40
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to view shipments" ON public.shipments_2026_02_17_18_40
    FOR SELECT USING (auth.role() = 'authenticated');