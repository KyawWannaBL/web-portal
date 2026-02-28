-- Complete Enterprise Logistics Platform Database Schema
-- Created: 2026-02-19 13:00 UTC

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- CORE USER MANAGEMENT TABLES
-- =============================================

-- User profiles with comprehensive role system
CREATE TABLE IF NOT EXISTS public.profiles_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(50) NOT NULL DEFAULT 'CUSTOMER',
    department VARCHAR(100),
    branch_id UUID,
    employee_id VARCHAR(50),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    permissions JSONB DEFAULT '{}',
    profile_image_url TEXT,
    address TEXT,
    emergency_contact JSONB,
    hire_date DATE,
    salary_info JSONB,
    performance_metrics JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Branches and locations
CREATE TABLE IF NOT EXISTS public.branches_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    type VARCHAR(50) DEFAULT 'BRANCH', -- BRANCH, HUB, WAREHOUSE, SORTING_CENTER
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    country VARCHAR(100) DEFAULT 'Myanmar',
    phone VARCHAR(20),
    email VARCHAR(255),
    manager_id UUID REFERENCES public.profiles_2026_02_19_13_00(id),
    operating_hours JSONB,
    capacity_info JSONB,
    facilities JSONB DEFAULT '[]',
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- CUSTOMER AND MERCHANT MANAGEMENT
-- =============================================

-- Customers
CREATE TABLE IF NOT EXISTS public.customers_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_code VARCHAR(50) UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    company_name VARCHAR(255),
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255),
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    customer_type VARCHAR(50) DEFAULT 'INDIVIDUAL', -- INDIVIDUAL, BUSINESS
    credit_limit DECIMAL(12,2) DEFAULT 0,
    outstanding_balance DECIMAL(12,2) DEFAULT 0,
    payment_terms VARCHAR(50) DEFAULT 'COD',
    preferred_delivery_time VARCHAR(100),
    special_instructions TEXT,
    kyc_status VARCHAR(20) DEFAULT 'PENDING',
    kyc_documents JSONB DEFAULT '[]',
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Merchants
CREATE TABLE IF NOT EXISTS public.merchants_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_code VARCHAR(50) UNIQUE NOT NULL,
    business_name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255),
    business_address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    business_type VARCHAR(100),
    business_license VARCHAR(100),
    tax_id VARCHAR(100),
    bank_account_info JSONB,
    commission_rate DECIMAL(5,2) DEFAULT 0,
    credit_limit DECIMAL(12,2) DEFAULT 0,
    outstanding_balance DECIMAL(12,2) DEFAULT 0,
    monthly_volume INTEGER DEFAULT 0,
    pickup_locations JSONB DEFAULT '[]',
    business_hours JSONB,
    special_rates JSONB DEFAULT '{}',
    contract_details JSONB,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- SHIPMENT AND PACKAGE MANAGEMENT
-- =============================================

-- Shipments
CREATE TABLE IF NOT EXISTS public.shipments_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    awb_number VARCHAR(50) UNIQUE NOT NULL,
    reference_number VARCHAR(100),
    merchant_id UUID REFERENCES public.merchants_2026_02_19_13_00(id),
    customer_id UUID REFERENCES public.customers_2026_02_19_13_00(id),
    
    -- Sender Information
    sender_name VARCHAR(255) NOT NULL,
    sender_phone VARCHAR(20) NOT NULL,
    sender_address TEXT NOT NULL,
    sender_city VARCHAR(100) NOT NULL,
    sender_state VARCHAR(100) NOT NULL,
    
    -- Receiver Information
    receiver_name VARCHAR(255) NOT NULL,
    receiver_phone VARCHAR(20) NOT NULL,
    receiver_address TEXT NOT NULL,
    receiver_city VARCHAR(100) NOT NULL,
    receiver_state VARCHAR(100) NOT NULL,
    
    -- Package Details
    package_type VARCHAR(50) DEFAULT 'DOCUMENT',
    weight DECIMAL(8,2) NOT NULL,
    dimensions JSONB, -- {length, width, height}
    declared_value DECIMAL(12,2) DEFAULT 0,
    contents_description TEXT,
    special_instructions TEXT,
    
    -- Service Details
    service_type VARCHAR(50) DEFAULT 'STANDARD', -- STANDARD, EXPRESS, OVERNIGHT
    payment_method VARCHAR(50) DEFAULT 'COD',
    cod_amount DECIMAL(12,2) DEFAULT 0,
    shipping_cost DECIMAL(10,2) NOT NULL,
    insurance_cost DECIMAL(10,2) DEFAULT 0,
    total_cost DECIMAL(10,2) NOT NULL,
    
    -- Status and Tracking
    status VARCHAR(50) DEFAULT 'CREATED',
    current_location VARCHAR(255),
    origin_branch_id UUID REFERENCES public.branches_2026_02_19_13_00(id),
    destination_branch_id UUID REFERENCES public.branches_2026_02_19_13_00(id),
    assigned_rider_id UUID REFERENCES public.profiles_2026_02_19_13_00(id),
    assigned_vehicle_id UUID,
    
    -- Timestamps
    pickup_date DATE,
    expected_delivery_date DATE,
    actual_delivery_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Shipment tracking history
CREATE TABLE IF NOT EXISTS public.shipment_tracking_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    shipment_id UUID REFERENCES public.shipments_2026_02_19_13_00(id) ON DELETE CASCADE,
    status VARCHAR(50) NOT NULL,
    location VARCHAR(255),
    branch_id UUID REFERENCES public.branches_2026_02_19_13_00(id),
    updated_by UUID REFERENCES public.profiles_2026_02_19_13_00(id),
    notes TEXT,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- FLEET AND VEHICLE MANAGEMENT
-- =============================================

-- Vehicles
CREATE TABLE IF NOT EXISTS public.vehicles_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vehicle_number VARCHAR(50) UNIQUE NOT NULL,
    vehicle_type VARCHAR(50) NOT NULL, -- MOTORCYCLE, VAN, TRUCK
    make VARCHAR(100),
    model VARCHAR(100),
    year INTEGER,
    capacity_weight DECIMAL(8,2),
    capacity_volume DECIMAL(8,2),
    fuel_type VARCHAR(50),
    license_plate VARCHAR(50) UNIQUE,
    insurance_info JSONB,
    maintenance_schedule JSONB,
    current_driver_id UUID REFERENCES public.profiles_2026_02_19_13_00(id),
    home_branch_id UUID REFERENCES public.branches_2026_02_19_13_00(id),
    odometer_reading INTEGER DEFAULT 0,
    fuel_efficiency DECIMAL(5,2),
    status VARCHAR(20) DEFAULT 'AVAILABLE', -- AVAILABLE, IN_USE, MAINTENANCE, RETIRED
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Vehicle tracking
CREATE TABLE IF NOT EXISTS public.vehicle_tracking_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vehicle_id UUID REFERENCES public.vehicles_2026_02_19_13_00(id) ON DELETE CASCADE,
    driver_id UUID REFERENCES public.profiles_2026_02_19_13_00(id),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    speed DECIMAL(5,2),
    heading INTEGER, -- 0-360 degrees
    altitude DECIMAL(8,2),
    accuracy DECIMAL(8,2),
    battery_level INTEGER,
    engine_status VARCHAR(20),
    fuel_level DECIMAL(5,2),
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- ROUTE AND DELIVERY MANAGEMENT
-- =============================================

-- Routes
CREATE TABLE IF NOT EXISTS public.routes_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    route_name VARCHAR(255) NOT NULL,
    route_code VARCHAR(50) UNIQUE NOT NULL,
    origin_branch_id UUID REFERENCES public.branches_2026_02_19_13_00(id),
    destination_branch_id UUID REFERENCES public.branches_2026_02_19_13_00(id),
    route_type VARCHAR(50) DEFAULT 'DELIVERY', -- DELIVERY, PICKUP, TRANSFER
    assigned_vehicle_id UUID REFERENCES public.vehicles_2026_02_19_13_00(id),
    assigned_driver_id UUID REFERENCES public.profiles_2026_02_19_13_00(id),
    planned_start_time TIMESTAMP WITH TIME ZONE,
    planned_end_time TIMESTAMP WITH TIME ZONE,
    actual_start_time TIMESTAMP WITH TIME ZONE,
    actual_end_time TIMESTAMP WITH TIME ZONE,
    total_distance DECIMAL(8,2),
    estimated_duration INTEGER, -- minutes
    actual_duration INTEGER, -- minutes
    waypoints JSONB DEFAULT '[]',
    shipment_ids JSONB DEFAULT '[]',
    status VARCHAR(50) DEFAULT 'PLANNED', -- PLANNED, IN_PROGRESS, COMPLETED, CANCELLED
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Deliveries
CREATE TABLE IF NOT EXISTS public.deliveries_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    shipment_id UUID REFERENCES public.shipments_2026_02_19_13_00(id) ON DELETE CASCADE,
    route_id UUID REFERENCES public.routes_2026_02_19_13_00(id),
    delivery_sequence INTEGER,
    scheduled_time TIMESTAMP WITH TIME ZONE,
    actual_delivery_time TIMESTAMP WITH TIME ZONE,
    delivery_status VARCHAR(50) DEFAULT 'PENDING', -- PENDING, DELIVERED, FAILED, RESCHEDULED
    delivery_attempts INTEGER DEFAULT 0,
    failure_reason TEXT,
    recipient_name VARCHAR(255),
    recipient_phone VARCHAR(20),
    signature_data TEXT,
    photo_proof JSONB DEFAULT '[]',
    delivery_notes TEXT,
    cod_collected DECIMAL(12,2) DEFAULT 0,
    delivery_latitude DECIMAL(10,8),
    delivery_longitude DECIMAL(11,8),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- FINANCIAL MANAGEMENT
-- =============================================

-- Transactions
CREATE TABLE IF NOT EXISTS public.transactions_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_number VARCHAR(50) UNIQUE NOT NULL,
    transaction_type VARCHAR(50) NOT NULL, -- COD_COLLECTION, PAYMENT, REFUND, COMMISSION
    reference_type VARCHAR(50), -- SHIPMENT, MERCHANT, CUSTOMER
    reference_id UUID,
    amount DECIMAL(12,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'MMK',
    payment_method VARCHAR(50),
    collected_by UUID REFERENCES public.profiles_2026_02_19_13_00(id),
    merchant_id UUID REFERENCES public.merchants_2026_02_19_13_00(id),
    customer_id UUID REFERENCES public.customers_2026_02_19_13_00(id),
    branch_id UUID REFERENCES public.branches_2026_02_19_13_00(id),
    status VARCHAR(50) DEFAULT 'PENDING', -- PENDING, COMPLETED, FAILED, CANCELLED
    settlement_status VARCHAR(50) DEFAULT 'UNSETTLED',
    settlement_date DATE,
    notes TEXT,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- INVENTORY AND WAREHOUSE MANAGEMENT
-- =============================================

-- Inventory items
CREATE TABLE IF NOT EXISTS public.inventory_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    item_code VARCHAR(50) UNIQUE NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    description TEXT,
    unit_of_measure VARCHAR(50),
    current_stock INTEGER DEFAULT 0,
    minimum_stock INTEGER DEFAULT 0,
    maximum_stock INTEGER DEFAULT 0,
    unit_cost DECIMAL(10,2),
    supplier_info JSONB,
    storage_location VARCHAR(255),
    branch_id UUID REFERENCES public.branches_2026_02_19_13_00(id),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Inventory movements
CREATE TABLE IF NOT EXISTS public.inventory_movements_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    inventory_id UUID REFERENCES public.inventory_2026_02_19_13_00(id) ON DELETE CASCADE,
    movement_type VARCHAR(50) NOT NULL, -- IN, OUT, TRANSFER, ADJUSTMENT
    quantity INTEGER NOT NULL,
    reference_type VARCHAR(50), -- SHIPMENT, PURCHASE, ADJUSTMENT
    reference_id UUID,
    from_location VARCHAR(255),
    to_location VARCHAR(255),
    unit_cost DECIMAL(10,2),
    total_cost DECIMAL(12,2),
    performed_by UUID REFERENCES public.profiles_2026_02_19_13_00(id),
    notes TEXT,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- SYSTEM AUDIT AND LOGGING
-- =============================================

-- Audit logs
CREATE TABLE IF NOT EXISTS public.audit_logs_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.profiles_2026_02_19_13_00(id),
    action VARCHAR(100) NOT NULL,
    resource_type VARCHAR(100),
    resource_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    session_id VARCHAR(255),
    branch_id UUID REFERENCES public.branches_2026_02_19_13_00(id),
    severity VARCHAR(20) DEFAULT 'INFO', -- INFO, WARNING, ERROR, CRITICAL
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- System notifications
CREATE TABLE IF NOT EXISTS public.notifications_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipient_id UUID REFERENCES public.profiles_2026_02_19_13_00(id),
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'INFO', -- INFO, WARNING, ERROR, SUCCESS
    category VARCHAR(50), -- SHIPMENT, DELIVERY, SYSTEM, FINANCIAL
    reference_type VARCHAR(50),
    reference_id UUID,
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP WITH TIME ZONE,
    expires_at TIMESTAMP WITH TIME ZONE,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- SHIPPING RATES AND CALCULATIONS
-- =============================================

-- Myanmar states and divisions
CREATE TABLE IF NOT EXISTS public.myanmar_locations_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    state_division VARCHAR(100) NOT NULL,
    township VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    zone VARCHAR(50), -- ZONE_1, ZONE_2, ZONE_3 for pricing
    is_remote BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Domestic shipping rates
CREATE TABLE IF NOT EXISTS public.domestic_rates_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    from_zone VARCHAR(50) NOT NULL,
    to_zone VARCHAR(50) NOT NULL,
    service_type VARCHAR(50) NOT NULL,
    weight_from DECIMAL(8,2) NOT NULL,
    weight_to DECIMAL(8,2) NOT NULL,
    base_rate DECIMAL(10,2) NOT NULL,
    per_kg_rate DECIMAL(10,2) DEFAULT 0,
    remote_area_surcharge DECIMAL(10,2) DEFAULT 0,
    fuel_surcharge_percent DECIMAL(5,2) DEFAULT 0,
    effective_from DATE NOT NULL,
    effective_to DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- International shipping rates
CREATE TABLE IF NOT EXISTS public.international_rates_2026_02_19_13_00 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    destination_country VARCHAR(100) NOT NULL,
    destination_zone VARCHAR(50),
    service_type VARCHAR(50) NOT NULL,
    weight_from DECIMAL(8,2) NOT NULL,
    weight_to DECIMAL(8,2) NOT NULL,
    base_rate DECIMAL(10,2) NOT NULL,
    per_kg_rate DECIMAL(10,2) DEFAULT 0,
    customs_clearance_fee DECIMAL(10,2) DEFAULT 0,
    fuel_surcharge_percent DECIMAL(5,2) DEFAULT 0,
    currency VARCHAR(10) DEFAULT 'USD',
    effective_from DATE NOT NULL,
    effective_to DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- INDEXES FOR PERFORMANCE
-- =============================================

-- User and authentication indexes
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON public.profiles_2026_02_19_13_00(user_id);
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles_2026_02_19_13_00(email);
CREATE INDEX IF NOT EXISTS idx_profiles_role ON public.profiles_2026_02_19_13_00(role);

-- Shipment indexes
CREATE INDEX IF NOT EXISTS idx_shipments_awb ON public.shipments_2026_02_19_13_00(awb_number);
CREATE INDEX IF NOT EXISTS idx_shipments_status ON public.shipments_2026_02_19_13_00(status);
CREATE INDEX IF NOT EXISTS idx_shipments_merchant ON public.shipments_2026_02_19_13_00(merchant_id);
CREATE INDEX IF NOT EXISTS idx_shipments_customer ON public.shipments_2026_02_19_13_00(customer_id);
CREATE INDEX IF NOT EXISTS idx_shipments_created ON public.shipments_2026_02_19_13_00(created_at);

-- Tracking indexes
CREATE INDEX IF NOT EXISTS idx_tracking_shipment ON public.shipment_tracking_2026_02_19_13_00(shipment_id);
CREATE INDEX IF NOT EXISTS idx_tracking_timestamp ON public.shipment_tracking_2026_02_19_13_00(timestamp);

-- Vehicle tracking indexes
CREATE INDEX IF NOT EXISTS idx_vehicle_tracking_vehicle ON public.vehicle_tracking_2026_02_19_13_00(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_vehicle_tracking_timestamp ON public.vehicle_tracking_2026_02_19_13_00(timestamp);

-- Financial indexes
CREATE INDEX IF NOT EXISTS idx_transactions_type ON public.transactions_2026_02_19_13_00(transaction_type);
CREATE INDEX IF NOT EXISTS idx_transactions_reference ON public.transactions_2026_02_19_13_00(reference_type, reference_id);
CREATE INDEX IF NOT EXISTS idx_transactions_created ON public.transactions_2026_02_19_13_00(created_at);

-- Audit indexes
CREATE INDEX IF NOT EXISTS idx_audit_user ON public.audit_logs_2026_02_19_13_00(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_timestamp ON public.audit_logs_2026_02_19_13_00(timestamp);
CREATE INDEX IF NOT EXISTS idx_audit_action ON public.audit_logs_2026_02_19_13_00(action);

-- =============================================
-- ROW LEVEL SECURITY POLICIES
-- =============================================

-- Enable RLS on all tables
ALTER TABLE public.profiles_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.branches_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customers_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.merchants_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shipments_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shipment_tracking_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vehicles_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vehicle_tracking_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.routes_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.deliveries_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventory_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventory_movements_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;

-- Basic RLS policies for authenticated users
CREATE POLICY "authenticated_access" ON public.profiles_2026_02_19_13_00 FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "authenticated_access" ON public.branches_2026_02_19_13_00 FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "authenticated_access" ON public.customers_2026_02_19_13_00 FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "authenticated_access" ON public.merchants_2026_02_19_13_00 FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "authenticated_access" ON public.shipments_2026_02_19_13_00 FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "authenticated_access" ON public.shipment_tracking_2026_02_19_13_00 FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "authenticated_access" ON public.vehicles_2026_02_19_13_00 FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "authenticated_access" ON public.vehicle_tracking_2026_02_19_13_00 FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "authenticated_access" ON public.routes_2026_02_19_13_00 FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "authenticated_access" ON public.deliveries_2026_02_19_13_00 FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "authenticated_access" ON public.transactions_2026_02_19_13_00 FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "authenticated_access" ON public.inventory_2026_02_19_13_00 FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "authenticated_access" ON public.inventory_movements_2026_02_19_13_00 FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "authenticated_access" ON public.audit_logs_2026_02_19_13_00 FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "authenticated_access" ON public.notifications_2026_02_19_13_00 FOR ALL USING (auth.role() = 'authenticated');

-- Public access for location and rate tables
ALTER TABLE public.myanmar_locations_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.domestic_rates_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.international_rates_2026_02_19_13_00 ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public_access" ON public.myanmar_locations_2026_02_19_13_00 FOR SELECT USING (true);
CREATE POLICY "public_access" ON public.domestic_rates_2026_02_19_13_00 FOR SELECT USING (true);
CREATE POLICY "public_access" ON public.international_rates_2026_02_19_13_00 FOR SELECT USING (true);