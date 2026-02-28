-- Advanced Features Functions (Corrected)
-- QR Code Generation, GPS Tracking, Electronic Signatures, Route Optimization

-- Generate QR Code
CREATE OR REPLACE FUNCTION generate_qr_code_advanced_2026_02_19_15_00(
  p_qr_type TEXT,
  p_reference_id UUID,
  p_reference_type TEXT,
  p_data JSONB DEFAULT '{}',
  p_generated_by UUID DEFAULT NULL
)
RETURNS TABLE(
  success BOOLEAN,
  qr_code TEXT,
  qr_id UUID,
  message TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_qr_code TEXT;
  v_qr_id UUID;
BEGIN
  -- Generate unique QR code
  v_qr_code := 'BRT-' || p_qr_type || '-' || EXTRACT(YEAR FROM NOW()) || '-' || 
               LPAD(EXTRACT(DOY FROM NOW())::TEXT, 3, '0') || '-' || 
               LPAD(EXTRACT(HOUR FROM NOW())::TEXT, 2, '0') || 
               LPAD(EXTRACT(MINUTE FROM NOW())::TEXT, 2, '0') || 
               LPAD(EXTRACT(SECOND FROM NOW())::TEXT, 2, '0') || '-' ||
               SUBSTRING(p_reference_id::TEXT, 1, 8);

  -- Insert QR code record
  INSERT INTO qr_codes_advanced_2026_02_19_15_00 (
    qr_code, qr_type, reference_id, reference_type, data, generated_by
  ) VALUES (
    v_qr_code, p_qr_type, p_reference_id, p_reference_type, p_data, p_generated_by
  ) RETURNING id INTO v_qr_id;

  RETURN QUERY SELECT true, v_qr_code, v_qr_id, 'QR code generated successfully'::TEXT;
EXCEPTION
  WHEN OTHERS THEN
    RETURN QUERY SELECT false, NULL::TEXT, NULL::UUID, SQLERRM::TEXT;
END;
$$;

-- Record GPS Location (Fixed parameter order)
CREATE OR REPLACE FUNCTION record_gps_location_2026_02_19_15_00(
  p_device_id TEXT,
  p_latitude DECIMAL,
  p_longitude DECIMAL,
  p_vehicle_id UUID DEFAULT NULL,
  p_rider_id UUID DEFAULT NULL,
  p_shipment_id UUID DEFAULT NULL,
  p_altitude DECIMAL DEFAULT NULL,
  p_accuracy DECIMAL DEFAULT NULL,
  p_speed DECIMAL DEFAULT NULL,
  p_heading DECIMAL DEFAULT NULL,
  p_battery_level INTEGER DEFAULT NULL,
  p_metadata JSONB DEFAULT '{}'
)
RETURNS TABLE(
  success BOOLEAN,
  location_id UUID,
  message TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_location_id UUID;
BEGIN
  -- Insert GPS tracking record
  INSERT INTO gps_tracking_advanced_2026_02_19_15_00 (
    device_id, latitude, longitude, vehicle_id, rider_id, shipment_id,
    altitude, accuracy, speed, heading, battery_level, metadata
  ) VALUES (
    p_device_id, p_latitude, p_longitude, p_vehicle_id, p_rider_id, p_shipment_id,
    p_altitude, p_accuracy, p_speed, p_heading, p_battery_level, p_metadata
  ) RETURNING id INTO v_location_id;

  RETURN QUERY SELECT true, v_location_id, 'GPS location recorded successfully'::TEXT;
EXCEPTION
  WHEN OTHERS THEN
    RETURN QUERY SELECT false, NULL::UUID, SQLERRM::TEXT;
END;
$$;

-- Save Electronic Signature (Fixed parameter order)
CREATE OR REPLACE FUNCTION save_electronic_signature_2026_02_19_15_00(
  p_signature_data TEXT,
  p_signature_type TEXT,
  p_reference_id UUID,
  p_reference_type TEXT,
  p_signer_name TEXT,
  p_signer_id_number TEXT DEFAULT NULL,
  p_signer_phone TEXT DEFAULT NULL,
  p_signed_by UUID DEFAULT NULL,
  p_metadata JSONB DEFAULT '{}'
)
RETURNS TABLE(
  success BOOLEAN,
  signature_id UUID,
  message TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_signature_id UUID;
BEGIN
  -- Insert signature record
  INSERT INTO electronic_signatures_2026_02_19_15_00 (
    signature_data, signature_type, reference_id, reference_type,
    signer_name, signer_id_number, signer_phone, signed_by, signature_metadata
  ) VALUES (
    p_signature_data, p_signature_type, p_reference_id, p_reference_type,
    p_signer_name, p_signer_id_number, p_signer_phone, p_signed_by, p_metadata
  ) RETURNING id INTO v_signature_id;

  RETURN QUERY SELECT true, v_signature_id, 'Electronic signature saved successfully'::TEXT;
EXCEPTION
  WHEN OTHERS THEN
    RETURN QUERY SELECT false, NULL::UUID, SQLERRM::TEXT;
END;
$$;

-- Scan QR Code (Fixed parameter order)
CREATE OR REPLACE FUNCTION scan_qr_code_2026_02_19_15_00(
  p_qr_code TEXT,
  p_scanned_by UUID DEFAULT NULL,
  p_scan_metadata JSONB DEFAULT '{}'
)
RETURNS TABLE(
  success BOOLEAN,
  qr_data JSONB,
  reference_id UUID,
  reference_type TEXT,
  message TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_qr_record RECORD;
BEGIN
  -- Get QR code record
  SELECT * INTO v_qr_record
  FROM qr_codes_advanced_2026_02_19_15_00
  WHERE qr_code = p_qr_code AND status = 'ACTIVE';

  IF NOT FOUND THEN
    RETURN QUERY SELECT false, NULL::JSONB, NULL::UUID, NULL::TEXT, 'QR code not found or inactive'::TEXT;
    RETURN;
  END IF;

  -- Update scan information
  UPDATE qr_codes_advanced_2026_02_19_15_00
  SET 
    status = 'SCANNED',
    scanned_by = p_scanned_by,
    scanned_at = NOW(),
    scan_count = scan_count + 1,
    metadata = metadata || p_scan_metadata
  WHERE qr_code = p_qr_code;

  RETURN QUERY SELECT 
    true, 
    v_qr_record.data, 
    v_qr_record.reference_id, 
    v_qr_record.reference_type, 
    'QR code scanned successfully'::TEXT;
EXCEPTION
  WHEN OTHERS THEN
    RETURN QUERY SELECT false, NULL::JSONB, NULL::UUID, NULL::TEXT, SQLERRM::TEXT;
END;
$$;