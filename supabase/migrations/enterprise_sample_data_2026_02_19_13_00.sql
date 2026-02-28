-- Sample Data for Enterprise Logistics Platform
-- Created: 2026-02-19 13:00 UTC

-- =============================================
-- MYANMAR LOCATIONS DATA
-- =============================================

-- Insert Myanmar States/Divisions and Townships
INSERT INTO public.myanmar_locations_2026_02_19_13_00 (state_division, township, postal_code, zone, is_remote) VALUES
-- Yangon Region (Zone 1 - Major cities)
('Yangon', 'Yangon', '11111', 'ZONE_1', false),
('Yangon', 'Insein', '11112', 'ZONE_1', false),
('Yangon', 'Mingaladon', '11113', 'ZONE_1', false),
('Yangon', 'Shwepyitha', '11114', 'ZONE_1', false),
('Yangon', 'Hlegu', '11115', 'ZONE_1', false),
('Yangon', 'Hmawbi', '11116', 'ZONE_1', false),
('Yangon', 'Htantabin', '11117', 'ZONE_1', false),
('Yangon', 'Taikkyi', '11118', 'ZONE_1', false),

-- Mandalay Region (Zone 1 - Major cities)
('Mandalay', 'Mandalay', '05111', 'ZONE_1', false),
('Mandalay', 'Amarapura', '05112', 'ZONE_1', false),
('Mandalay', 'Patheingyi', '05113', 'ZONE_1', false),
('Mandalay', 'Pyigyidagun', '05114', 'ZONE_1', false),
('Mandalay', 'Mahaaungmye', '05115', 'ZONE_1', false),
('Mandalay', 'Chanayethazan', '05116', 'ZONE_1', false),
('Mandalay', 'Chanmyathazi', '05117', 'ZONE_1', false),

-- Naypyidaw (Zone 1 - Capital)
('Naypyidaw', 'Naypyidaw', '15111', 'ZONE_1', false),
('Naypyidaw', 'Lewe', '15112', 'ZONE_1', false),
('Naypyidaw', 'Pyinmana', '15113', 'ZONE_1', false),
('Naypyidaw', 'Tatkon', '15114', 'ZONE_1', false),

-- Ayeyarwady Region (Zone 2 - Regional centers)
('Ayeyarwady', 'Pathein', '10111', 'ZONE_2', false),
('Ayeyarwady', 'Myaungmya', '10112', 'ZONE_2', false),
('Ayeyarwady', 'Hinthada', '10113', 'ZONE_2', false),
('Ayeyarwady', 'Pyapon', '10114', 'ZONE_2', false),
('Ayeyarwady', 'Bogale', '10115', 'ZONE_2', false),
('Ayeyarwady', 'Maubin', '10116', 'ZONE_2', false),

-- Bago Region (Zone 2)
('Bago', 'Bago', '12111', 'ZONE_2', false),
('Bago', 'Pyay', '12112', 'ZONE_2', false),
('Bago', 'Taungoo', '12113', 'ZONE_2', false),
('Bago', 'Tharyarwady', '12114', 'ZONE_2', false),
('Bago', 'Nyaunglebin', '12115', 'ZONE_2', false),

-- Mon State (Zone 2)
('Mon', 'Mawlamyine', '13111', 'ZONE_2', false),
('Mon', 'Thaton', '13112', 'ZONE_2', false),
('Mon', 'Kyaikmaraw', '13113', 'ZONE_2', false),
('Mon', 'Paung', '13114', 'ZONE_2', false),

-- Kayin State (Zone 3 - Remote areas)
('Kayin', 'Hpa-an', '14111', 'ZONE_3', true),
('Kayin', 'Myawaddy', '14112', 'ZONE_3', true),
('Kayin', 'Kawkareik', '14113', 'ZONE_3', true),
('Kayin', 'Thandaunggyi', '14114', 'ZONE_3', true),

-- Kayah State (Zone 3 - Remote areas)
('Kayah', 'Loikaw', '08111', 'ZONE_3', true),
('Kayah', 'Demoso', '08112', 'ZONE_3', true),
('Kayah', 'Hpruso', '08113', 'ZONE_3', true),

-- Chin State (Zone 3 - Remote mountainous)
('Chin', 'Hakha', '03111', 'ZONE_3', true),
('Chin', 'Falam', '03112', 'ZONE_3', true),
('Chin', 'Tedim', '03113', 'ZONE_3', true),
('Chin', 'Tonzang', '03114', 'ZONE_3', true),

-- Kachin State (Zone 3 - Remote northern)
('Kachin', 'Myitkyina', '01111', 'ZONE_3', true),
('Kachin', 'Bhamo', '01112', 'ZONE_3', true),
('Kachin', 'Mohnyin', '01113', 'ZONE_3', true),
('Kachin', 'Putao', '01114', 'ZONE_3', true),

-- Shan State (Zone 2-3 mixed)
('Shan', 'Taunggyi', '06111', 'ZONE_2', false),
('Shan', 'Lashio', '06112', 'ZONE_2', false),
('Shan', 'Kengtung', '06113', 'ZONE_3', true),
('Shan', 'Muse', '06114', 'ZONE_3', true),
('Shan', 'Kyaing Tong', '06115', 'ZONE_3', true),

-- Rakhine State (Zone 2-3 mixed)
('Rakhine', 'Sittwe', '07111', 'ZONE_2', false),
('Rakhine', 'Kyaukpyu', '07112', 'ZONE_2', false),
('Rakhine', 'Mrauk-U', '07113', 'ZONE_3', true),
('Rakhine', 'Maungdaw', '07114', 'ZONE_3', true),

-- Sagaing Region (Zone 2-3 mixed)
('Sagaing', 'Sagaing', '04111', 'ZONE_2', false),
('Sagaing', 'Monywa', '04112', 'ZONE_2', false),
('Sagaing', 'Shwebo', '04113', 'ZONE_2', false),
('Sagaing', 'Katha', '04114', 'ZONE_3', true),
('Sagaing', 'Banmauk', '04115', 'ZONE_3', true),

-- Magway Region (Zone 2)
('Magway', 'Magway', '02111', 'ZONE_2', false),
('Magway', 'Pakokku', '02112', 'ZONE_2', false),
('Magway', 'Minbu', '02113', 'ZONE_2', false),
('Magway', 'Chauk', '02114', 'ZONE_2', false),

-- Tanintharyi Region (Zone 3 - Southern remote)
('Tanintharyi', 'Dawei', '09111', 'ZONE_3', true),
('Tanintharyi', 'Myeik', '09112', 'ZONE_3', true),
('Tanintharyi', 'Kawthoung', '09113', 'ZONE_3', true),
('Tanintharyi', 'Bokpyin', '09114', 'ZONE_3', true);

-- =============================================
-- DOMESTIC SHIPPING RATES
-- =============================================

-- Zone 1 to Zone 1 (Major cities)
INSERT INTO public.domestic_rates_2026_02_19_13_00 (from_zone, to_zone, service_type, weight_from, weight_to, base_rate, per_kg_rate, remote_area_surcharge, fuel_surcharge_percent, effective_from) VALUES
('ZONE_1', 'ZONE_1', 'STANDARD', 0.0, 1.0, 2000, 0, 0, 5.0, '2026-01-01'),
('ZONE_1', 'ZONE_1', 'STANDARD', 1.0, 5.0, 2500, 500, 0, 5.0, '2026-01-01'),
('ZONE_1', 'ZONE_1', 'STANDARD', 5.0, 10.0, 4000, 300, 0, 5.0, '2026-01-01'),
('ZONE_1', 'ZONE_1', 'STANDARD', 10.0, 20.0, 5500, 200, 0, 5.0, '2026-01-01'),
('ZONE_1', 'ZONE_1', 'EXPRESS', 0.0, 1.0, 3000, 0, 0, 5.0, '2026-01-01'),
('ZONE_1', 'ZONE_1', 'EXPRESS', 1.0, 5.0, 3500, 700, 0, 5.0, '2026-01-01'),
('ZONE_1', 'ZONE_1', 'EXPRESS', 5.0, 10.0, 5500, 400, 0, 5.0, '2026-01-01'),
('ZONE_1', 'ZONE_1', 'EXPRESS', 10.0, 20.0, 7500, 300, 0, 5.0, '2026-01-01'),

-- Zone 1 to Zone 2 (Major to Regional)
('ZONE_1', 'ZONE_2', 'STANDARD', 0.0, 1.0, 3000, 0, 0, 5.0, '2026-01-01'),
('ZONE_1', 'ZONE_2', 'STANDARD', 1.0, 5.0, 3500, 600, 0, 5.0, '2026-01-01'),
('ZONE_1', 'ZONE_2', 'STANDARD', 5.0, 10.0, 5500, 400, 0, 5.0, '2026-01-01'),
('ZONE_1', 'ZONE_2', 'STANDARD', 10.0, 20.0, 7500, 300, 0, 5.0, '2026-01-01'),
('ZONE_1', 'ZONE_2', 'EXPRESS', 0.0, 1.0, 4000, 0, 0, 5.0, '2026-01-01'),
('ZONE_1', 'ZONE_2', 'EXPRESS', 1.0, 5.0, 4500, 800, 0, 5.0, '2026-01-01'),
('ZONE_1', 'ZONE_2', 'EXPRESS', 5.0, 10.0, 7000, 500, 0, 5.0, '2026-01-01'),
('ZONE_1', 'ZONE_2', 'EXPRESS', 10.0, 20.0, 9500, 400, 0, 5.0, '2026-01-01'),

-- Zone 1 to Zone 3 (Major to Remote)
('ZONE_1', 'ZONE_3', 'STANDARD', 0.0, 1.0, 4000, 0, 1000, 8.0, '2026-01-01'),
('ZONE_1', 'ZONE_3', 'STANDARD', 1.0, 5.0, 4500, 800, 1000, 8.0, '2026-01-01'),
('ZONE_1', 'ZONE_3', 'STANDARD', 5.0, 10.0, 7000, 600, 1000, 8.0, '2026-01-01'),
('ZONE_1', 'ZONE_3', 'STANDARD', 10.0, 20.0, 10000, 500, 1000, 8.0, '2026-01-01'),
('ZONE_1', 'ZONE_3', 'EXPRESS', 0.0, 1.0, 5500, 0, 1500, 8.0, '2026-01-01'),
('ZONE_1', 'ZONE_3', 'EXPRESS', 1.0, 5.0, 6000, 1000, 1500, 8.0, '2026-01-01'),
('ZONE_1', 'ZONE_3', 'EXPRESS', 5.0, 10.0, 9000, 700, 1500, 8.0, '2026-01-01'),
('ZONE_1', 'ZONE_3', 'EXPRESS', 10.0, 20.0, 12500, 600, 1500, 8.0, '2026-01-01'),

-- Zone 2 to Zone 1 (Regional to Major)
('ZONE_2', 'ZONE_1', 'STANDARD', 0.0, 1.0, 3000, 0, 0, 5.0, '2026-01-01'),
('ZONE_2', 'ZONE_1', 'STANDARD', 1.0, 5.0, 3500, 600, 0, 5.0, '2026-01-01'),
('ZONE_2', 'ZONE_1', 'STANDARD', 5.0, 10.0, 5500, 400, 0, 5.0, '2026-01-01'),
('ZONE_2', 'ZONE_1', 'STANDARD', 10.0, 20.0, 7500, 300, 0, 5.0, '2026-01-01'),
('ZONE_2', 'ZONE_1', 'EXPRESS', 0.0, 1.0, 4000, 0, 0, 5.0, '2026-01-01'),
('ZONE_2', 'ZONE_1', 'EXPRESS', 1.0, 5.0, 4500, 800, 0, 5.0, '2026-01-01'),
('ZONE_2', 'ZONE_1', 'EXPRESS', 5.0, 10.0, 7000, 500, 0, 5.0, '2026-01-01'),
('ZONE_2', 'ZONE_1', 'EXPRESS', 10.0, 20.0, 9500, 400, 0, 5.0, '2026-01-01'),

-- Zone 2 to Zone 2 (Regional to Regional)
('ZONE_2', 'ZONE_2', 'STANDARD', 0.0, 1.0, 2500, 0, 0, 5.0, '2026-01-01'),
('ZONE_2', 'ZONE_2', 'STANDARD', 1.0, 5.0, 3000, 500, 0, 5.0, '2026-01-01'),
('ZONE_2', 'ZONE_2', 'STANDARD', 5.0, 10.0, 4500, 350, 0, 5.0, '2026-01-01'),
('ZONE_2', 'ZONE_2', 'STANDARD', 10.0, 20.0, 6000, 250, 0, 5.0, '2026-01-01'),
('ZONE_2', 'ZONE_2', 'EXPRESS', 0.0, 1.0, 3500, 0, 0, 5.0, '2026-01-01'),
('ZONE_2', 'ZONE_2', 'EXPRESS', 1.0, 5.0, 4000, 700, 0, 5.0, '2026-01-01'),
('ZONE_2', 'ZONE_2', 'EXPRESS', 5.0, 10.0, 6000, 450, 0, 5.0, '2026-01-01'),
('ZONE_2', 'ZONE_2', 'EXPRESS', 10.0, 20.0, 8000, 350, 0, 5.0, '2026-01-01'),

-- Zone 2 to Zone 3 (Regional to Remote)
('ZONE_2', 'ZONE_3', 'STANDARD', 0.0, 1.0, 3500, 0, 800, 8.0, '2026-01-01'),
('ZONE_2', 'ZONE_3', 'STANDARD', 1.0, 5.0, 4000, 700, 800, 8.0, '2026-01-01'),
('ZONE_2', 'ZONE_3', 'STANDARD', 5.0, 10.0, 6000, 500, 800, 8.0, '2026-01-01'),
('ZONE_2', 'ZONE_3', 'STANDARD', 10.0, 20.0, 8500, 400, 800, 8.0, '2026-01-01'),
('ZONE_2', 'ZONE_3', 'EXPRESS', 0.0, 1.0, 5000, 0, 1200, 8.0, '2026-01-01'),
('ZONE_2', 'ZONE_3', 'EXPRESS', 1.0, 5.0, 5500, 900, 1200, 8.0, '2026-01-01'),
('ZONE_2', 'ZONE_3', 'EXPRESS', 5.0, 10.0, 8000, 650, 1200, 8.0, '2026-01-01'),
('ZONE_2', 'ZONE_3', 'EXPRESS', 10.0, 20.0, 11000, 550, 1200, 8.0, '2026-01-01'),

-- Zone 3 to Zone 1 (Remote to Major)
('ZONE_3', 'ZONE_1', 'STANDARD', 0.0, 1.0, 4000, 0, 1000, 8.0, '2026-01-01'),
('ZONE_3', 'ZONE_1', 'STANDARD', 1.0, 5.0, 4500, 800, 1000, 8.0, '2026-01-01'),
('ZONE_3', 'ZONE_1', 'STANDARD', 5.0, 10.0, 7000, 600, 1000, 8.0, '2026-01-01'),
('ZONE_3', 'ZONE_1', 'STANDARD', 10.0, 20.0, 10000, 500, 1000, 8.0, '2026-01-01'),
('ZONE_3', 'ZONE_1', 'EXPRESS', 0.0, 1.0, 5500, 0, 1500, 8.0, '2026-01-01'),
('ZONE_3', 'ZONE_1', 'EXPRESS', 1.0, 5.0, 6000, 1000, 1500, 8.0, '2026-01-01'),
('ZONE_3', 'ZONE_1', 'EXPRESS', 5.0, 10.0, 9000, 700, 1500, 8.0, '2026-01-01'),
('ZONE_3', 'ZONE_1', 'EXPRESS', 10.0, 20.0, 12500, 600, 1500, 8.0, '2026-01-01'),

-- Zone 3 to Zone 2 (Remote to Regional)
('ZONE_3', 'ZONE_2', 'STANDARD', 0.0, 1.0, 3500, 0, 800, 8.0, '2026-01-01'),
('ZONE_3', 'ZONE_2', 'STANDARD', 1.0, 5.0, 4000, 700, 800, 8.0, '2026-01-01'),
('ZONE_3', 'ZONE_2', 'STANDARD', 5.0, 10.0, 6000, 500, 800, 8.0, '2026-01-01'),
('ZONE_3', 'ZONE_2', 'STANDARD', 10.0, 20.0, 8500, 400, 800, 8.0, '2026-01-01'),
('ZONE_3', 'ZONE_2', 'EXPRESS', 0.0, 1.0, 5000, 0, 1200, 8.0, '2026-01-01'),
('ZONE_3', 'ZONE_2', 'EXPRESS', 1.0, 5.0, 5500, 900, 1200, 8.0, '2026-01-01'),
('ZONE_3', 'ZONE_2', 'EXPRESS', 5.0, 10.0, 8000, 650, 1200, 8.0, '2026-01-01'),
('ZONE_3', 'ZONE_2', 'EXPRESS', 10.0, 20.0, 11000, 550, 1200, 8.0, '2026-01-01'),

-- Zone 3 to Zone 3 (Remote to Remote)
('ZONE_3', 'ZONE_3', 'STANDARD', 0.0, 1.0, 3000, 0, 1500, 10.0, '2026-01-01'),
('ZONE_3', 'ZONE_3', 'STANDARD', 1.0, 5.0, 3500, 600, 1500, 10.0, '2026-01-01'),
('ZONE_3', 'ZONE_3', 'STANDARD', 5.0, 10.0, 5500, 450, 1500, 10.0, '2026-01-01'),
('ZONE_3', 'ZONE_3', 'STANDARD', 10.0, 20.0, 7500, 350, 1500, 10.0, '2026-01-01'),
('ZONE_3', 'ZONE_3', 'EXPRESS', 0.0, 1.0, 4500, 0, 2000, 10.0, '2026-01-01'),
('ZONE_3', 'ZONE_3', 'EXPRESS', 1.0, 5.0, 5000, 800, 2000, 10.0, '2026-01-01'),
('ZONE_3', 'ZONE_3', 'EXPRESS', 5.0, 10.0, 7500, 600, 2000, 10.0, '2026-01-01'),
('ZONE_3', 'ZONE_3', 'EXPRESS', 10.0, 20.0, 10000, 500, 2000, 10.0, '2026-01-01');

-- =============================================
-- INTERNATIONAL SHIPPING RATES
-- =============================================

INSERT INTO public.international_rates_2026_02_19_13_00 (destination_country, destination_zone, service_type, weight_from, weight_to, base_rate, per_kg_rate, customs_clearance_fee, fuel_surcharge_percent, currency, effective_from) VALUES
-- Thailand
('Thailand', 'ASEAN', 'STANDARD', 0.0, 1.0, 25.00, 0, 5.00, 10.0, 'USD', '2026-01-01'),
('Thailand', 'ASEAN', 'STANDARD', 1.0, 5.0, 30.00, 8.00, 5.00, 10.0, 'USD', '2026-01-01'),
('Thailand', 'ASEAN', 'STANDARD', 5.0, 10.0, 55.00, 6.00, 5.00, 10.0, 'USD', '2026-01-01'),
('Thailand', 'ASEAN', 'EXPRESS', 0.0, 1.0, 35.00, 0, 8.00, 10.0, 'USD', '2026-01-01'),
('Thailand', 'ASEAN', 'EXPRESS', 1.0, 5.0, 40.00, 12.00, 8.00, 10.0, 'USD', '2026-01-01'),
('Thailand', 'ASEAN', 'EXPRESS', 5.0, 10.0, 75.00, 9.00, 8.00, 10.0, 'USD', '2026-01-01'),

-- Singapore
('Singapore', 'ASEAN', 'STANDARD', 0.0, 1.0, 30.00, 0, 8.00, 12.0, 'USD', '2026-01-01'),
('Singapore', 'ASEAN', 'STANDARD', 1.0, 5.0, 35.00, 10.00, 8.00, 12.0, 'USD', '2026-01-01'),
('Singapore', 'ASEAN', 'STANDARD', 5.0, 10.0, 65.00, 7.50, 8.00, 12.0, 'USD', '2026-01-01'),
('Singapore', 'ASEAN', 'EXPRESS', 0.0, 1.0, 45.00, 0, 12.00, 12.0, 'USD', '2026-01-01'),
('Singapore', 'ASEAN', 'EXPRESS', 1.0, 5.0, 50.00, 15.00, 12.00, 12.0, 'USD', '2026-01-01'),
('Singapore', 'ASEAN', 'EXPRESS', 5.0, 10.0, 90.00, 11.00, 12.00, 12.0, 'USD', '2026-01-01'),

-- China
('China', 'ASIA', 'STANDARD', 0.0, 1.0, 35.00, 0, 10.00, 15.0, 'USD', '2026-01-01'),
('China', 'ASIA', 'STANDARD', 1.0, 5.0, 40.00, 12.00, 10.00, 15.0, 'USD', '2026-01-01'),
('China', 'ASIA', 'STANDARD', 5.0, 10.0, 75.00, 8.50, 10.00, 15.0, 'USD', '2026-01-01'),
('China', 'ASIA', 'EXPRESS', 0.0, 1.0, 50.00, 0, 15.00, 15.0, 'USD', '2026-01-01'),
('China', 'ASIA', 'EXPRESS', 1.0, 5.0, 55.00, 18.00, 15.00, 15.0, 'USD', '2026-01-01'),
('China', 'ASIA', 'EXPRESS', 5.0, 10.0, 105.00, 13.00, 15.00, 15.0, 'USD', '2026-01-01'),

-- India
('India', 'ASIA', 'STANDARD', 0.0, 1.0, 28.00, 0, 8.00, 12.0, 'USD', '2026-01-01'),
('India', 'ASIA', 'STANDARD', 1.0, 5.0, 33.00, 9.00, 8.00, 12.0, 'USD', '2026-01-01'),
('India', 'ASIA', 'STANDARD', 5.0, 10.0, 60.00, 7.00, 8.00, 12.0, 'USD', '2026-01-01'),
('India', 'ASIA', 'EXPRESS', 0.0, 1.0, 42.00, 0, 12.00, 12.0, 'USD', '2026-01-01'),
('India', 'ASIA', 'EXPRESS', 1.0, 5.0, 47.00, 14.00, 12.00, 12.0, 'USD', '2026-01-01'),
('India', 'ASIA', 'EXPRESS', 5.0, 10.0, 82.00, 10.50, 12.00, 12.0, 'USD', '2026-01-01'),

-- United States
('United States', 'AMERICAS', 'STANDARD', 0.0, 1.0, 55.00, 0, 25.00, 20.0, 'USD', '2026-01-01'),
('United States', 'AMERICAS', 'STANDARD', 1.0, 5.0, 65.00, 22.00, 25.00, 20.0, 'USD', '2026-01-01'),
('United States', 'AMERICAS', 'STANDARD', 5.0, 10.0, 125.00, 18.00, 25.00, 20.0, 'USD', '2026-01-01'),
('United States', 'AMERICAS', 'EXPRESS', 0.0, 1.0, 85.00, 0, 35.00, 20.0, 'USD', '2026-01-01'),
('United States', 'AMERICAS', 'EXPRESS', 1.0, 5.0, 95.00, 32.00, 35.00, 20.0, 'USD', '2026-01-01'),
('United States', 'AMERICAS', 'EXPRESS', 5.0, 10.0, 175.00, 25.00, 35.00, 20.0, 'USD', '2026-01-01'),

-- United Kingdom
('United Kingdom', 'EUROPE', 'STANDARD', 0.0, 1.0, 50.00, 0, 20.00, 18.0, 'USD', '2026-01-01'),
('United Kingdom', 'EUROPE', 'STANDARD', 1.0, 5.0, 60.00, 20.00, 20.00, 18.0, 'USD', '2026-01-01'),
('United Kingdom', 'EUROPE', 'STANDARD', 5.0, 10.0, 115.00, 16.00, 20.00, 18.0, 'USD', '2026-01-01'),
('United Kingdom', 'EUROPE', 'EXPRESS', 0.0, 1.0, 75.00, 0, 30.00, 18.0, 'USD', '2026-01-01'),
('United Kingdom', 'EUROPE', 'EXPRESS', 1.0, 5.0, 85.00, 28.00, 30.00, 18.0, 'USD', '2026-01-01'),
('United Kingdom', 'EUROPE', 'EXPRESS', 5.0, 10.0, 155.00, 22.00, 30.00, 18.0, 'USD', '2026-01-01'),

-- Australia
('Australia', 'OCEANIA', 'STANDARD', 0.0, 1.0, 45.00, 0, 15.00, 15.0, 'USD', '2026-01-01'),
('Australia', 'OCEANIA', 'STANDARD', 1.0, 5.0, 55.00, 18.00, 15.00, 15.0, 'USD', '2026-01-01'),
('Australia', 'OCEANIA', 'STANDARD', 5.0, 10.0, 105.00, 14.00, 15.00, 15.0, 'USD', '2026-01-01'),
('Australia', 'OCEANIA', 'EXPRESS', 0.0, 1.0, 70.00, 0, 25.00, 15.0, 'USD', '2026-01-01'),
('Australia', 'OCEANIA', 'EXPRESS', 1.0, 5.0, 80.00, 26.00, 25.00, 15.0, 'USD', '2026-01-01'),
('Australia', 'OCEANIA', 'EXPRESS', 5.0, 10.0, 145.00, 20.00, 25.00, 15.0, 'USD', '2026-01-01');

-- =============================================
-- BRANCHES DATA
-- =============================================

INSERT INTO public.branches_2026_02_19_13_00 (name, code, type, address, city, state, postal_code, phone, email, operating_hours, capacity_info, facilities, status) VALUES
('Yangon Main Hub', 'YGN001', 'HUB', 'No. 123, Strand Road, Kyauktada Township', 'Yangon', 'Yangon', '11111', '+95-1-2345678', 'yangon@britiumexpress.com', '{"monday": "08:00-18:00", "tuesday": "08:00-18:00", "wednesday": "08:00-18:00", "thursday": "08:00-18:00", "friday": "08:00-18:00", "saturday": "08:00-16:00", "sunday": "closed"}', '{"daily_capacity": 5000, "storage_area": "10000 sqm", "loading_bays": 20}', '["sorting_facility", "warehouse", "customer_service", "pickup_counter", "parking"]', 'ACTIVE'),

('Mandalay Regional Center', 'MDL001', 'SORTING_CENTER', 'No. 456, 26th Street, Chan Aye Thar Zan Township', 'Mandalay', 'Mandalay', '05111', '+95-2-3456789', 'mandalay@britiumexpress.com', '{"monday": "08:00-18:00", "tuesday": "08:00-18:00", "wednesday": "08:00-18:00", "thursday": "08:00-18:00", "friday": "08:00-18:00", "saturday": "08:00-16:00", "sunday": "closed"}', '{"daily_capacity": 3000, "storage_area": "6000 sqm", "loading_bays": 12}', '["sorting_facility", "warehouse", "customer_service", "pickup_counter"]', 'ACTIVE'),

('Naypyidaw Branch', 'NPT001', 'BRANCH', 'No. 789, Thapye Chaung Road, Zabuthiri Township', 'Naypyidaw', 'Naypyidaw', '15111', '+95-67-456789', 'naypyidaw@britiumexpress.com', '{"monday": "08:00-17:00", "tuesday": "08:00-17:00", "wednesday": "08:00-17:00", "thursday": "08:00-17:00", "friday": "08:00-17:00", "saturday": "08:00-15:00", "sunday": "closed"}', '{"daily_capacity": 1500, "storage_area": "3000 sqm", "loading_bays": 6}', '["customer_service", "pickup_counter", "parking"]', 'ACTIVE'),

('Pathein Branch', 'PTH001', 'BRANCH', 'No. 321, Merchant Street, Pathein Township', 'Pathein', 'Ayeyarwady', '10111', '+95-42-567890', 'pathein@britiumexpress.com', '{"monday": "08:00-17:00", "tuesday": "08:00-17:00", "wednesday": "08:00-17:00", "thursday": "08:00-17:00", "friday": "08:00-17:00", "saturday": "08:00-15:00", "sunday": "closed"}', '{"daily_capacity": 800, "storage_area": "1500 sqm", "loading_bays": 4}', '["customer_service", "pickup_counter"]', 'ACTIVE'),

('Mawlamyine Branch', 'MWL001', 'BRANCH', 'No. 654, Bogyoke Road, Mawlamyine Township', 'Mawlamyine', 'Mon', '13111', '+95-57-678901', 'mawlamyine@britiumexpress.com', '{"monday": "08:00-17:00", "tuesday": "08:00-17:00", "wednesday": "08:00-17:00", "thursday": "08:00-17:00", "friday": "08:00-17:00", "saturday": "08:00-15:00", "sunday": "closed"}', '{"daily_capacity": 600, "storage_area": "1200 sqm", "loading_bays": 3}', '["customer_service", "pickup_counter"]', 'ACTIVE'),

('Taunggyi Branch', 'TGY001', 'BRANCH', 'No. 987, Circular Road, Taunggyi Township', 'Taunggyi', 'Shan', '06111', '+95-81-789012', 'taunggyi@britiumexpress.com', '{"monday": "08:00-17:00", "tuesday": "08:00-17:00", "wednesday": "08:00-17:00", "thursday": "08:00-17:00", "friday": "08:00-17:00", "saturday": "08:00-15:00", "sunday": "closed"}', '{"daily_capacity": 500, "storage_area": "1000 sqm", "loading_bays": 2}', '["customer_service", "pickup_counter"]', 'ACTIVE');

-- =============================================
-- DEMO USERS DATA
-- =============================================

-- Get branch IDs for reference
DO $$
DECLARE
    yangon_branch_id UUID;
    mandalay_branch_id UUID;
    naypyidaw_branch_id UUID;
BEGIN
    SELECT id INTO yangon_branch_id FROM public.branches_2026_02_19_13_00 WHERE code = 'YGN001';
    SELECT id INTO mandalay_branch_id FROM public.branches_2026_02_19_13_00 WHERE code = 'MDL001';
    SELECT id INTO naypyidaw_branch_id FROM public.branches_2026_02_19_13_00 WHERE code = 'NPT001';

    -- Insert demo profiles
    INSERT INTO public.profiles_2026_02_19_13_00 (email, full_name, phone, role, department, branch_id, employee_id, status, permissions, address, hire_date, performance_metrics) VALUES
    ('admin@britiumexpress.com', 'Thant Zin Oo', '+95-9-123456789', 'SYSTEM_ADMINISTRATOR', 'IT', yangon_branch_id, 'EMP001', 'ACTIVE', '{"all": true}', 'No. 123, University Avenue, Bahan Township, Yangon', '2024-01-15', '{"efficiency": 95, "accuracy": 98}'),
    
    ('supervisor@britiumexpress.com', 'Khin Myo Thant', '+95-9-234567890', 'SUPERVISOR', 'Operations', yangon_branch_id, 'EMP002', 'ACTIVE', '{"operations": true, "reports": true, "audit": true}', 'No. 456, Golden Valley, Bahan Township, Yangon', '2024-02-01', '{"efficiency": 92, "accuracy": 96}'),
    
    ('rider@britiumexpress.com', 'Aung Kyaw Moe', '+95-9-345678901', 'RIDER', 'Delivery', yangon_branch_id, 'EMP003', 'ACTIVE', '{"delivery": true, "tracking": true}', 'No. 789, Hlaing Township, Yangon', '2024-03-10', '{"efficiency": 88, "accuracy": 94, "deliveries_completed": 1250}'),
    
    ('merchant@britiumexpress.com', 'Golden Shop Co., Ltd.', '+95-9-456789012', 'MERCHANT', 'Sales', yangon_branch_id, 'MERCH001', 'ACTIVE', '{"shipments": true, "tracking": true, "reports": true}', 'No. 321, Scott Market, Pabedan Township, Yangon', '2024-01-20', '{"monthly_volume": 450, "revenue": 2500000}'),
    
    ('customer@britiumexpress.com', 'Ma Thandar Soe', '+95-9-567890123', 'CUSTOMER', NULL, NULL, 'CUST001', 'ACTIVE', '{"tracking": true}', 'No. 654, Sanchaung Township, Yangon', NULL, '{}'),
    
    ('warehouse@britiumexpress.com', 'Ko Zaw Min Htut', '+95-9-678901234', 'WAREHOUSE_STAFF', 'Warehouse', yangon_branch_id, 'EMP004', 'ACTIVE', '{"inventory": true, "receiving": true, "dispatch": true}', 'No. 987, Insein Township, Yangon', '2024-02-15', '{"efficiency": 90, "accuracy": 97}'),
    
    ('finance@britiumexpress.com', 'Daw Khin Sandar Win', '+95-9-789012345', 'FINANCE_STAFF', 'Finance', yangon_branch_id, 'EMP005', 'ACTIVE', '{"finance": true, "reports": true, "settlements": true}', 'No. 147, Kamayut Township, Yangon', '2024-01-25', '{"efficiency": 94, "accuracy": 99}'),
    
    ('manager.mandalay@britiumexpress.com', 'U Thura Aung', '+95-9-890123456', 'BRANCH_MANAGER', 'Management', mandalay_branch_id, 'EMP006', 'ACTIVE', '{"branch_management": true, "reports": true, "staff": true}', 'No. 258, 35th Street, Mahaaungmye Township, Mandalay', '2024-01-10', '{"efficiency": 93, "accuracy": 97}'),
    
    ('rider.mandalay@britiumexpress.com', 'Ko Myo Min Thant', '+95-9-901234567', 'RIDER', 'Delivery', mandalay_branch_id, 'EMP007', 'ACTIVE', '{"delivery": true, "tracking": true}', 'No. 369, 84th Street, Chanayethazan Township, Mandalay', '2024-03-05', '{"efficiency": 87, "accuracy": 93, "deliveries_completed": 890}'),
    
    ('hr@britiumexpress.com', 'Daw Nilar Thant', '+95-9-012345678', 'HR_ADMIN', 'Human Resources', yangon_branch_id, 'EMP008', 'ACTIVE', '{"hr": true, "users": true, "reports": true}', 'No. 741, Mayangone Township, Yangon', '2024-01-30', '{"efficiency": 91, "accuracy": 96}');

END $$;