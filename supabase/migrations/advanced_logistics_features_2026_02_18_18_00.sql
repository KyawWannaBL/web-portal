-- Advanced Logistics Features: GPS Tracking, Route Optimization, Electronic Signatures
-- Current time: 2026-02-18 18:00

-- Create GPS tracking table for real-time location monitoring
CREATE TABLE IF NOT EXISTS public.gps_tracking_2026_02_18_18_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id TEXT NOT NULL, -- rider phone, vehicle tracker, etc.
    user_id TEXT, -- rider/driver ID
    vehicle_id TEXT,
    route_id UUID REFERENCES public.route_plans_2026_02_18_17_00(id),
    
    -- Location Data
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    altitude DECIMAL(8,2), -- meters above sea level
    accuracy DECIMAL(8,2), -- GPS accuracy in meters
    speed DECIMAL(8,2), -- km/h
    heading DECIMAL(5,2), -- degrees (0-360)
    
    -- Status Information
    battery_level INTEGER, -- percentage
    signal_strength INTEGER, -- percentage
    is_moving BOOLEAN DEFAULT false,
    location_source VARCHAR(20) DEFAULT 'GPS', -- GPS, NETWORK, PASSIVE
    
    -- Timestamps
    recorded_at TIMESTAMPTZ NOT NULL,
    uploaded_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Additional Data
    metadata JSONB DEFAULT '{}', -- speed violations, geofence events, etc.
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create geofences table for location-based alerts
CREATE TABLE IF NOT EXISTS public.geofences_2026_02_18_18_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    type VARCHAR(20) NOT NULL, -- PICKUP, DELIVERY, WAREHOUSE, RESTRICTED
    
    -- Geofence Definition
    center_lat DECIMAL(10,8) NOT NULL,
    center_lng DECIMAL(11,8) NOT NULL,
    radius_meters INTEGER NOT NULL,
    polygon_coordinates JSONB, -- for complex shapes
    
    -- Settings
    is_active BOOLEAN DEFAULT true,
    entry_alert BOOLEAN DEFAULT true,
    exit_alert BOOLEAN DEFAULT true,
    
    -- Associated Data
    branch_id TEXT,
    zone VARCHAR(10),
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create route optimization results table
CREATE TABLE IF NOT EXISTS public.route_optimizations_2026_02_18_18_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    route_id UUID REFERENCES public.route_plans_2026_02_18_17_00(id),
    optimization_type VARCHAR(30) DEFAULT 'DISTANCE', -- DISTANCE, TIME, FUEL, MIXED
    
    -- Original Route Data
    original_waypoints JSONB NOT NULL,
    original_distance_km DECIMAL(10,2),
    original_duration_minutes INTEGER,
    
    -- Optimized Route Data
    optimized_waypoints JSONB NOT NULL,
    optimized_distance_km DECIMAL(10,2),
    optimized_duration_minutes INTEGER,
    
    -- Optimization Results
    distance_saved_km DECIMAL(10,2),
    time_saved_minutes INTEGER,
    fuel_saved_liters DECIMAL(8,2),
    cost_saved_amount DECIMAL(12,2),
    
    -- Algorithm Information
    algorithm_used VARCHAR(50), -- NEAREST_NEIGHBOR, GENETIC, SIMULATED_ANNEALING
    computation_time_ms INTEGER,
    optimization_score DECIMAL(5,2), -- 0-100 quality score
    
    -- Status
    status VARCHAR(20) DEFAULT 'COMPLETED', -- PENDING, COMPLETED, FAILED
    applied_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create electronic signatures table
CREATE TABLE IF NOT EXISTS public.electronic_signatures_2026_02_18_18_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parcel_id TEXT NOT NULL,
    shipment_id TEXT,
    
    -- Signature Data
    signature_data TEXT NOT NULL, -- Base64 encoded signature image
    signature_hash TEXT NOT NULL, -- SHA-256 hash for verification
    signature_points JSONB, -- Raw signature coordinates for analysis
    
    -- Signer Information
    signer_name TEXT NOT NULL,
    signer_phone TEXT,
    signer_id_type VARCHAR(20), -- NRC, PASSPORT, DRIVING_LICENSE
    signer_id_number TEXT,
    relationship_to_recipient VARCHAR(30), -- SELF, FAMILY, COLLEAGUE, NEIGHBOR
    
    -- Delivery Information
    delivery_rider_id TEXT NOT NULL,
    delivery_location JSONB, -- GPS coordinates where signed
    delivery_timestamp TIMESTAMPTZ NOT NULL,
    delivery_notes TEXT,
    
    -- Verification Data
    device_info JSONB, -- device model, OS, app version
    ip_address INET,
    user_agent TEXT,
    
    -- Photo Evidence
    recipient_photo_url TEXT, -- photo of person who signed
    package_photo_url TEXT, -- photo of delivered package
    location_photo_url TEXT, -- photo of delivery location
    
    -- Status and Validation
    is_verified BOOLEAN DEFAULT false,
    verification_method VARCHAR(30), -- BIOMETRIC, OTP, ID_CHECK
    signature_quality_score DECIMAL(5,2), -- 0-100 quality assessment
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create data entry automation table
CREATE TABLE IF NOT EXISTS public.data_entry_automation_2026_02_18_18_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Source Information
    source_type VARCHAR(30) NOT NULL, -- QR_SCAN, BARCODE_SCAN, OCR_DOCUMENT, VOICE_INPUT
    source_data TEXT NOT NULL, -- raw scanned/captured data
    source_file_url TEXT, -- URL to original image/document
    
    -- Processing Information
    processing_method VARCHAR(30), -- REGEX, ML_MODEL, API_LOOKUP, MANUAL
    confidence_score DECIMAL(5,2), -- 0-100 confidence in extraction
    processing_time_ms INTEGER,
    
    -- Extracted Data
    extracted_fields JSONB NOT NULL, -- structured data extracted
    validation_results JSONB, -- field validation results
    correction_suggestions JSONB, -- suggested corrections
    
    -- Target Information
    target_table TEXT, -- which table to populate
    target_record_id UUID, -- ID of created/updated record
    auto_applied BOOLEAN DEFAULT false, -- whether data was automatically applied
    
    -- Human Review
    requires_review BOOLEAN DEFAULT false,
    reviewed_by TEXT,
    reviewed_at TIMESTAMPTZ,
    review_notes TEXT,
    
    -- Status
    status VARCHAR(20) DEFAULT 'PROCESSED', -- PENDING, PROCESSED, APPLIED, REJECTED
    error_message TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create real-time events table for live updates
CREATE TABLE IF NOT EXISTS public.realtime_events_2026_02_18_18_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type VARCHAR(50) NOT NULL, -- GPS_UPDATE, GEOFENCE_ENTRY, SIGNATURE_CAPTURED, etc.
    entity_type VARCHAR(30) NOT NULL, -- PARCEL, ROUTE, VEHICLE, RIDER
    entity_id TEXT NOT NULL,
    
    -- Event Data
    event_data JSONB NOT NULL,
    priority VARCHAR(10) DEFAULT 'NORMAL', -- LOW, NORMAL, HIGH, CRITICAL
    
    -- Location Context
    location JSONB, -- GPS coordinates if applicable
    geofence_id UUID REFERENCES public.geofences_2026_02_18_18_00(id),
    
    -- Notification Settings
    notify_users TEXT[], -- user IDs to notify
    notification_sent BOOLEAN DEFAULT false,
    notification_channels TEXT[], -- SMS, EMAIL, PUSH, WEBSOCKET
    
    -- Processing
    processed BOOLEAN DEFAULT false,
    processed_at TIMESTAMPTZ,
    processing_result JSONB,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_gps_tracking_device_time ON public.gps_tracking_2026_02_18_18_00(device_id, recorded_at DESC);
CREATE INDEX IF NOT EXISTS idx_gps_tracking_route ON public.gps_tracking_2026_02_18_18_00(route_id, recorded_at DESC);
CREATE INDEX IF NOT EXISTS idx_gps_tracking_location ON public.gps_tracking_2026_02_18_18_00(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_geofences_location ON public.geofences_2026_02_18_18_00(center_lat, center_lng);
CREATE INDEX IF NOT EXISTS idx_signatures_parcel ON public.electronic_signatures_2026_02_18_18_00(parcel_id);
CREATE INDEX IF NOT EXISTS idx_signatures_rider ON public.electronic_signatures_2026_02_18_18_00(delivery_rider_id);
CREATE INDEX IF NOT EXISTS idx_data_entry_status ON public.data_entry_automation_2026_02_18_18_00(status, created_at);
CREATE INDEX IF NOT EXISTS idx_realtime_events_type ON public.realtime_events_2026_02_18_18_00(event_type, created_at DESC);

-- Function to check if point is within geofence
CREATE OR REPLACE FUNCTION public.check_geofence_2026_02_18_18_00(
    p_lat DECIMAL, p_lng DECIMAL, p_geofence_id UUID
)
RETURNS BOOLEAN
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
    v_geofence RECORD;
    v_distance DECIMAL;
BEGIN
    SELECT center_lat, center_lng, radius_meters, is_active
    INTO v_geofence
    FROM public.geofences_2026_02_18_18_00
    WHERE id = p_geofence_id;
    
    IF NOT FOUND OR NOT v_geofence.is_active THEN
        RETURN false;
    END IF;
    
    -- Calculate distance using Haversine formula
    v_distance := public.calculate_distance_km_2026_02_18_17_00(
        p_lat, p_lng, v_geofence.center_lat, v_geofence.center_lng
    ) * 1000; -- convert to meters
    
    RETURN v_distance <= v_geofence.radius_meters;
END;
$$;

-- Function to process GPS tracking data and trigger events
CREATE OR REPLACE FUNCTION public.process_gps_update_2026_02_18_18_00(
    p_device_id TEXT,
    p_latitude DECIMAL,
    p_longitude DECIMAL,
    p_speed DECIMAL DEFAULT NULL,
    p_heading DECIMAL DEFAULT NULL,
    p_accuracy DECIMAL DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_tracking_id UUID;
    v_user_id TEXT;
    v_route_id UUID;
    v_geofence RECORD;
    v_events JSONB := '[]';
    v_is_moving BOOLEAN;
BEGIN
    -- Determine if moving (speed > 5 km/h)
    v_is_moving := COALESCE(p_speed, 0) > 5;
    
    -- Insert GPS tracking record
    INSERT INTO public.gps_tracking_2026_02_18_18_00 (
        device_id, latitude, longitude, speed, heading, accuracy, 
        is_moving, recorded_at
    ) VALUES (
        p_device_id, p_latitude, p_longitude, p_speed, p_heading, p_accuracy,
        v_is_moving, NOW()
    ) RETURNING id, user_id, route_id INTO v_tracking_id, v_user_id, v_route_id;
    
    -- Check for geofence events
    FOR v_geofence IN 
        SELECT id, name, type, entry_alert, exit_alert
        FROM public.geofences_2026_02_18_18_00
        WHERE is_active = true
    LOOP
        IF public.check_geofence_2026_02_18_18_00(p_latitude, p_longitude, v_geofence.id) THEN
            -- Create geofence entry event
            INSERT INTO public.realtime_events_2026_02_18_18_00 (
                event_type, entity_type, entity_id, event_data, location, geofence_id
            ) VALUES (
                'GEOFENCE_ENTRY', 'DEVICE', p_device_id,
                jsonb_build_object(
                    'geofence_name', v_geofence.name,
                    'geofence_type', v_geofence.type,
                    'user_id', v_user_id,
                    'route_id', v_route_id
                ),
                jsonb_build_object('lat', p_latitude, 'lng', p_longitude),
                v_geofence.id
            );
            
            v_events := v_events || jsonb_build_object(
                'type', 'geofence_entry',
                'geofence', v_geofence.name
            );
        END IF;
    END LOOP;
    
    -- Check for speed violations (> 80 km/h)
    IF COALESCE(p_speed, 0) > 80 THEN
        INSERT INTO public.realtime_events_2026_02_18_18_00 (
            event_type, entity_type, entity_id, event_data, location, priority
        ) VALUES (
            'SPEED_VIOLATION', 'DEVICE', p_device_id,
            jsonb_build_object(
                'speed', p_speed,
                'limit', 80,
                'user_id', v_user_id,
                'route_id', v_route_id
            ),
            jsonb_build_object('lat', p_latitude, 'lng', p_longitude),
            'HIGH'
        );
        
        v_events := v_events || jsonb_build_object(
            'type', 'speed_violation',
            'speed', p_speed
        );
    END IF;
    
    RETURN jsonb_build_object(
        'tracking_id', v_tracking_id,
        'events_triggered', v_events,
        'is_moving', v_is_moving
    );
END;
$$;

-- Function to validate electronic signature
CREATE OR REPLACE FUNCTION public.validate_signature_2026_02_18_18_00(
    p_signature_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_signature RECORD;
    v_validation_result JSONB;
    v_quality_score DECIMAL := 0;
BEGIN
    SELECT * INTO v_signature
    FROM public.electronic_signatures_2026_02_18_18_00
    WHERE id = p_signature_id;
    
    IF NOT FOUND THEN
        RETURN jsonb_build_object('error', 'Signature not found');
    END IF;
    
    -- Basic validation checks
    v_validation_result := jsonb_build_object(
        'signature_present', v_signature.signature_data IS NOT NULL,
        'signer_name_present', v_signature.signer_name IS NOT NULL,
        'delivery_location_present', v_signature.delivery_location IS NOT NULL,
        'timestamp_valid', v_signature.delivery_timestamp IS NOT NULL
    );
    
    -- Calculate quality score
    IF v_signature.signature_data IS NOT NULL THEN v_quality_score := v_quality_score + 25; END IF;
    IF v_signature.signer_name IS NOT NULL THEN v_quality_score := v_quality_score + 15; END IF;
    IF v_signature.signer_phone IS NOT NULL THEN v_quality_score := v_quality_score + 10; END IF;
    IF v_signature.signer_id_number IS NOT NULL THEN v_quality_score := v_quality_score + 20; END IF;
    IF v_signature.recipient_photo_url IS NOT NULL THEN v_quality_score := v_quality_score + 15; END IF;
    IF v_signature.package_photo_url IS NOT NULL THEN v_quality_score := v_quality_score + 10; END IF;
    IF v_signature.delivery_location IS NOT NULL THEN v_quality_score := v_quality_score + 5; END IF;
    
    -- Update signature with quality score
    UPDATE public.electronic_signatures_2026_02_18_18_00
    SET 
        signature_quality_score = v_quality_score,
        is_verified = v_quality_score >= 70,
        updated_at = NOW()
    WHERE id = p_signature_id;
    
    RETURN jsonb_build_object(
        'validation_result', v_validation_result,
        'quality_score', v_quality_score,
        'is_verified', v_quality_score >= 70,
        'recommendations', CASE 
            WHEN v_quality_score < 70 THEN jsonb_build_array(
                'Add recipient photo',
                'Verify signer ID',
                'Capture package photo'
            )
            ELSE jsonb_build_array()
        END
    );
END;
$$;

-- Enable RLS
ALTER TABLE public.gps_tracking_2026_02_18_18_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.geofences_2026_02_18_18_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.route_optimizations_2026_02_18_18_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.electronic_signatures_2026_02_18_18_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.data_entry_automation_2026_02_18_18_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.realtime_events_2026_02_18_18_00 ENABLE ROW LEVEL SECURITY;

-- RLS Policies (permissive for demo)
CREATE POLICY "Allow all operations" ON public.gps_tracking_2026_02_18_18_00 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.geofences_2026_02_18_18_00 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.route_optimizations_2026_02_18_18_00 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.electronic_signatures_2026_02_18_18_00 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.data_entry_automation_2026_02_18_18_00 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.realtime_events_2026_02_18_18_00 FOR ALL USING (true) WITH CHECK (true);

-- Insert sample geofences for Yangon
INSERT INTO public.geofences_2026_02_18_18_00 (name, type, center_lat, center_lng, radius_meters, zone) VALUES
('Yangon Main Warehouse', 'WAREHOUSE', 16.8661, 96.1951, 500, 'YGN'),
('Downtown Delivery Zone', 'DELIVERY', 16.7761, 96.1461, 2000, 'YGN'),
('North Okkalapa Zone', 'DELIVERY', 16.8761, 96.1561, 1500, 'YGN'),
('Insein Township Zone', 'DELIVERY', 16.8961, 96.1361, 1800, 'YGN'),
('Airport Restricted Zone', 'RESTRICTED', 16.9073, 96.1333, 1000, 'YGN');

-- Insert sample GPS tracking data
INSERT INTO public.gps_tracking_2026_02_18_18_00 (device_id, user_id, latitude, longitude, speed, heading, accuracy, is_moving, recorded_at) VALUES
('RIDER001_PHONE', 'RIDER001', 16.8661, 96.1951, 25.5, 45.0, 5.0, true, NOW() - INTERVAL '5 minutes'),
('RIDER001_PHONE', 'RIDER001', 16.8671, 96.1961, 30.2, 50.0, 4.5, true, NOW() - INTERVAL '4 minutes'),
('RIDER002_PHONE', 'RIDER002', 16.7761, 96.1461, 0.0, 0.0, 3.0, false, NOW() - INTERVAL '2 minutes');

-- Insert sample electronic signature
INSERT INTO public.electronic_signatures_2026_02_18_18_00 (
    parcel_id, signature_data, signature_hash, signer_name, signer_phone,
    delivery_rider_id, delivery_location, delivery_timestamp, signature_quality_score
) VALUES (
    'YGN119874YGN', 
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
    'a1b2c3d4e5f6789012345678901234567890abcdef',
    'Ma Thida', '09792970776',
    'RIDER001',
    '{"lat": 16.8761, "lng": 96.1561, "address": "N Okkalapa, Yangon"}',
    NOW() - INTERVAL '1 hour',
    85.5
);

-- Insert sample data entry automation record
INSERT INTO public.data_entry_automation_2026_02_18_18_00 (
    source_type, source_data, processing_method, confidence_score,
    extracted_fields, target_table, auto_applied, status
) VALUES (
    'QR_SCAN', 'YGN119874YGN', 'REGEX', 95.0,
    '{"parcel_id": "YGN119874YGN", "zone": "YGN", "sequence": "119874"}',
    'parcels_2026_02_18_17_00', true, 'APPLIED'
);