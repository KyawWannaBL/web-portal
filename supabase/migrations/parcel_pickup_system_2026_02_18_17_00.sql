-- Comprehensive Parcel Pickup System with Route Planning and Resource Assignment
-- Current time: 2026-02-18 17:00

-- Create merchants table for business customers
CREATE TABLE IF NOT EXISTS public.merchants_2026_02_18_17_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_code VARCHAR(20) UNIQUE NOT NULL, -- e.g., "MERCH001"
    business_name TEXT NOT NULL,
    contact_person TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT NOT NULL,
    business_address JSONB NOT NULL, -- {street, city, state, postal_code, coordinates}
    business_type VARCHAR(50), -- RETAIL, WHOLESALE, ECOMMERCE, etc.
    registration_date TIMESTAMPTZ DEFAULT NOW(),
    status VARCHAR(20) DEFAULT 'ACTIVE', -- ACTIVE, SUSPENDED, INACTIVE
    pickup_preferences JSONB DEFAULT '{}', -- preferred times, special instructions
    payment_terms JSONB DEFAULT '{}', -- credit terms, payment methods
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create customers table for individual customers
CREATE TABLE IF NOT EXISTS public.customers_2026_02_18_17_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_code VARCHAR(20) UNIQUE NOT NULL, -- e.g., "CUST001"
    full_name TEXT NOT NULL,
    email TEXT UNIQUE,
    phone TEXT NOT NULL,
    addresses JSONB NOT NULL, -- Array of addresses with coordinates
    preferred_pickup_times JSONB DEFAULT '{}',
    registration_date TIMESTAMPTZ DEFAULT NOW(),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create parcels table for pickup orders
CREATE TABLE IF NOT EXISTS public.parcels_2026_02_18_17_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parcel_id VARCHAR(50) UNIQUE NOT NULL, -- e.g., "YGN119874YGN"
    merchant_id UUID REFERENCES public.merchants_2026_02_18_17_00(id),
    customer_id UUID REFERENCES public.customers_2026_02_18_17_00(id),
    
    -- Pickup Information
    pickup_address JSONB NOT NULL, -- {name, phone, address, coordinates}
    pickup_contact_person TEXT,
    pickup_phone TEXT,
    pickup_instructions TEXT,
    preferred_pickup_time TIMESTAMPTZ,
    
    -- Delivery Information
    recipient_name TEXT NOT NULL,
    recipient_phone TEXT NOT NULL,
    delivery_address JSONB NOT NULL, -- {address, coordinates, special_instructions}
    
    -- Parcel Details
    item_description TEXT,
    weight_kg DECIMAL(8,2),
    dimensions JSONB, -- {length, width, height}
    fragile BOOLEAN DEFAULT false,
    
    -- Financial Information
    item_price DECIMAL(12,2) DEFAULT 0,
    delivery_fees DECIMAL(12,2) DEFAULT 0,
    prepaid_amount DECIMAL(12,2) DEFAULT 0,
    cod_amount DECIMAL(12,2) DEFAULT 0,
    currency VARCHAR(3) DEFAULT 'MMK',
    
    -- Status and Tracking
    status VARCHAR(30) DEFAULT 'REGISTERED', -- REGISTERED, PICKED_UP, IN_TRANSIT, OUT_FOR_DELIVERY, DELIVERED, CANCELLED
    priority VARCHAR(20) DEFAULT 'STANDARD', -- STANDARD, EXPRESS, URGENT
    
    -- Route Planning Data
    pickup_zone VARCHAR(10), -- YGN, MDY, NPT, etc.
    delivery_zone VARCHAR(10),
    estimated_distance_km DECIMAL(8,2),
    estimated_duration_minutes INTEGER,
    
    -- Assignment Information
    assigned_route_id UUID,
    assigned_rider_id TEXT,
    assigned_driver_id TEXT,
    assigned_helper_id TEXT,
    assigned_vehicle_id TEXT,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    pickup_scheduled_at TIMESTAMPTZ,
    pickup_completed_at TIMESTAMPTZ,
    delivery_scheduled_at TIMESTAMPTZ,
    delivery_completed_at TIMESTAMPTZ,
    
    -- QR Code Information
    qr_code_generated BOOLEAN DEFAULT false,
    qr_code_printed BOOLEAN DEFAULT false,
    qr_code_data TEXT, -- JSON payload for QR code
    
    -- Additional metadata
    remarks TEXT,
    special_instructions TEXT,
    metadata JSONB DEFAULT '{}'
);

-- Create route plans table for optimized delivery routes
CREATE TABLE IF NOT EXISTS public.route_plans_2026_02_18_17_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    route_code VARCHAR(30) UNIQUE NOT NULL, -- e.g., "YGN-20260218-001"
    route_date DATE NOT NULL,
    zone VARCHAR(10) NOT NULL, -- YGN, MDY, NPT
    
    -- Route Optimization Data
    total_parcels INTEGER DEFAULT 0,
    total_distance_km DECIMAL(10,2),
    estimated_duration_minutes INTEGER,
    optimized_waypoints JSONB, -- Array of coordinates in optimal order
    
    -- Resource Assignment
    assigned_driver_id TEXT,
    assigned_rider_id TEXT,
    assigned_helper_id TEXT,
    assigned_vehicle_id TEXT,
    
    -- Route Status
    status VARCHAR(20) DEFAULT 'PLANNED', -- PLANNED, IN_PROGRESS, COMPLETED, CANCELLED
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    
    -- Performance Metrics
    actual_distance_km DECIMAL(10,2),
    actual_duration_minutes INTEGER,
    parcels_delivered INTEGER DEFAULT 0,
    parcels_failed INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create delivery personnel table
CREATE TABLE IF NOT EXISTS public.delivery_personnel_2026_02_18_17_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    personnel_code VARCHAR(20) UNIQUE NOT NULL, -- e.g., "RIDER001", "DRIVER001"
    full_name TEXT NOT NULL,
    role VARCHAR(20) NOT NULL, -- RIDER, DRIVER, HELPER
    phone TEXT NOT NULL,
    email TEXT,
    
    -- Work Information
    employment_status VARCHAR(20) DEFAULT 'ACTIVE', -- ACTIVE, INACTIVE, ON_LEAVE
    shift_preferences JSONB DEFAULT '{}', -- preferred working hours
    zone_assignments TEXT[], -- zones they can work in
    
    -- Performance Metrics
    total_deliveries INTEGER DEFAULT 0,
    success_rate DECIMAL(5,2) DEFAULT 100.00,
    average_rating DECIMAL(3,2) DEFAULT 5.00,
    
    -- Current Status
    current_status VARCHAR(20) DEFAULT 'AVAILABLE', -- AVAILABLE, ASSIGNED, ON_ROUTE, OFF_DUTY
    current_location JSONB, -- {latitude, longitude, updated_at}
    current_route_id UUID REFERENCES public.route_plans_2026_02_18_17_00(id),
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create vehicles table
CREATE TABLE IF NOT EXISTS public.vehicles_2026_02_18_17_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vehicle_code VARCHAR(20) UNIQUE NOT NULL, -- e.g., "VEH001"
    plate_number VARCHAR(20) UNIQUE NOT NULL,
    vehicle_type VARCHAR(20) NOT NULL, -- MOTORCYCLE, VAN, TRUCK
    capacity_kg DECIMAL(8,2),
    capacity_parcels INTEGER,
    
    -- Status Information
    status VARCHAR(20) DEFAULT 'AVAILABLE', -- AVAILABLE, ASSIGNED, MAINTENANCE, OUT_OF_SERVICE
    current_location JSONB, -- {latitude, longitude, updated_at}
    fuel_level DECIMAL(5,2), -- percentage
    
    -- Assignment
    assigned_driver_id TEXT,
    current_route_id UUID REFERENCES public.route_plans_2026_02_18_17_00(id),
    
    -- Maintenance
    last_service_date DATE,
    next_service_due DATE,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_parcels_status ON public.parcels_2026_02_18_17_00(status);
CREATE INDEX IF NOT EXISTS idx_parcels_pickup_zone ON public.parcels_2026_02_18_17_00(pickup_zone);
CREATE INDEX IF NOT EXISTS idx_parcels_delivery_zone ON public.parcels_2026_02_18_17_00(delivery_zone);
CREATE INDEX IF NOT EXISTS idx_parcels_created_at ON public.parcels_2026_02_18_17_00(created_at);
CREATE INDEX IF NOT EXISTS idx_route_plans_date_zone ON public.route_plans_2026_02_18_17_00(route_date, zone);
CREATE INDEX IF NOT EXISTS idx_delivery_personnel_status ON public.delivery_personnel_2026_02_18_17_00(current_status);
CREATE INDEX IF NOT EXISTS idx_vehicles_status ON public.vehicles_2026_02_18_17_00(status);

-- Function to generate unique parcel ID
CREATE OR REPLACE FUNCTION public.generate_parcel_id_2026_02_18_17_00(
    p_pickup_zone VARCHAR(10) DEFAULT 'YGN'
)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_sequence_num INTEGER;
    v_parcel_id TEXT;
BEGIN
    -- Get next sequence number for the zone and date
    SELECT COALESCE(MAX(CAST(SUBSTRING(parcel_id FROM '[0-9]+') AS INTEGER)), 0) + 1
    INTO v_sequence_num
    FROM public.parcels_2026_02_18_17_00
    WHERE parcel_id LIKE p_pickup_zone || '%' || p_pickup_zone
    AND DATE(created_at) = CURRENT_DATE;
    
    -- Format: YGN119874YGN (zone + 6-digit number + zone)
    v_parcel_id := p_pickup_zone || LPAD(v_sequence_num::TEXT, 6, '0') || p_pickup_zone;
    
    RETURN v_parcel_id;
END;
$$;

-- Function to calculate distance between two coordinates (Haversine formula)
CREATE OR REPLACE FUNCTION public.calculate_distance_km_2026_02_18_17_00(
    lat1 DECIMAL, lon1 DECIMAL, lat2 DECIMAL, lon2 DECIMAL
)
RETURNS DECIMAL
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
    R DECIMAL := 6371; -- Earth's radius in kilometers
    dLat DECIMAL;
    dLon DECIMAL;
    a DECIMAL;
    c DECIMAL;
BEGIN
    dLat := RADIANS(lat2 - lat1);
    dLon := RADIANS(lon2 - lon1);
    
    a := SIN(dLat/2) * SIN(dLat/2) + 
         COS(RADIANS(lat1)) * COS(RADIANS(lat2)) * 
         SIN(dLon/2) * SIN(dLon/2);
    c := 2 * ATAN2(SQRT(a), SQRT(1-a));
    
    RETURN R * c;
END;
$$;

-- Function to automatically assign resources to parcels
CREATE OR REPLACE FUNCTION public.auto_assign_resources_2026_02_18_17_00(
    p_parcel_ids UUID[]
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_result JSONB := '{"assigned": [], "failed": []}';
    v_parcel_id UUID;
    v_zone VARCHAR(10);
    v_route_id UUID;
    v_rider_id TEXT;
    v_driver_id TEXT;
    v_vehicle_id TEXT;
BEGIN
    FOREACH v_parcel_id IN ARRAY p_parcel_ids
    LOOP
        -- Get parcel zone
        SELECT pickup_zone INTO v_zone
        FROM public.parcels_2026_02_18_17_00
        WHERE id = v_parcel_id;
        
        -- Find or create route for the zone and date
        SELECT id INTO v_route_id
        FROM public.route_plans_2026_02_18_17_00
        WHERE zone = v_zone 
        AND route_date = CURRENT_DATE
        AND status = 'PLANNED'
        AND total_parcels < 20 -- Max parcels per route
        ORDER BY total_parcels ASC
        LIMIT 1;
        
        -- Create new route if none available
        IF v_route_id IS NULL THEN
            INSERT INTO public.route_plans_2026_02_18_17_00 (
                route_code, route_date, zone
            ) VALUES (
                v_zone || '-' || TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' || 
                LPAD((SELECT COUNT(*) + 1 FROM public.route_plans_2026_02_18_17_00 
                      WHERE zone = v_zone AND route_date = CURRENT_DATE)::TEXT, 3, '0'),
                CURRENT_DATE,
                v_zone
            ) RETURNING id INTO v_route_id;
        END IF;
        
        -- Assign available rider
        SELECT personnel_code INTO v_rider_id
        FROM public.delivery_personnel_2026_02_18_17_00
        WHERE role = 'RIDER'
        AND current_status = 'AVAILABLE'
        AND v_zone = ANY(zone_assignments)
        ORDER BY total_deliveries ASC
        LIMIT 1;
        
        -- Assign available vehicle
        SELECT vehicle_code INTO v_vehicle_id
        FROM public.vehicles_2026_02_18_17_00
        WHERE status = 'AVAILABLE'
        AND vehicle_type IN ('MOTORCYCLE', 'VAN')
        ORDER BY capacity_parcels DESC
        LIMIT 1;
        
        -- Update parcel with assignments
        UPDATE public.parcels_2026_02_18_17_00
        SET 
            assigned_route_id = v_route_id,
            assigned_rider_id = v_rider_id,
            assigned_vehicle_id = v_vehicle_id,
            status = 'ASSIGNED',
            updated_at = NOW()
        WHERE id = v_parcel_id;
        
        -- Update route parcel count
        UPDATE public.route_plans_2026_02_18_17_00
        SET total_parcels = total_parcels + 1
        WHERE id = v_route_id;
        
        -- Update personnel status
        IF v_rider_id IS NOT NULL THEN
            UPDATE public.delivery_personnel_2026_02_18_17_00
            SET 
                current_status = 'ASSIGNED',
                current_route_id = v_route_id
            WHERE personnel_code = v_rider_id;
        END IF;
        
        -- Update vehicle status
        IF v_vehicle_id IS NOT NULL THEN
            UPDATE public.vehicles_2026_02_18_17_00
            SET 
                status = 'ASSIGNED',
                current_route_id = v_route_id
            WHERE vehicle_code = v_vehicle_id;
        END IF;
        
        -- Add to result
        v_result := jsonb_set(
            v_result,
            '{assigned}',
            (v_result->'assigned') || jsonb_build_object(
                'parcel_id', v_parcel_id,
                'route_id', v_route_id,
                'rider_id', v_rider_id,
                'vehicle_id', v_vehicle_id
            )
        );
    END LOOP;
    
    RETURN v_result;
END;
$$;

-- Enable RLS on all tables
ALTER TABLE public.merchants_2026_02_18_17_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customers_2026_02_18_17_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parcels_2026_02_18_17_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.route_plans_2026_02_18_17_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.delivery_personnel_2026_02_18_17_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vehicles_2026_02_18_17_00 ENABLE ROW LEVEL SECURITY;

-- RLS Policies (permissive for demo)
CREATE POLICY "Allow all operations" ON public.merchants_2026_02_18_17_00 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.customers_2026_02_18_17_00 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.parcels_2026_02_18_17_00 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.route_plans_2026_02_18_17_00 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.delivery_personnel_2026_02_18_17_00 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.vehicles_2026_02_18_17_00 FOR ALL USING (true) WITH CHECK (true);

-- Insert sample data
-- Sample merchants
INSERT INTO public.merchants_2026_02_18_17_00 (merchant_code, business_name, contact_person, email, phone, business_address, business_type) VALUES
('MERCH001', 'Golden Dragon Electronics', 'Thant Zin', 'thant@goldendragon.com', '09123456789', '{"street": "123 Merchant St", "city": "Yangon", "coordinates": {"lat": 16.8661, "lng": 96.1951}}', 'RETAIL'),
('MERCH002', 'Myanmar Fashion House', 'Aye Aye', 'aye@myanmarfashion.com', '09987654321', '{"street": "456 Fashion Ave", "city": "Yangon", "coordinates": {"lat": 16.8551, "lng": 96.1851}}', 'RETAIL'),
('MERCH003', 'Tech Solutions Myanmar', 'Ko Ko', 'koko@techsolutions.mm', '09555666777', '{"street": "789 Tech Park", "city": "Yangon", "coordinates": {"lat": 16.8451, "lng": 96.1751}}', 'ECOMMERCE');

-- Sample customers
INSERT INTO public.customers_2026_02_18_17_00 (customer_code, full_name, email, phone, addresses) VALUES
('CUST001', 'Ma Thida', 'thida@email.com', '09792970776', '[{"name": "Home", "address": "N Okkalapa, Yangon", "coordinates": {"lat": 16.8761, "lng": 96.1561}}]'),
('CUST002', 'Ko Aung', 'aung@email.com', '09888999000', '[{"name": "Office", "address": "Downtown Yangon", "coordinates": {"lat": 16.7761, "lng": 96.1461}}]'),
('CUST003', 'Ma Sandar', 'sandar@email.com', '09777888999', '[{"name": "Home", "address": "Insein Township", "coordinates": {"lat": 16.8961, "lng": 96.1361}}]');

-- Sample delivery personnel
INSERT INTO public.delivery_personnel_2026_02_18_17_00 (personnel_code, full_name, role, phone, zone_assignments, current_status) VALUES
('RIDER001', 'Ko Thura', 'RIDER', '09111222333', '{"YGN", "MDY"}', 'AVAILABLE'),
('RIDER002', 'Ko Zaw', 'RIDER', '09444555666', '{"YGN"}', 'AVAILABLE'),
('DRIVER001', 'Ko Myint', 'DRIVER', '09777888999', '{"YGN", "NPT"}', 'AVAILABLE'),
('HELPER001', 'Ko Tun', 'HELPER', '09333444555', '{"YGN"}', 'AVAILABLE');

-- Sample vehicles
INSERT INTO public.vehicles_2026_02_18_17_00 (vehicle_code, plate_number, vehicle_type, capacity_kg, capacity_parcels, status) VALUES
('VEH001', 'YGN-1234', 'MOTORCYCLE', 50, 10, 'AVAILABLE'),
('VEH002', 'YGN-5678', 'VAN', 500, 50, 'AVAILABLE'),
('VEH003', 'YGN-9012', 'TRUCK', 2000, 100, 'AVAILABLE');

-- Sample parcels
INSERT INTO public.parcels_2026_02_18_17_00 (
    parcel_id, merchant_id, customer_id, 
    pickup_address, recipient_name, recipient_phone, delivery_address,
    item_description, weight_kg, item_price, delivery_fees, cod_amount,
    pickup_zone, delivery_zone, status
) VALUES
('YGN119874YGN', 
 (SELECT id FROM public.merchants_2026_02_18_17_00 WHERE merchant_code = 'MERCH001'),
 (SELECT id FROM public.customers_2026_02_18_17_00 WHERE customer_code = 'CUST001'),
 '{"name": "Golden Dragon Electronics", "phone": "09123456789", "address": "123 Merchant St, Yangon", "coordinates": {"lat": 16.8661, "lng": 96.1951}}',
 'Ma Thida', '09792970776',
 '{"address": "N Okkalapa, Yangon", "coordinates": {"lat": 16.8761, "lng": 96.1561}}',
 'Electronics Package', 2.5, 150000, 5000, 155000,
 'YGN', 'YGN', 'REGISTERED'),
 
('YGN220001YGN',
 (SELECT id FROM public.merchants_2026_02_18_17_00 WHERE merchant_code = 'MERCH002'),
 (SELECT id FROM public.customers_2026_02_18_17_00 WHERE customer_code = 'CUST002'),
 '{"name": "Myanmar Fashion House", "phone": "09987654321", "address": "456 Fashion Ave, Yangon", "coordinates": {"lat": 16.8551, "lng": 96.1851}}',
 'Ko Aung', '09888999000',
 '{"address": "Downtown Yangon", "coordinates": {"lat": 16.7761, "lng": 96.1461}}',
 'Fashion Items', 1.2, 75000, 3000, 78000,
 'YGN', 'YGN', 'REGISTERED');