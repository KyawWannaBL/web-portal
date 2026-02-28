-- Advanced Features Backend Support
-- QR Code System, GPS Tracking, Electronic Signatures, Route Planning

-- QR Code Generation and Tracking
CREATE TABLE IF NOT EXISTS qr_codes_advanced_2026_02_19_15_00 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  qr_code TEXT UNIQUE NOT NULL,
  qr_type TEXT NOT NULL CHECK (qr_type IN ('SHIPMENT', 'PARCEL', 'VEHICLE', 'RIDER', 'WAREHOUSE')),
  reference_id UUID NOT NULL,
  reference_type TEXT NOT NULL,
  data JSONB NOT NULL DEFAULT '{}',
  status TEXT NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'SCANNED', 'EXPIRED', 'INVALID')),
  generated_by UUID,
  scanned_by UUID,
  scanned_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  scan_count INTEGER DEFAULT 0,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- GPS Tracking Data
CREATE TABLE IF NOT EXISTS gps_tracking_advanced_2026_02_19_15_00 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id TEXT NOT NULL,
  vehicle_id UUID,
  rider_id UUID,
  shipment_id UUID,
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  altitude DECIMAL(8, 2),
  accuracy DECIMAL(8, 2),
  speed DECIMAL(8, 2),
  heading DECIMAL(5, 2),
  battery_level INTEGER,
  signal_strength INTEGER,
  location_type TEXT DEFAULT 'GPS' CHECK (location_type IN ('GPS', 'NETWORK', 'PASSIVE')),
  address TEXT,
  geofence_status JSONB DEFAULT '{}',
  metadata JSONB DEFAULT '{}',
  recorded_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Electronic Signatures
CREATE TABLE IF NOT EXISTS electronic_signatures_2026_02_19_15_00 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  signature_data TEXT NOT NULL, -- Base64 encoded signature image
  signature_type TEXT NOT NULL CHECK (signature_type IN ('PICKUP', 'DELIVERY', 'RECEIPT', 'AUTHORIZATION')),
  reference_id UUID NOT NULL,
  reference_type TEXT NOT NULL,
  signer_name TEXT NOT NULL,
  signer_id_number TEXT,
  signer_phone TEXT,
  signed_by UUID, -- User who captured the signature
  signature_metadata JSONB DEFAULT '{}',
  verification_status TEXT DEFAULT 'PENDING' CHECK (verification_status IN ('PENDING', 'VERIFIED', 'REJECTED')),
  verified_by UUID,
  verified_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Route Optimization Data
CREATE TABLE IF NOT EXISTS route_optimizations_2026_02_19_15_00 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  route_name TEXT NOT NULL,
  vehicle_id UUID,
  rider_id UUID,
  start_location JSONB NOT NULL,
  end_location JSONB,
  waypoints JSONB DEFAULT '[]',
  optimized_sequence JSONB DEFAULT '[]',
  total_distance DECIMAL(10, 2),
  estimated_duration INTEGER, -- in minutes
  actual_duration INTEGER,
  fuel_consumption DECIMAL(8, 2),
  optimization_algorithm TEXT DEFAULT 'NEAREST_NEIGHBOR',
  status TEXT DEFAULT 'PLANNED' CHECK (status IN ('PLANNED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Geofences for Location-based Alerts
CREATE TABLE IF NOT EXISTS geofences_2026_02_19_15_00 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  fence_type TEXT NOT NULL CHECK (fence_type IN ('CIRCULAR', 'POLYGON', 'RECTANGLE')),
  coordinates JSONB NOT NULL,
  radius DECIMAL(10, 2), -- for circular geofences
  branch_id UUID,
  is_active BOOLEAN DEFAULT true,
  alert_on_enter BOOLEAN DEFAULT true,
  alert_on_exit BOOLEAN DEFAULT true,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Real-time Events and Notifications
CREATE TABLE IF NOT EXISTS realtime_events_2026_02_19_15_00 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type TEXT NOT NULL,
  event_category TEXT NOT NULL CHECK (event_category IN ('GPS', 'QR_SCAN', 'SIGNATURE', 'ROUTE', 'ALERT', 'SYSTEM')),
  reference_id UUID,
  reference_type TEXT,
  user_id UUID,
  device_id TEXT,
  event_data JSONB NOT NULL DEFAULT '{}',
  severity TEXT DEFAULT 'INFO' CHECK (severity IN ('LOW', 'INFO', 'WARNING', 'HIGH', 'CRITICAL')),
  is_processed BOOLEAN DEFAULT false,
  processed_at TIMESTAMPTZ,
  processed_by UUID,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on all tables
ALTER TABLE qr_codes_advanced_2026_02_19_15_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE gps_tracking_advanced_2026_02_19_15_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE electronic_signatures_2026_02_19_15_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE route_optimizations_2026_02_19_15_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE geofences_2026_02_19_15_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE realtime_events_2026_02_19_15_00 ENABLE ROW LEVEL SECURITY;

-- RLS Policies (Allow all for demo)
CREATE POLICY "Allow all operations" ON qr_codes_advanced_2026_02_19_15_00 FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON gps_tracking_advanced_2026_02_19_15_00 FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON electronic_signatures_2026_02_19_15_00 FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON route_optimizations_2026_02_19_15_00 FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON geofences_2026_02_19_15_00 FOR ALL USING (true);
CREATE POLICY "Allow all operations" ON realtime_events_2026_02_19_15_00 FOR ALL USING (true);

-- Indexes for performance
CREATE INDEX idx_qr_codes_reference ON qr_codes_advanced_2026_02_19_15_00(reference_id, reference_type);
CREATE INDEX idx_qr_codes_status ON qr_codes_advanced_2026_02_19_15_00(status);
CREATE INDEX idx_gps_tracking_device ON gps_tracking_advanced_2026_02_19_15_00(device_id, recorded_at);
CREATE INDEX idx_gps_tracking_vehicle ON gps_tracking_advanced_2026_02_19_15_00(vehicle_id, recorded_at);
CREATE INDEX idx_gps_tracking_location ON gps_tracking_advanced_2026_02_19_15_00(latitude, longitude);
CREATE INDEX idx_signatures_reference ON electronic_signatures_2026_02_19_15_00(reference_id, reference_type);
CREATE INDEX idx_routes_vehicle ON route_optimizations_2026_02_19_15_00(vehicle_id, status);
CREATE INDEX idx_events_category ON realtime_events_2026_02_19_15_00(event_category, created_at);
CREATE INDEX idx_events_processed ON realtime_events_2026_02_19_15_00(is_processed, created_at);