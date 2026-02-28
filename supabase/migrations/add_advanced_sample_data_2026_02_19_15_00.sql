-- Sample Data for Advanced Features Testing

-- Sample QR Codes
INSERT INTO qr_codes_advanced_2026_02_19_15_00 (qr_code, qr_type, reference_id, reference_type, data, status) VALUES
('BRT-SHIPMENT-2026-050-151200-12345678', 'SHIPMENT', gen_random_uuid(), 'SHIPMENT', '{"awb": "BRT-2026-001", "destination": "Yangon"}', 'ACTIVE'),
('BRT-PARCEL-2026-050-151201-87654321', 'PARCEL', gen_random_uuid(), 'PARCEL', '{"parcel_id": "PRC-2026-001", "weight": "2.5kg"}', 'ACTIVE'),
('BRT-VEHICLE-2026-050-151202-11223344', 'VEHICLE', gen_random_uuid(), 'VEHICLE', '{"vehicle_number": "YGN-2026-A1", "driver": "Mg Aung"}', 'ACTIVE'),
('BRT-RIDER-2026-050-151203-44332211', 'RIDER', gen_random_uuid(), 'RIDER', '{"rider_id": "RDR-001", "name": "Ko Thant"}', 'ACTIVE'),
('BRT-WAREHOUSE-2026-050-151204-55667788', 'WAREHOUSE', gen_random_uuid(), 'WAREHOUSE', '{"warehouse": "Yangon Central", "section": "A-12"}', 'ACTIVE');

-- Sample GPS Tracking Data
INSERT INTO gps_tracking_advanced_2026_02_19_15_00 (
  device_id, vehicle_id, latitude, longitude, altitude, accuracy, speed, heading, 
  battery_level, signal_strength, address, recorded_at
) VALUES
('DEV-YGN-001', gen_random_uuid(), 16.8661, 96.1951, 15.5, 5.0, 45.2, 180.0, 85, 4, 'Yangon Downtown', NOW() - INTERVAL '5 minutes'),
('DEV-YGN-002', gen_random_uuid(), 16.8551, 96.1851, 12.3, 3.5, 32.1, 90.0, 72, 5, 'Yangon North', NOW() - INTERVAL '3 minutes'),
('DEV-MDY-001', gen_random_uuid(), 21.9588, 96.0891, 76.2, 4.2, 28.7, 270.0, 91, 4, 'Mandalay Center', NOW() - INTERVAL '2 minutes'),
('DEV-NPT-001', gen_random_uuid(), 19.7633, 96.1292, 115.8, 6.1, 0.0, 0.0, 68, 3, 'Naypyidaw Capital', NOW() - INTERVAL '1 minute'),
('DEV-YGN-003', gen_random_uuid(), 16.8761, 96.2051, 18.7, 4.8, 52.3, 45.0, 79, 5, 'Yangon Airport', NOW());

-- Sample Electronic Signatures
INSERT INTO electronic_signatures_2026_02_19_15_00 (
  signature_data, signature_type, reference_id, reference_type, signer_name, 
  signer_phone, verification_status
) VALUES
('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==', 
 'PICKUP', gen_random_uuid(), 'SHIPMENT', 'Daw Mya Mya', '+95-9-123-456-789', 'VERIFIED'),
('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==', 
 'DELIVERY', gen_random_uuid(), 'SHIPMENT', 'U Kyaw Kyaw', '+95-9-987-654-321', 'VERIFIED'),
('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==', 
 'RECEIPT', gen_random_uuid(), 'TRANSACTION', 'Ma Thida', '+95-9-555-666-777', 'PENDING'),
('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==', 
 'AUTHORIZATION', gen_random_uuid(), 'MERCHANT', 'U Tun Tun', '+95-9-111-222-333', 'VERIFIED');

-- Sample Route Optimizations
INSERT INTO route_optimizations_2026_02_19_15_00 (
  route_name, vehicle_id, start_location, waypoints, optimized_sequence, 
  total_distance, estimated_duration, status
) VALUES
('Yangon Morning Route', gen_random_uuid(), 
 '{"lat": 16.8661, "lng": 96.1951, "address": "Yangon Central Depot"}',
 '[{"lat": 16.8561, "lng": 96.1851, "address": "Sule Pagoda"}, {"lat": 16.8761, "lng": 96.2051, "address": "Shwedagon Pagoda"}]',
 '[{"lat": 16.8561, "lng": 96.1851, "address": "Sule Pagoda"}, {"lat": 16.8761, "lng": 96.2051, "address": "Shwedagon Pagoda"}]',
 15.5, 45, 'COMPLETED'),
('Mandalay Express Route', gen_random_uuid(),
 '{"lat": 21.9588, "lng": 96.0891, "address": "Mandalay Hub"}',
 '[{"lat": 21.9688, "lng": 96.0991, "address": "Mandalay Palace"}, {"lat": 21.9488, "lng": 96.0791, "address": "Mandalay Hill"}]',
 '[{"lat": 21.9488, "lng": 96.0791, "address": "Mandalay Hill"}, {"lat": 21.9688, "lng": 96.0991, "address": "Mandalay Palace"}]',
 22.3, 65, 'IN_PROGRESS'),
('Naypyidaw Government Route', gen_random_uuid(),
 '{"lat": 19.7633, "lng": 96.1292, "address": "Naypyidaw Station"}',
 '[{"lat": 19.7733, "lng": 96.1392, "address": "Parliament Complex"}, {"lat": 19.7533, "lng": 96.1192, "address": "City Hall"}]',
 '[{"lat": 19.7533, "lng": 96.1192, "address": "City Hall"}, {"lat": 19.7733, "lng": 96.1392, "address": "Parliament Complex"}]',
 18.7, 55, 'PLANNED');

-- Sample Geofences
INSERT INTO geofences_2026_02_19_15_00 (
  name, description, fence_type, coordinates, radius, is_active, 
  alert_on_enter, alert_on_exit
) VALUES
('Yangon Central Depot', 'Main warehouse and distribution center', 'CIRCULAR', 
 '{"lat": 16.8661, "lng": 96.1951}', 0.5, true, true, true),
('Mandalay Hub', 'Northern region distribution hub', 'CIRCULAR',
 '{"lat": 21.9588, "lng": 96.0891}', 0.8, true, true, true),
('Naypyidaw Government Zone', 'Capital city government delivery area', 'CIRCULAR',
 '{"lat": 19.7633, "lng": 96.1292}', 1.2, true, true, false),
('Yangon Airport Cargo', 'International cargo handling area', 'CIRCULAR',
 '{"lat": 16.8761, "lng": 96.2051}', 0.3, true, true, true),
('Downtown Yangon Restricted', 'City center restricted delivery zone', 'CIRCULAR',
 '{"lat": 16.8561, "lng": 96.1851}', 2.0, true, true, false);

-- Sample Real-time Events
INSERT INTO realtime_events_2026_02_19_15_00 (
  event_type, event_category, reference_id, event_data, severity, created_at
) VALUES
('GPS_UPDATE', 'GPS', gen_random_uuid(), 
 '{"device_id": "DEV-YGN-001", "latitude": 16.8661, "longitude": 96.1951, "speed": 45.2}', 'INFO', NOW() - INTERVAL '2 minutes'),
('QR_CODE_SCANNED', 'QR_SCAN', gen_random_uuid(),
 '{"qr_code": "BRT-SHIPMENT-2026-050-151200-12345678", "scanned_by": "RDR-001", "location": "Yangon"}', 'INFO', NOW() - INTERVAL '5 minutes'),
('SIGNATURE_CAPTURED', 'SIGNATURE', gen_random_uuid(),
 '{"signature_type": "DELIVERY", "signer_name": "U Kyaw Kyaw", "shipment_id": "SHP-001"}', 'INFO', NOW() - INTERVAL '10 minutes'),
('ROUTE_OPTIMIZED', 'ROUTE', gen_random_uuid(),
 '{"route_name": "Yangon Morning Route", "waypoint_count": 2, "total_distance": 15.5}', 'INFO', NOW() - INTERVAL '15 minutes'),
('GEOFENCE_ENTERED', 'ALERT', gen_random_uuid(),
 '{"geofence_name": "Yangon Central Depot", "device_id": "DEV-YGN-001", "vehicle_id": "VEH-001"}', 'WARNING', NOW() - INTERVAL '3 minutes'),
('LOW_BATTERY_ALERT', 'ALERT', gen_random_uuid(),
 '{"device_id": "DEV-NPT-001", "battery_level": 15, "vehicle_id": "VEH-004"}', 'HIGH', NOW() - INTERVAL '1 minute');