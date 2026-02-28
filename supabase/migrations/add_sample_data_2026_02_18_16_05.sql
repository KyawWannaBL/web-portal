-- Add sample data for testing dashboard functions
-- This creates realistic test data without authentication constraints

-- Ensure we have branches (should already exist)
INSERT INTO public.branches (name, code, address, city, phone, is_active) VALUES
('Yangon Main Hub', 'YGN-HQ', 'No. 123, Strand Road, Yangon', 'Yangon', '+95-1-234567', true),
('Mandalay Branch', 'MDL-01', 'No. 456, 26th Street, Mandalay', 'Mandalay', '+95-2-345678', true),
('Naypyidaw Branch', 'NPT-01', 'No. 789, Thapye Chaung Road, Naypyidaw', 'Naypyidaw', '+95-67-456789', true),
('Mawlamyine Branch', 'MLM-01', 'No. 321, Bogyoke Road, Mawlamyine', 'Mawlamyine', '+95-57-123456', true),
('Taunggyi Branch', 'TGY-01', 'No. 654, Circular Road, Taunggyi', 'Taunggyi', '+95-81-987654', true)
ON CONFLICT (code) DO NOTHING;

-- Clear existing shipments to avoid duplicates
DELETE FROM public.shipments;

-- Add realistic sample shipments with various statuses
INSERT INTO public.shipments (
    tracking_number, 
    sender_name, 
    sender_phone, 
    sender_address, 
    recipient_name, 
    recipient_phone, 
    recipient_address, 
    status, 
    weight, 
    dimensions,
    special_instructions,
    origin_branch_id, 
    destination_branch_id,
    created_at,
    delivered_at
) VALUES
-- Recent deliveries
('BX000001', 'Aung Kyaw', '+95-9-12345678', '123 Shwedagon Pagoda Road, Yangon', 'Ma Thida', '+95-9-87654321', '456 Mandalay Palace Road, Mandalay', 'DELIVERED', 2.5, '30x20x15 cm', 'Handle with care - electronics', 
 (SELECT id FROM public.branches WHERE code = 'YGN-HQ'), (SELECT id FROM public.branches WHERE code = 'MDL-01'), NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day'),

('BX000002', 'Thant Zin', '+95-9-23456789', '789 Bogyoke Market, Yangon', 'Ko Myo', '+95-9-76543210', '321 Shan State Road, Taunggyi', 'DELIVERED', 1.2, '25x15x10 cm', 'Documents - urgent', 
 (SELECT id FROM public.branches WHERE code = 'YGN-HQ'), (SELECT id FROM public.branches WHERE code = 'TGY-01'), NOW() - INTERVAL '3 days', NOW() - INTERVAL '1 day'),

-- In transit shipments
('BX000003', 'Ma Khin', '+95-9-34567890', '456 Sule Pagoda Road, Yangon', 'U Tun Tun', '+95-9-65432109', '789 Capital Road, Naypyidaw', 'IN_TRANSIT', 5.0, '40x30x20 cm', 'Fragile - glassware', 
 (SELECT id FROM public.branches WHERE code = 'YGN-HQ'), (SELECT id FROM public.branches WHERE code = 'NPT-01'), NOW() - INTERVAL '1 day', NULL),

('BX000004', 'Ko Zaw', '+95-9-45678901', '123 University Road, Mandalay', 'Ma Aye', '+95-9-54321098', '456 Thanlwin Bridge, Mawlamyine', 'IN_TRANSIT', 3.8, '35x25x18 cm', 'Books and stationery', 
 (SELECT id FROM public.branches WHERE code = 'MDL-01'), (SELECT id FROM public.branches WHERE code = 'MLM-01'), NOW() - INTERVAL '6 hours', NULL),

-- Processing shipments
('BX000005', 'Daw Mya', '+95-9-56789012', '789 Kandawgyi Lake Road, Yangon', 'U Kyaw', '+95-9-43210987', '321 Inle Lake Road, Taunggyi', 'PROCESSING', 0.8, '20x15x5 cm', 'Medical supplies', 
 (SELECT id FROM public.branches WHERE code = 'YGN-HQ'), (SELECT id FROM public.branches WHERE code = 'TGY-01'), NOW() - INTERVAL '2 hours', NULL),

('BX000006', 'Ko Htet', '+95-9-67890123', '456 Shwemawdaw Pagoda, Bago', 'Ma Su', '+95-9-32109876', '789 Golden Rock, Mon State', 'PROCESSING', 2.1, '28x18x12 cm', 'Traditional crafts', 
 (SELECT id FROM public.branches WHERE code = 'YGN-HQ'), (SELECT id FROM public.branches WHERE code = 'MLM-01'), NOW() - INTERVAL '30 minutes', NULL),

-- Pending shipments
('BX000007', 'U Win', '+95-9-78901234', '123 Ananda Temple Road, Bagan', 'Daw Htay', '+95-9-21098765', '456 Uppatasanti Pagoda, Naypyidaw', 'PENDING', 4.2, '38x28x22 cm', 'Handicrafts for exhibition', 
 (SELECT id FROM public.branches WHERE code = 'MDL-01'), (SELECT id FROM public.branches WHERE code = 'NPT-01'), NOW() - INTERVAL '15 minutes', NULL),

('BX000008', 'Ma Nwe', '+95-9-89012345', '789 Kalaw Hill Station, Shan State', 'Ko Aung', '+95-9-10987654', '321 Chaungtha Beach, Ayeyarwady', 'PENDING', 1.5, '22x16x8 cm', 'Local tea samples', 
 (SELECT id FROM public.branches WHERE code = 'TGY-01'), (SELECT id FROM public.branches WHERE code = 'YGN-HQ'), NOW() - INTERVAL '5 minutes', NULL),

-- Delayed shipment
('BX000009', 'Ko Thura', '+95-9-90123456', '456 Mingun Bell, Sagaing', 'Ma Phyu', '+95-9-09876543', '789 Kyaiktiyo Pagoda, Mon State', 'DELAYED', 6.5, '45x35x25 cm', 'Heavy machinery parts', 
 (SELECT id FROM public.branches WHERE code = 'MDL-01'), (SELECT id FROM public.branches WHERE code = 'MLM-01'), NOW() - INTERVAL '2 days', NULL),

-- More recent shipments for variety
('BX000010', 'Daw Kyi', '+95-9-01234567', '123 Botataung Pagoda, Yangon', 'U Maung', '+95-9-98765432', '456 Mahamuni Pagoda, Mandalay', 'IN_TRANSIT', 3.2, '32x24x16 cm', 'Traditional textiles', 
 (SELECT id FROM public.branches WHERE code = 'YGN-HQ'), (SELECT id FROM public.branches WHERE code = 'MDL-01'), NOW() - INTERVAL '4 hours', NULL),

('BX000011', 'Ko Naing', '+95-9-12345670', '789 Shwezigon Pagoda, Bagan', 'Ma Thin', '+95-9-87654320', '321 Lawkananda Pagoda, Bagan', 'DELIVERED', 0.9, '18x12x6 cm', 'Local delivery - same city', 
 (SELECT id FROM public.branches WHERE code = 'MDL-01'), (SELECT id FROM public.branches WHERE code = 'MDL-01'), NOW() - INTERVAL '1 day', NOW() - INTERVAL '2 hours'),

('BX000012', 'Ma Ei', '+95-9-23456701', '456 Popa Mountain, Mandalay Region', 'Ko Zin', '+95-9-76543201', '789 Ngapali Beach, Rakhine State', 'PROCESSING', 2.8, '30x22x14 cm', 'Beach resort supplies', 
 (SELECT id FROM public.branches WHERE code = 'MDL-01'), (SELECT id FROM public.branches WHERE code = 'YGN-HQ'), NOW() - INTERVAL '1 hour', NULL);

-- Show summary of created data
SELECT 
    'Branches' as data_type,
    COUNT(*) as count
FROM public.branches
WHERE is_active = true
UNION ALL
SELECT 
    'Shipments' as data_type,
    COUNT(*) as count
FROM public.shipments
UNION ALL
SELECT 
    'By Status: ' || status as data_type,
    COUNT(*) as count
FROM public.shipments
GROUP BY status
ORDER BY data_type;