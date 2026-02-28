-- Comprehensive Warehouse Management System with QR Code Integration
-- Created: 2026-02-04 15:54 UTC

-- Warehouse Stations/Branches
CREATE TABLE IF NOT EXISTS public.warehouse_stations_2026_02_04_15_54 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    station_code VARCHAR(20) UNIQUE NOT NULL,
    station_name VARCHAR(100) NOT NULL,
    station_name_my VARCHAR(100),
    address TEXT,
    phone VARCHAR(20),
    manager_name VARCHAR(100),
    capacity INTEGER DEFAULT 1000,
    zone VARCHAR(50),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Warehouse Staff/Users
CREATE TABLE IF NOT EXISTS public.warehouse_users_2026_02_04_15_54 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id),
    employee_code VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    full_name_my VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    role VARCHAR(50) NOT NULL, -- warehouse_manager, supervisor, scanner, sorter, loader
    station_id UUID REFERENCES public.warehouse_stations_2026_02_04_15_54(id),
    shift VARCHAR(20), -- morning, afternoon, night
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Parcels/Shipments with QR Code Integration
CREATE TABLE IF NOT EXISTS public.warehouse_parcels_2026_02_04_15_54 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tracking_number VARCHAR(50) UNIQUE NOT NULL,
    qr_code VARCHAR(100) UNIQUE NOT NULL, -- QR code for scanning
    barcode VARCHAR(100),
    
    -- Sender Information
    sender_name VARCHAR(100) NOT NULL,
    sender_phone VARCHAR(20),
    sender_address TEXT,
    
    -- Receiver Information
    receiver_name VARCHAR(100) NOT NULL,
    receiver_phone VARCHAR(20),
    receiver_address TEXT,
    
    -- Package Details
    weight_kg DECIMAL(10,2),
    dimensions VARCHAR(50), -- LxWxH in cm
    package_type VARCHAR(50), -- document, parcel, fragile, liquid
    service_type VARCHAR(50), -- standard, express, overnight
    cod_amount DECIMAL(12,2) DEFAULT 0,
    declared_value DECIMAL(12,2) DEFAULT 0,
    
    -- Status and Location
    status VARCHAR(50) NOT NULL DEFAULT 'created',
    current_station_id UUID REFERENCES public.warehouse_stations_2026_02_04_15_54(id),
    sort_bin VARCHAR(10),
    route_code VARCHAR(20),
    manifest_id UUID,
    
    -- Special Instructions
    special_instructions TEXT,
    is_fragile BOOLEAN DEFAULT false,
    requires_signature BOOLEAN DEFAULT false,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expected_delivery_date DATE,
    
    -- Customer Acknowledgment
    customer_signature_url TEXT,
    delivery_photo_url TEXT,
    delivery_notes TEXT
);

-- Warehouse Operations/Events with QR Scanning
CREATE TABLE IF NOT EXISTS public.warehouse_operations_2026_02_04_15_54 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operation_type VARCHAR(50) NOT NULL, -- scan_in, scan_out, sort, load, unload, transfer
    parcel_id UUID REFERENCES public.warehouse_parcels_2026_02_04_15_54(id),
    station_id UUID REFERENCES public.warehouse_stations_2026_02_04_15_54(id),
    user_id UUID REFERENCES public.warehouse_users_2026_02_04_15_54(id),
    
    -- QR Code Scanning Details
    qr_code_scanned VARCHAR(100),
    scan_method VARCHAR(20), -- qr_scanner, manual_entry, barcode
    scan_location VARCHAR(100), -- receiving_dock, sorting_area, loading_bay
    
    -- Operation Details
    from_status VARCHAR(50),
    to_status VARCHAR(50),
    from_location VARCHAR(100),
    to_location VARCHAR(100),
    sort_bin VARCHAR(10),
    route_code VARCHAR(20),
    
    -- Additional Data
    notes TEXT,
    photo_url TEXT,
    signature_url TEXT,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Mobile App Integration
    device_info JSONB,
    gps_location JSONB
);

-- Manifests for Loading/Shipping
CREATE TABLE IF NOT EXISTS public.warehouse_manifests_2026_02_04_15_54 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    manifest_number VARCHAR(50) UNIQUE NOT NULL,
    manifest_type VARCHAR(20) NOT NULL, -- delivery, transfer, return
    
    -- Station Information
    origin_station_id UUID REFERENCES public.warehouse_stations_2026_02_04_15_54(id),
    destination_station_id UUID REFERENCES public.warehouse_stations_2026_02_04_15_54(id),
    route_code VARCHAR(20),
    
    -- Vehicle and Driver
    vehicle_number VARCHAR(20),
    driver_name VARCHAR(100),
    driver_phone VARCHAR(20),
    driver_license VARCHAR(50),
    
    -- Status and Tracking
    status VARCHAR(20) DEFAULT 'draft', -- draft, finalized, dispatched, arrived, completed
    total_parcels INTEGER DEFAULT 0,
    total_weight_kg DECIMAL(10,2) DEFAULT 0,
    total_cod_amount DECIMAL(12,2) DEFAULT 0,
    
    -- QR Code for Manifest
    manifest_qr_code VARCHAR(100) UNIQUE,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    finalized_at TIMESTAMP WITH TIME ZONE,
    dispatched_at TIMESTAMP WITH TIME ZONE,
    arrived_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    
    -- Created by
    created_by UUID REFERENCES public.warehouse_users_2026_02_04_15_54(id)
);

-- Manifest Items (Parcels in Manifest)
CREATE TABLE IF NOT EXISTS public.warehouse_manifest_items_2026_02_04_15_54 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    manifest_id UUID REFERENCES public.warehouse_manifests_2026_02_04_15_54(id),
    parcel_id UUID REFERENCES public.warehouse_parcels_2026_02_04_15_54(id),
    sequence_number INTEGER,
    scanned_at TIMESTAMP WITH TIME ZONE,
    scanned_by UUID REFERENCES public.warehouse_users_2026_02_04_15_54(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Customer Acknowledgments and Signatures
CREATE TABLE IF NOT EXISTS public.customer_acknowledgments_2026_02_04_15_54 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parcel_id UUID REFERENCES public.warehouse_parcels_2026_02_04_15_54(id),
    acknowledgment_type VARCHAR(50) NOT NULL, -- pickup_received, delivery_received, damage_report
    
    -- Customer Information
    customer_name VARCHAR(100),
    customer_phone VARCHAR(20),
    customer_signature_url TEXT,
    customer_photo_url TEXT,
    
    -- Delivery Details
    delivery_location TEXT,
    delivery_photo_url TEXT,
    delivery_notes TEXT,
    
    -- Rider/Staff Information
    delivered_by UUID REFERENCES public.warehouse_users_2026_02_04_15_54(id),
    delivery_method VARCHAR(50), -- home_delivery, pickup_point, office_delivery
    
    -- Mobile App Data
    device_info JSONB,
    gps_location JSONB,
    app_version VARCHAR(20),
    
    -- Timestamps
    acknowledged_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- QR Code Generation and Tracking
CREATE TABLE IF NOT EXISTS public.qr_codes_2026_02_04_15_54 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    qr_code VARCHAR(100) UNIQUE NOT NULL,
    qr_type VARCHAR(50) NOT NULL, -- parcel, manifest, station, user
    reference_id UUID NOT NULL, -- ID of the referenced entity
    reference_table VARCHAR(50) NOT NULL, -- table name
    
    -- QR Code Data
    qr_data JSONB, -- encoded data in QR code
    qr_image_url TEXT, -- URL to QR code image
    
    -- Usage Tracking
    scan_count INTEGER DEFAULT 0,
    last_scanned_at TIMESTAMP WITH TIME ZONE,
    last_scanned_by UUID,
    
    -- Status
    is_active BOOLEAN DEFAULT true,
    expires_at TIMESTAMP WITH TIME ZONE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for Performance
CREATE INDEX IF NOT EXISTS idx_warehouse_parcels_tracking ON public.warehouse_parcels_2026_02_04_15_54(tracking_number);
CREATE INDEX IF NOT EXISTS idx_warehouse_parcels_qr ON public.warehouse_parcels_2026_02_04_15_54(qr_code);
CREATE INDEX IF NOT EXISTS idx_warehouse_parcels_status ON public.warehouse_parcels_2026_02_04_15_54(status);
CREATE INDEX IF NOT EXISTS idx_warehouse_parcels_station ON public.warehouse_parcels_2026_02_04_15_54(current_station_id);
CREATE INDEX IF NOT EXISTS idx_warehouse_operations_parcel ON public.warehouse_operations_2026_02_04_15_54(parcel_id);
CREATE INDEX IF NOT EXISTS idx_warehouse_operations_type ON public.warehouse_operations_2026_02_04_15_54(operation_type);
CREATE INDEX IF NOT EXISTS idx_warehouse_operations_created ON public.warehouse_operations_2026_02_04_15_54(created_at);
CREATE INDEX IF NOT EXISTS idx_qr_codes_code ON public.qr_codes_2026_02_04_15_54(qr_code);
CREATE INDEX IF NOT EXISTS idx_qr_codes_reference ON public.qr_codes_2026_02_04_15_54(reference_id, reference_table);

-- Sample Data
INSERT INTO public.warehouse_stations_2026_02_04_15_54 (station_code, station_name, station_name_my, address, phone, manager_name, zone) VALUES
('YGN-001', 'Yangon Central Hub', 'ရန်ကုန် ဗဟို ဌာန', 'Downtown Yangon', '+95-1-234567', 'Mg Mg', 'Central'),
('YGN-002', 'Yangon North Branch', 'ရန်ကုန် မြောက်ပိုင်း ဌာန', 'North Yangon', '+95-1-234568', 'Ma Ma', 'North'),
('MDY-001', 'Mandalay Hub', 'မန္တလေး ဌာန', 'Mandalay City', '+95-2-234567', 'Ko Ko', 'Upper Myanmar'),
('NPT-001', 'Naypyitaw Branch', 'နေပြည်တော် ဌာန', 'Naypyitaw', '+95-67-234567', 'Daw Daw', 'Capital');

INSERT INTO public.warehouse_users_2026_02_04_15_54 (employee_code, full_name, full_name_my, phone, email, role, station_id, shift) VALUES
('WH001', 'Aung Aung', 'အောင်အောင်', '+95-9-111111', 'aung@britium.com', 'warehouse_manager', (SELECT id FROM public.warehouse_stations_2026_02_04_15_54 WHERE station_code = 'YGN-001'), 'morning'),
('WH002', 'Thida Thida', 'သီတာသီတာ', '+95-9-222222', 'thida@britium.com', 'supervisor', (SELECT id FROM public.warehouse_stations_2026_02_04_15_54 WHERE station_code = 'YGN-001'), 'morning'),
('WH003', 'Kyaw Kyaw', 'ကျော်ကျော်', '+95-9-333333', 'kyaw@britium.com', 'scanner', (SELECT id FROM public.warehouse_stations_2026_02_04_15_54 WHERE station_code = 'YGN-001'), 'afternoon'),
('WH004', 'Mya Mya', 'မြမြ', '+95-9-444444', 'mya@britium.com', 'sorter', (SELECT id FROM public.warehouse_stations_2026_02_04_15_54 WHERE station_code = 'YGN-002'), 'morning'),
('WH005', 'Zaw Zaw', 'ဇော်ဇော်', '+95-9-555555', 'zaw@britium.com', 'loader', (SELECT id FROM public.warehouse_stations_2026_02_04_15_54 WHERE station_code = 'MDY-001'), 'night');

-- Sample Parcels with QR Codes
INSERT INTO public.warehouse_parcels_2026_02_04_15_54 (
    tracking_number, qr_code, sender_name, sender_phone, sender_address,
    receiver_name, receiver_phone, receiver_address, weight_kg, package_type,
    service_type, cod_amount, status, current_station_id, is_fragile
) VALUES
('BE2026020001', 'QR_BE2026020001', 'Ko Thant', '+95-9-111001', 'Yangon, Myanmar',
 'Ma Aye', '+95-9-222001', 'Mandalay, Myanmar', 2.5, 'parcel', 'express', 50000,
 'created', (SELECT id FROM public.warehouse_stations_2026_02_04_15_54 WHERE station_code = 'YGN-001'), false),
('BE2026020002', 'QR_BE2026020002', 'Daw Mya', '+95-9-111002', 'Mandalay, Myanmar',
 'U Aung', '+95-9-222002', 'Yangon, Myanmar', 1.2, 'document', 'standard', 0,
 'inbound_received', (SELECT id FROM public.warehouse_stations_2026_02_04_15_54 WHERE station_code = 'YGN-001'), false),
('BE2026020003', 'QR_BE2026020003', 'Ma Thida', '+95-9-111003', 'Naypyitaw, Myanmar',
 'Ko Zaw', '+95-9-222003', 'Yangon, Myanmar', 5.0, 'fragile', 'express', 75000,
 'sorting', (SELECT id FROM public.warehouse_stations_2026_02_04_15_54 WHERE station_code = 'YGN-001'), true);

-- Generate QR Codes for Parcels
INSERT INTO public.qr_codes_2026_02_04_15_54 (qr_code, qr_type, reference_id, reference_table, qr_data) 
SELECT 
    qr_code, 
    'parcel', 
    id, 
    'warehouse_parcels_2026_02_04_15_54',
    jsonb_build_object(
        'tracking_number', tracking_number,
        'type', 'parcel',
        'created_at', created_at
    )
FROM public.warehouse_parcels_2026_02_04_15_54;

-- Enable Row Level Security
ALTER TABLE public.warehouse_stations_2026_02_04_15_54 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.warehouse_users_2026_02_04_15_54 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.warehouse_parcels_2026_02_04_15_54 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.warehouse_operations_2026_02_04_15_54 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.warehouse_manifests_2026_02_04_15_54 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.warehouse_manifest_items_2026_02_04_15_54 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customer_acknowledgments_2026_02_04_15_54 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.qr_codes_2026_02_04_15_54 ENABLE ROW LEVEL SECURITY;

-- RLS Policies for Warehouse Users
CREATE POLICY "Warehouse users can view their station data" ON public.warehouse_parcels_2026_02_04_15_54
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.warehouse_users_2026_02_04_15_54 wu
            WHERE wu.user_id = auth.uid() 
            AND wu.station_id = current_station_id
            AND wu.is_active = true
        )
        OR auth.role() = 'service_role'
    );

CREATE POLICY "Warehouse users can update parcels in their station" ON public.warehouse_parcels_2026_02_04_15_54
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.warehouse_users_2026_02_04_15_54 wu
            WHERE wu.user_id = auth.uid() 
            AND wu.station_id = current_station_id
            AND wu.is_active = true
        )
        OR auth.role() = 'service_role'
    );

CREATE POLICY "Warehouse users can insert operations" ON public.warehouse_operations_2026_02_04_15_54
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.warehouse_users_2026_02_04_15_54 wu
            WHERE wu.user_id = auth.uid() 
            AND wu.station_id = station_id
            AND wu.is_active = true
        )
        OR auth.role() = 'service_role'
    );

CREATE POLICY "Users can view operations at their station" ON public.warehouse_operations_2026_02_04_15_54
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.warehouse_users_2026_02_04_15_54 wu
            WHERE wu.user_id = auth.uid() 
            AND wu.station_id = station_id
            AND wu.is_active = true
        )
        OR auth.role() = 'service_role'
    );

-- Allow public access to QR codes for scanning
CREATE POLICY "QR codes are publicly readable" ON public.qr_codes_2026_02_04_15_54
    FOR SELECT USING (true);

-- Allow authenticated users to view stations
CREATE POLICY "Authenticated users can view stations" ON public.warehouse_stations_2026_02_04_15_54
    FOR SELECT USING (auth.role() = 'authenticated' OR auth.role() = 'service_role');

-- Allow authenticated users to view warehouse users
CREATE POLICY "Authenticated users can view warehouse users" ON public.warehouse_users_2026_02_04_15_54
    FOR SELECT USING (auth.role() = 'authenticated' OR auth.role() = 'service_role');