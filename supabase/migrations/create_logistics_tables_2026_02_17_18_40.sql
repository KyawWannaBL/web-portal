-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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
    CONSTRAINT branches_2026_02_17_18_40_pkey PRIMARY KEY (id)
);

-- Create users table
CREATE TABLE IF NOT EXISTS public.users_2026_02_17_18_40 (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    email character varying NOT NULL UNIQUE,
    username character varying NOT NULL UNIQUE,
    name character varying NOT NULL,
    role character varying NOT NULL,
    branch_id uuid,
    permissions text[] DEFAULT '{}',
    is_active boolean DEFAULT true,
    is_blocked boolean DEFAULT false,
    blocked_reason text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_login timestamp with time zone,
    login_attempts integer DEFAULT 0,
    metadata jsonb DEFAULT '{}',
    CONSTRAINT users_2026_02_17_18_40_pkey PRIMARY KEY (id),
    CONSTRAINT users_2026_02_17_18_40_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches_2026_02_17_18_40(id)
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

-- Create shipment status history table
CREATE TABLE IF NOT EXISTS public.shipment_status_history_2026_02_17_18_40 (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    shipment_id uuid NOT NULL,
    status character varying NOT NULL,
    location character varying,
    notes text,
    updated_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    metadata jsonb DEFAULT '{}',
    CONSTRAINT shipment_status_history_2026_02_17_18_40_pkey PRIMARY KEY (id),
    CONSTRAINT shipment_status_history_2026_02_17_18_40_shipment_id_fkey FOREIGN KEY (shipment_id) REFERENCES public.shipments_2026_02_17_18_40(id),
    CONSTRAINT shipment_status_history_2026_02_17_18_40_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users_2026_02_17_18_40(id)
);

-- Create delivery records table
CREATE TABLE IF NOT EXISTS public.delivery_records_2026_02_17_18_40 (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    shipment_id uuid NOT NULL,
    rider_id uuid NOT NULL,
    delivery_time timestamp with time zone DEFAULT now(),
    delivery_photos text[],
    customer_signature text,
    recipient_name character varying,
    delivery_status character varying DEFAULT 'delivered',
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT delivery_records_2026_02_17_18_40_pkey PRIMARY KEY (id),
    CONSTRAINT delivery_records_2026_02_17_18_40_shipment_id_fkey FOREIGN KEY (shipment_id) REFERENCES public.shipments_2026_02_17_18_40(id),
    CONSTRAINT delivery_records_2026_02_17_18_40_rider_id_fkey FOREIGN KEY (rider_id) REFERENCES public.users_2026_02_17_18_40(id)
);

-- Create audit logs table
CREATE TABLE IF NOT EXISTS public.audit_logs_2026_02_17_18_40 (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid,
    action text,
    entity text,
    entity_id uuid,
    details jsonb DEFAULT '{}',
    ip_address text,
    user_agent text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT audit_logs_2026_02_17_18_40_pkey PRIMARY KEY (id),
    CONSTRAINT audit_logs_2026_02_17_18_40_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users_2026_02_17_18_40(id)
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

-- Insert sample tamper tags
INSERT INTO public.tamper_tags_2026_02_17_18_40 (tag_code, batch_id, status) VALUES
('TT-2026-001001', 'BATCH-001', 'available'),
('TT-2026-001002', 'BATCH-001', 'available'),
('TT-2026-001003', 'BATCH-001', 'assigned'),
('TT-2026-001004', 'BATCH-001', 'used'),
('TT-2026-001005', 'BATCH-001', 'available');

-- Insert sample shipments
INSERT INTO public.shipments_2026_02_17_18_40 (
    awb_number, 
    merchant_id, 
    customer_id, 
    pickup_address, 
    delivery_address, 
    package_details, 
    status, 
    shipping_cost, 
    cod_amount,
    created_by
) VALUES
(
    'EDS2026021701',
    (SELECT id FROM public.users_2026_02_17_18_40 WHERE username = 'merchant_demo'),
    (SELECT id FROM public.users_2026_02_17_18_40 WHERE username = 'merchant_demo'),
    '{"name": "ABC Electronics", "phone": "+95-1-111111", "address": "123 Main St, Yangon", "city": "Yangon"}',
    '{"name": "John Doe", "phone": "+95-1-222222", "address": "456 Oak Ave, Yangon", "city": "Yangon"}',
    '{"weight": 2.5, "dimensions": {"length": 30, "width": 20, "height": 15}, "description": "Electronics Package", "value": 150000}',
    'registered',
    5000,
    150000,
    (SELECT id FROM public.users_2026_02_17_18_40 WHERE username = 'ops_manager')
),
(
    'EDS2026021702',
    (SELECT id FROM public.users_2026_02_17_18_40 WHERE username = 'merchant_demo'),
    (SELECT id FROM public.users_2026_02_17_18_40 WHERE username = 'merchant_demo'),
    '{"name": "XYZ Fashion", "phone": "+95-1-333333", "address": "789 Fashion St, Yangon", "city": "Yangon"}',
    '{"name": "Jane Smith", "phone": "+95-1-444444", "address": "321 Pine Rd, Mandalay", "city": "Mandalay"}',
    '{"weight": 1.2, "dimensions": {"length": 25, "width": 15, "height": 10}, "description": "Clothing Package", "value": 75000}',
    'in_transit',
    8000,
    75000,
    (SELECT id FROM public.users_2026_02_17_18_40 WHERE username = 'ops_manager')
),
(
    'EDS2026021703',
    (SELECT id FROM public.users_2026_02_17_18_40 WHERE username = 'merchant_demo'),
    (SELECT id FROM public.users_2026_02_17_18_40 WHERE username = 'merchant_demo'),
    '{"name": "Tech Store", "phone": "+95-1-555555", "address": "999 Tech Ave, Yangon", "city": "Yangon"}',
    '{"name": "Bob Wilson", "phone": "+95-67-666666", "address": "777 Capital St, Naypyidaw", "city": "Naypyidaw"}',
    '{"weight": 3.8, "dimensions": {"length": 40, "width": 30, "height": 20}, "description": "Computer Equipment", "value": 250000}',
    'delivered',
    12000,
    250000,
    (SELECT id FROM public.users_2026_02_17_18_40 WHERE username = 'ops_manager')
);

-- Insert sample status history
INSERT INTO public.shipment_status_history_2026_02_17_18_40 (shipment_id, status, location, notes, updated_by) VALUES
((SELECT id FROM public.shipments_2026_02_17_18_40 WHERE awb_number = 'EDS2026021701'), 'registered', 'Yangon Hub', 'Package registered and ready for pickup', (SELECT id FROM public.users_2026_02_17_18_40 WHERE username = 'ops_manager')),
((SELECT id FROM public.shipments_2026_02_17_18_40 WHERE awb_number = 'EDS2026021702'), 'registered', 'Yangon Hub', 'Package registered', (SELECT id FROM public.users_2026_02_17_18_40 WHERE username = 'ops_manager')),
((SELECT id FROM public.shipments_2026_02_17_18_40 WHERE awb_number = 'EDS2026021702'), 'in_transit', 'En route to Mandalay', 'Package in transit', (SELECT id FROM public.users_2026_02_17_18_40 WHERE username = 'rider_001')),
((SELECT id FROM public.shipments_2026_02_17_18_40 WHERE awb_number = 'EDS2026021703'), 'registered', 'Yangon Hub', 'Package registered', (SELECT id FROM public.users_2026_02_17_18_40 WHERE username = 'ops_manager')),
((SELECT id FROM public.shipments_2026_02_17_18_40 WHERE awb_number = 'EDS2026021703'), 'delivered', 'Naypyidaw', 'Successfully delivered', (SELECT id FROM public.users_2026_02_17_18_40 WHERE username = 'rider_001'));

-- Enable Row Level Security
ALTER TABLE public.branches_2026_02_17_18_40 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.users_2026_02_17_18_40 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.permissions_2026_02_17_18_40 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tamper_tags_2026_02_17_18_40 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shipments_2026_02_17_18_40 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shipment_status_history_2026_02_17_18_40 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.delivery_records_2026_02_17_18_40 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs_2026_02_17_18_40 ENABLE ROW LEVEL SECURITY;

-- Create basic RLS policies (allow authenticated users to read)
CREATE POLICY "Allow authenticated users to view branches" ON public.branches_2026_02_17_18_40
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to view users" ON public.users_2026_02_17_18_40
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to view permissions" ON public.permissions_2026_02_17_18_40
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to view tamper tags" ON public.tamper_tags_2026_02_17_18_40
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to view shipments" ON public.shipments_2026_02_17_18_40
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to view shipment history" ON public.shipment_status_history_2026_02_17_18_40
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to view delivery records" ON public.delivery_records_2026_02_17_18_40
    FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Allow authenticated users to view audit logs" ON public.audit_logs_2026_02_17_18_40
    FOR SELECT USING (auth.role() = 'authenticated');