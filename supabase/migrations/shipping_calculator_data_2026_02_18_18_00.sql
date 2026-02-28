-- Populate Shipping Calculator Data
-- Current time: 2026-02-18 18:00

-- Insert Myanmar States and Divisions
INSERT INTO public.myanmar_states_divisions_2026_02_18_18_00 (code, name_en, name_mm, type, capital_en, capital_mm, zone_classification, base_rate_multiplier) VALUES
-- Divisions
('YGN', 'Yangon Division', 'ရန်ကုန်တိုင်းဒေသကြီး', 'DIVISION', 'Yangon', 'ရန်ကုန်', 'METRO', 1.00),
('MDY', 'Mandalay Division', 'မန္တလေးတိုင်းဒေသကြီး', 'DIVISION', 'Mandalay', 'မန္တလေး', 'METRO', 1.10),
('NPT', 'Naypyidaw Union Territory', 'နေပြည်တော်ပြည်ထောင်စုနယ်မြေ', 'UNION_TERRITORY', 'Naypyidaw', 'နေပြည်တော်', 'METRO', 1.05),
('SGN', 'Sagaing Division', 'စစ်ကိုင်းတိုင်းဒေသကြီး', 'DIVISION', 'Sagaing', 'စစ်ကိုင်း', 'STANDARD', 1.20),
('MGW', 'Magway Division', 'မကွေးတိုင်းဒေသကြီး', 'DIVISION', 'Magway', 'မကွေး', 'STANDARD', 1.25),
('BTG', 'Bago Division', 'ပဲခူးတိုင်းဒေသကြီး', 'DIVISION', 'Bago', 'ပဲခူး', 'STANDARD', 1.15),
('AYY', 'Ayeyarwady Division', 'ဧရာဝတီတိုင်းဒေသကြီး', 'DIVISION', 'Pathein', 'ပုသိမ်', 'STANDARD', 1.30),
('TNI', 'Tanintharyi Division', 'တနင်္သာရီတိုင်းဒေသကြီး', 'DIVISION', 'Dawei', 'ထားဝယ်', 'REMOTE', 1.40),

-- States
('RKN', 'Rakhine State', 'ရခိုင်ပြည်နယ်', 'STATE', 'Sittwe', 'စစ်တွေ', 'REMOTE', 1.50),
('CHN', 'Chin State', 'ချင်းပြည်နယ်', 'STATE', 'Hakha', 'ဟားခါး', 'REMOTE', 1.60),
('KCN', 'Kachin State', 'ကချင်ပြည်နယ်', 'STATE', 'Myitkyina', 'မြစ်ကြီးနား', 'REMOTE', 1.45),
('SHN', 'Shan State', 'ရှမ်းပြည်နယ်', 'STATE', 'Taunggyi', 'တောင်ကြီး', 'STANDARD', 1.35),
('KYH', 'Kayah State', 'ကယားပြည်နယ်', 'STATE', 'Loikaw', 'လွိုင်ကော်', 'REMOTE', 1.55),
('KRN', 'Kayin State', 'ကရင်ပြည်နယ်', 'STATE', 'Hpa-an', 'ဘားအံ', 'STANDARD', 1.25),
('MON', 'Mon State', 'မွန်ပြည်နယ်', 'STATE', 'Mawlamyine', 'မော်လမြိုင်', 'STANDARD', 1.20);

-- Insert Major Townships for Yangon Division
INSERT INTO public.townships_2026_02_18_18_00 (state_division_id, code, name_en, name_mm, postal_code, delivery_zone, distance_from_capital_km, delivery_time_days, rate_multiplier) VALUES
-- Yangon Division Townships
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'YGN'), 'YGN_BTH', 'Botahtaung', 'ဗိုလ်တထောင်', '11161', 'CITY_CENTER', 5, 1, 1.00),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'YGN'), 'YGN_DGN', 'Dagon', 'ဒဂုံ', '11191', 'CITY_CENTER', 8, 1, 1.00),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'YGN'), 'YGN_KMT', 'Kamayut', 'ကမာရွတ်', '11041', 'CITY_CENTER', 10, 1, 1.00),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'YGN'), 'YGN_KYK', 'Kyauktada', 'ကျောက်တံတား', '11182', 'CITY_CENTER', 3, 1, 1.00),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'YGN'), 'YGN_LTH', 'Latha', 'လသာ', '11131', 'CITY_CENTER', 4, 1, 1.00),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'YGN'), 'YGN_PBD', 'Pabedan', 'ပန်းပဲတန်း', '11143', 'CITY_CENTER', 6, 1, 1.00),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'YGN'), 'YGN_LAN', 'Lanmadaw', 'လမ်းမတော်', '11131', 'CITY_CENTER', 7, 1, 1.00),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'YGN'), 'YGN_AHL', 'Ahlone', 'အလုံ', '11102', 'STANDARD', 12, 1, 1.05),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'YGN'), 'YGN_BHN', 'Bahan', 'ဗဟန်း', '11201', 'STANDARD', 9, 1, 1.00),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'YGN'), 'YGN_DLA', 'Dala', 'ဒလ', '11291', 'STANDARD', 15, 1, 1.10),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'YGN'), 'YGN_ISN', 'Insein', 'အင်းစိန်', '11011', 'SUBURBAN', 20, 1, 1.15),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'YGN'), 'YGN_MGB', 'Mingaladon', 'မင်္ဂလာဒုံ', '11021', 'SUBURBAN', 25, 1, 1.20),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'YGN'), 'YGN_NKL', 'North Okkalapa', 'မြောက်ဥက္ကလာပ', '11031', 'SUBURBAN', 18, 1, 1.10),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'YGN'), 'YGN_SKL', 'South Okkalapa', 'တောင်ဥက္ကလာပ', '11091', 'SUBURBAN', 22, 1, 1.15),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'YGN'), 'YGN_TKT', 'Thaketa', 'သာကေတ', '11101', 'SUBURBAN', 16, 1, 1.10),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'YGN'), 'YGN_YKN', 'Yankin', 'ရန်ကင်း', '11061', 'STANDARD', 14, 1, 1.05),

-- Mandalay Division Townships
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'MDY'), 'MDY_MDY', 'Mandalay', 'မန္တလေး', '05011', 'CITY_CENTER', 0, 1, 1.00),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'MDY'), 'MDY_AMR', 'Amarapura', 'အမရပူရ', '05021', 'STANDARD', 15, 1, 1.10),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'MDY'), 'MDY_PYN', 'Pyin Oo Lwin', 'ပြင်ဦးလွင်', '05081', 'STANDARD', 70, 2, 1.25),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'MDY'), 'MDY_MYG', 'Myingyan', 'မြင်းခြံ', '05151', 'STANDARD', 130, 2, 1.30),

-- Naypyidaw Townships
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'NPT'), 'NPT_ZBT', 'Zabuthiri', 'ဇမ္ဗူသီရိ', '15011', 'CITY_CENTER', 0, 1, 1.00),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'NPT'), 'NPT_DTK', 'Dekkhinathiri', 'ဒက္ခိဏသီရိ', '15021', 'CITY_CENTER', 5, 1, 1.00),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'NPT'), 'NPT_OTR', 'Ottarathiri', 'ဥတ္တရသီရိ', '15031', 'CITY_CENTER', 8, 1, 1.00),
((SELECT id FROM public.myanmar_states_divisions_2026_02_18_18_00 WHERE code = 'NPT'), 'NPT_PBK', 'Pobbathiri', 'ပုဗ္ဗသီရိ', '15041', 'STANDARD', 12, 1, 1.05);

-- Insert International Destinations
INSERT INTO public.international_destinations_2026_02_18_18_00 (country_code, country_name_en, country_name_mm, region, capital_city_en, capital_city_mm, currency_code, zone_category, delivery_time_days, customs_clearance_days, express_available, standard_available, economy_available, cod_available, max_weight_kg) VALUES
-- ASEAN Countries (Zone 1)
('THA', 'Thailand', 'ထိုင်းနိုင်ငံ', 'ASIA', 'Bangkok', 'ဘန်ကောက်', 'THB', 'ZONE_1', 3, 1, true, true, true, false, 50.00),
('SGP', 'Singapore', 'စင်္ကာပူနိုင်ငံ', 'ASIA', 'Singapore', 'စင်္ကာပူ', 'SGD', 'ZONE_1', 2, 1, true, true, true, false, 50.00),
('MYS', 'Malaysia', 'မလေးရှားနိုင်ငံ', 'ASIA', 'Kuala Lumpur', 'ကွာလာလမ်ပူ', 'MYR', 'ZONE_1', 3, 1, true, true, true, false, 50.00),
('IDN', 'Indonesia', 'အင်ဒိုနီးရှားနိုင်ငံ', 'ASIA', 'Jakarta', 'ဂျကာတာ', 'IDR', 'ZONE_1', 4, 2, true, true, true, false, 50.00),
('VNM', 'Vietnam', 'ဗီယက်နမ်နိုင်ငံ', 'ASIA', 'Hanoi', 'ဟနွိုင်း', 'VND', 'ZONE_1', 4, 2, true, true, true, false, 50.00),
('PHL', 'Philippines', 'ဖိလစ်ပိုင်နိုင်ငံ', 'ASIA', 'Manila', 'မနီလာ', 'PHP', 'ZONE_1', 5, 2, true, true, true, false, 50.00),
('LAO', 'Laos', 'လာအိုနိုင်ငံ', 'ASIA', 'Vientiane', 'ဗီယင်ကျန်း', 'LAK', 'ZONE_1', 5, 2, true, true, false, false, 30.00),
('KHM', 'Cambodia', 'ကမ္ဘောဒီးယားနိုင်ငံ', 'ASIA', 'Phnom Penh', 'ဖနွမ်ပင်', 'KHR', 'ZONE_1', 5, 2, true, true, false, false, 30.00),
('BRN', 'Brunei', 'ဘရူနိုင်းနိုင်ငံ', 'ASIA', 'Bandar Seri Begawan', 'ဘန်ဒါဆာရီဘီဂါဝမ်', 'BND', 'ZONE_1', 4, 1, true, true, false, false, 30.00),

-- Major Asian Countries (Zone 2)
('CHN', 'China', 'တရုတ်နိုင်ငံ', 'ASIA', 'Beijing', 'ပေကျင်း', 'CNY', 'ZONE_2', 5, 2, true, true, true, false, 50.00),
('JPN', 'Japan', 'ဂျပန်နိုင်ငံ', 'ASIA', 'Tokyo', 'တိုကျို', 'JPY', 'ZONE_2', 4, 2, true, true, true, false, 50.00),
('KOR', 'South Korea', 'တောင်ကိုရီးယားနိုင်ငံ', 'ASIA', 'Seoul', 'ဆိုးလ်', 'KRW', 'ZONE_2', 4, 2, true, true, true, false, 50.00),
('IND', 'India', 'အိန္ဒိယနိုင်ငံ', 'ASIA', 'New Delhi', 'နယူးဒေလီ', 'INR', 'ZONE_2', 6, 3, true, true, true, false, 50.00),
('BGD', 'Bangladesh', 'ဘင်္ဂလားဒေ့ရှ်နိုင်ငံ', 'ASIA', 'Dhaka', 'ဒါကာ', 'BDT', 'ZONE_2', 7, 3, true, true, false, false, 30.00),
('LKA', 'Sri Lanka', 'သီရိလင်္ကာနိုင်ငံ', 'ASIA', 'Colombo', 'ကိုလံဘို', 'LKR', 'ZONE_2', 6, 2, true, true, false, false, 30.00),
('HKG', 'Hong Kong', 'ဟောင်ကောင်', 'ASIA', 'Hong Kong', 'ဟောင်ကောင်', 'HKD', 'ZONE_2', 3, 1, true, true, true, false, 50.00),
('TWN', 'Taiwan', 'ထိုင်ဝမ်', 'ASIA', 'Taipei', 'တိုင်ပေ', 'TWD', 'ZONE_2', 4, 2, true, true, true, false, 50.00),

-- Middle East (Zone 3)
('ARE', 'United Arab Emirates', 'အာရပ်စော်ဘွားများပြည်ထောင်စု', 'MIDDLE_EAST', 'Abu Dhabi', 'အဘူဒါဘီ', 'AED', 'ZONE_3', 6, 2, true, true, true, false, 50.00),
('SAU', 'Saudi Arabia', 'ဆော်ဒီအာရေးဗီးယားနိုင်ငံ', 'MIDDLE_EAST', 'Riyadh', 'ရီယာ့ဒ်', 'SAR', 'ZONE_3', 7, 3, true, true, false, false, 30.00),
('QAT', 'Qatar', 'ကာတာနိုင်ငံ', 'MIDDLE_EAST', 'Doha', 'ဒိုဟာ', 'QAR', 'ZONE_3', 6, 2, true, true, false, false, 30.00),
('KWT', 'Kuwait', 'ကူဝိတ်နိုင်ငံ', 'MIDDLE_EAST', 'Kuwait City', 'ကူဝိတ်စီးတီး', 'KWD', 'ZONE_3', 7, 3, true, true, false, false, 30.00),

-- Europe (Zone 4)
('GBR', 'United Kingdom', 'ယူနိုက်တက်ကင်းဒမ်းနိုင်ငံ', 'EUROPE', 'London', 'လန်ဒန်', 'GBP', 'ZONE_4', 8, 3, true, true, true, false, 30.00),
('DEU', 'Germany', 'ဂျာမနီနိုင်ငံ', 'EUROPE', 'Berlin', 'ဘာလင်', 'EUR', 'ZONE_4', 9, 3, true, true, true, false, 30.00),
('FRA', 'France', 'ပြင်သစ်နိုင်ငံ', 'EUROPE', 'Paris', 'ပါရီ', 'EUR', 'ZONE_4', 9, 3, true, true, true, false, 30.00),
('ITA', 'Italy', 'အီတလီနိုင်ငံ', 'EUROPE', 'Rome', 'ရောမ', 'EUR', 'ZONE_4', 10, 4, true, true, false, false, 30.00),
('ESP', 'Spain', 'စပိန်နိုင်ငံ', 'EUROPE', 'Madrid', 'မဒရစ်', 'EUR', 'ZONE_4', 10, 4, true, true, false, false, 30.00),
('NLD', 'Netherlands', 'နယ်သာလန်နိုင်ငံ', 'EUROPE', 'Amsterdam', 'အမ်စတာဒမ်', 'EUR', 'ZONE_4', 9, 3, true, true, false, false, 30.00),

-- Americas (Zone 5)
('USA', 'United States', 'အမေရိကန်ပြည်ထောင်စုနိုင်ငံ', 'AMERICAS', 'Washington D.C.', 'ဝါရှင်တန်ဒီစီ', 'USD', 'ZONE_5', 10, 4, true, true, true, false, 30.00),
('CAN', 'Canada', 'ကနေဒါနိုင်ငံ', 'AMERICAS', 'Ottawa', 'အော့တဝါ', 'CAD', 'ZONE_5', 11, 4, true, true, true, false, 30.00),
('BRA', 'Brazil', 'ဘရာဇီးနိုင်ငံ', 'AMERICAS', 'Brasília', 'ဘရာဇီးလီးယား', 'BRL', 'ZONE_5', 14, 5, true, true, false, false, 20.00),
('MEX', 'Mexico', 'မက္ကဆီကိုနိုင်ငံ', 'AMERICAS', 'Mexico City', 'မက္ကဆီကိုစီးတီး', 'MXN', 'ZONE_5', 12, 4, true, true, false, false, 25.00),

-- Oceania (Zone 4)
('AUS', 'Australia', 'ဩစတြေးလျနိုင်ငံ', 'OCEANIA', 'Canberra', 'ကန်ဘာရာ', 'AUD', 'ZONE_4', 8, 3, true, true, true, false, 30.00),
('NZL', 'New Zealand', 'နယူးဇီလန်နိုင်ငံ', 'OCEANIA', 'Wellington', 'ဝယ်လင်တန်', 'NZD', 'ZONE_4', 9, 3, true, true, false, false, 30.00),

-- Africa (Zone 5)
('ZAF', 'South Africa', 'တောင်အာဖရိကနိုင်ငံ', 'AFRICA', 'Cape Town', 'ကိတ်တောင်း', 'ZAR', 'ZONE_5', 12, 5, true, true, false, false, 25.00),
('EGY', 'Egypt', 'အီဂျစ်နိုင်ငံ', 'AFRICA', 'Cairo', 'ကိုင်ရို', 'EGP', 'ZONE_5', 10, 4, true, true, false, false, 25.00);

-- Insert Domestic Shipping Rates
INSERT INTO public.domestic_shipping_rates_2026_02_18_18_00 (service_type, weight_from_kg, weight_to_kg, base_rate_mmk, metro_multiplier, standard_multiplier, remote_multiplier, cod_fee_mmk, cod_percentage, insurance_percentage, fuel_surcharge_percentage, delivery_time_days) VALUES
-- EXPRESS Service
('EXPRESS', 0.00, 0.50, 3000, 1.00, 1.20, 1.50, 2000, 2.00, 1.00, 5.00, 1),
('EXPRESS', 0.51, 1.00, 4000, 1.00, 1.20, 1.50, 2000, 2.00, 1.00, 5.00, 1),
('EXPRESS', 1.01, 2.00, 5500, 1.00, 1.20, 1.50, 2500, 2.00, 1.00, 5.00, 1),
('EXPRESS', 2.01, 5.00, 8000, 1.00, 1.20, 1.50, 3000, 2.00, 1.00, 5.00, 1),
('EXPRESS', 5.01, 10.00, 12000, 1.00, 1.20, 1.50, 3500, 2.00, 1.00, 5.00, 1),
('EXPRESS', 10.01, 20.00, 18000, 1.00, 1.20, 1.50, 4000, 2.00, 1.00, 5.00, 1),
('EXPRESS', 20.01, 50.00, 35000, 1.00, 1.20, 1.50, 5000, 2.00, 1.00, 5.00, 2),

-- STANDARD Service
('STANDARD', 0.00, 0.50, 2000, 1.00, 1.20, 1.50, 1500, 2.00, 1.00, 5.00, 2),
('STANDARD', 0.51, 1.00, 2800, 1.00, 1.20, 1.50, 1500, 2.00, 1.00, 5.00, 2),
('STANDARD', 1.01, 2.00, 4000, 1.00, 1.20, 1.50, 2000, 2.00, 1.00, 5.00, 2),
('STANDARD', 2.01, 5.00, 6000, 1.00, 1.20, 1.50, 2500, 2.00, 1.00, 5.00, 2),
('STANDARD', 5.01, 10.00, 9000, 1.00, 1.20, 1.50, 3000, 2.00, 1.00, 5.00, 2),
('STANDARD', 10.01, 20.00, 14000, 1.00, 1.20, 1.50, 3500, 2.00, 1.00, 5.00, 3),
('STANDARD', 20.01, 50.00, 28000, 1.00, 1.20, 1.50, 4000, 2.00, 1.00, 5.00, 3),

-- ECONOMY Service
('ECONOMY', 0.00, 0.50, 1500, 1.00, 1.20, 1.50, 1000, 2.00, 1.00, 5.00, 3),
('ECONOMY', 0.51, 1.00, 2200, 1.00, 1.20, 1.50, 1000, 2.00, 1.00, 5.00, 3),
('ECONOMY', 1.01, 2.00, 3200, 1.00, 1.20, 1.50, 1500, 2.00, 1.00, 5.00, 3),
('ECONOMY', 2.01, 5.00, 4800, 1.00, 1.20, 1.50, 2000, 2.00, 1.00, 5.00, 4),
('ECONOMY', 5.01, 10.00, 7200, 1.00, 1.20, 1.50, 2500, 2.00, 1.00, 5.00, 4),
('ECONOMY', 10.01, 20.00, 11200, 1.00, 1.20, 1.50, 3000, 2.00, 1.00, 5.00, 5),
('ECONOMY', 20.01, 50.00, 22400, 1.00, 1.20, 1.50, 3500, 2.00, 1.00, 5.00, 5);

-- Insert Air Cargo Specifications
INSERT INTO public.air_cargo_specifications_2026_02_18_18_00 (airline_code, airline_name_en, airline_name_mm, volume_weight_divisor, dimensional_weight_divisor, max_length_cm, max_width_cm, max_height_cm, max_weight_kg, oversized_threshold_cm, oversized_fee_percentage, fragile_handling_fee_usd, destinations_served) VALUES
('MAI', 'Myanmar Airways International', 'မြန်မာ့လေကြောင်းလိုင်းနိုင်ငံတကာ', 6000, 5000, 300, 200, 160, 1000.00, 200, 25.00, 15.00, '["THA", "SGP", "MYS", "CHN", "JPN", "KOR", "IND"]'),
('MNA', 'Myanmar National Airlines', 'မြန်မာ့အမျိုးသားလေကြောင်းလိုင်း', 6000, 5000, 250, 180, 140, 800.00, 180, 20.00, 12.00, '["THA", "SGP", "CHN", "IND"]'),
('AIR', 'Air KBZ', 'အေးကေးဘီးဇက်လေကြောင်းလိုင်း', 5500, 5000, 280, 190, 150, 900.00, 190, 22.00, 13.00, '["THA", "SGP", "MYS", "CHN", "JPN"]'),
('GLD', 'Golden Myanmar Airlines', 'ရွှေမြန်မာလေကြောင်းလိုင်း', 6000, 5500, 270, 185, 145, 850.00, 185, 20.00, 12.00, '["THA", "SGP", "CHN"]'),
('YGN', 'Yangon Airways', 'ရန်ကုန်လေကြောင်းလိုင်း', 6000, 5000, 260, 175, 135, 750.00, 175, 18.00, 10.00, '["THA", "SGP"]'),
('INT', 'International Cargo', 'နိုင်ငံတကာကုန်စည်ပို့ဆောင်ရေး', 5000, 4500, 350, 250, 200, 2000.00, 250, 30.00, 20.00, '["USA", "GBR", "DEU", "FRA", "AUS", "JPN", "CHN", "SGP", "THA"]');

-- Sample calculation to test the function
SELECT public.calculate_domestic_rate_2026_02_18_18_00(
    2.5, -- weight in kg
    (SELECT id FROM public.townships_2026_02_18_18_00 WHERE code = 'YGN_KMT'), -- Kamayut township
    'EXPRESS', -- service type
    50000, -- COD amount
    100000 -- declared value
) as sample_calculation;