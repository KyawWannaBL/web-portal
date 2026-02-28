-- Create comprehensive database structure for public pages data
-- Current time: 2026-02-03 21:00 UTC

-- Services table for service information
CREATE TABLE IF NOT EXISTS public.services_2026_02_03_21_00 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    icon VARCHAR(100),
    category VARCHAR(100),
    features TEXT[], -- Array of features
    is_active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Pricing table for service rates
CREATE TABLE IF NOT EXISTS public.pricing_2026_02_03_21_00 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    service_type VARCHAR(100) NOT NULL, -- 'domestic', 'international'
    region VARCHAR(100) NOT NULL, -- 'yangon', 'mandalay', 'asia', 'europe', etc.
    destination VARCHAR(255) NOT NULL,
    weight_min DECIMAL(10,2) DEFAULT 0,
    weight_max DECIMAL(10,2),
    price_per_kg DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'MMK',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- FAQ table for frequently asked questions
CREATE TABLE IF NOT EXISTS public.faqs_2026_02_03_21_00 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    category VARCHAR(100) DEFAULT 'general',
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Content pages table for static content
CREATE TABLE IF NOT EXISTS public.content_pages_2026_02_03_21_00 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    page_key VARCHAR(100) UNIQUE NOT NULL, -- 'about', 'contact', 'terms', etc.
    title VARCHAR(255) NOT NULL,
    content TEXT,
    meta_description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Prohibited items table
CREATE TABLE IF NOT EXISTS public.prohibited_items_2026_02_03_21_00 (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    item_name VARCHAR(255) NOT NULL,
    description TEXT,
    icon VARCHAR(100),
    category VARCHAR(100) DEFAULT 'general',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert services data
INSERT INTO public.services_2026_02_03_21_00 (name, description, icon, category, features) VALUES
('Domestic Express', 'Connecting Yangon, Mandalay, and Nay Pyi Taw with same-day and next-day options.', 'fas fa-truck-fast', 'domestic', ARRAY['Same-day delivery', 'Next-day delivery', 'Real-time tracking', 'COD available']),
('COD & E-Commerce', 'Secure Cash on Delivery handling with fast remittance for online sellers.', 'fas fa-hand-holding-usd', 'ecommerce', ARRAY['Cash on Delivery', 'Fast remittance', 'Seller dashboard', 'Payment protection']),
('International Cargo', 'Consolidated air cargo to USA, Asia, and Europe. Customs Licensed handling.', 'fas fa-plane-departure', 'international', ARRAY['Air cargo', 'Customs clearance', 'Global network', 'Licensed handling']);

-- Insert domestic pricing data (Yangon zones)
INSERT INTO public.pricing_2026_02_03_21_00 (service_type, region, destination, weight_min, weight_max, price_per_kg, currency) VALUES
-- Zone 1 - Downtown & Inner City (3000 MMK base)
('domestic', 'yangon', 'Ahlone', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Bahan', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Botahtaung', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Dagon', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Dawbon', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Hlaing', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Insein', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Kamaryut', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Kyauktada', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Kyimyindaing', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Lanmataw', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Latha', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Mayangone', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Mingalar Taung Nyunt', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'North Okkalapa', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Pabedan', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Pazundaung', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Sanchaung', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'South Oakkalapa', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Tamwe', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Thaketa', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Thingangyun', 0, 999, 3000, 'MMK'),
('domestic', 'yangon', 'Yankin', 0, 999, 3000, 'MMK'),

-- Zone 2 - Outer City (3500 MMK base)
('domestic', 'yangon', 'Dagon Seikken', 0, 999, 3500, 'MMK'),
('domestic', 'yangon', 'East Dagon', 0, 999, 3500, 'MMK'),
('domestic', 'yangon', 'Hlaing Thar Yar', 0, 999, 3500, 'MMK'),
('domestic', 'yangon', 'Mingalar Don', 0, 999, 3500, 'MMK'),
('domestic', 'yangon', 'North Dagon', 0, 999, 3500, 'MMK'),
('domestic', 'yangon', 'Shwe Paukkan', 0, 999, 3500, 'MMK'),
('domestic', 'yangon', 'Shwe Pyi Thar', 0, 999, 3500, 'MMK'),
('domestic', 'yangon', 'South Dagon', 0, 999, 3500, 'MMK'),

-- Zone 3 - Periphery (4500 MMK base)
('domestic', 'yangon', 'Htauk Kyant', 0, 999, 4500, 'MMK'),
('domestic', 'yangon', 'Hlegu', 0, 999, 4500, 'MMK'),
('domestic', 'yangon', 'Hmawbi', 0, 999, 4500, 'MMK'),
('domestic', 'yangon', 'Lay Daung Kan', 0, 999, 4500, 'MMK'),
('domestic', 'yangon', 'Thanlyin', 0, 999, 4500, 'MMK'),

-- Other cities
('domestic', 'mandalay', 'Mandalay City', 0, 999, 5000, 'MMK'),
('domestic', 'naypyitaw', 'Nay Pyi Taw', 0, 999, 5000, 'MMK');

-- Insert international pricing data
INSERT INTO public.pricing_2026_02_03_21_00 (service_type, region, destination, weight_min, weight_max, price_per_kg, currency) VALUES
-- Asia
('international', 'asia', 'Thailand', 5, 10, 15000, 'MMK'),
('international', 'asia', 'Thailand', 11, 20, 12000, 'MMK'),
('international', 'asia', 'Thailand', 21, 30, 11000, 'MMK'),
('international', 'asia', 'Singapore', 5, 10, 35000, 'MMK'),
('international', 'asia', 'Singapore', 11, 20, 55000, 'MMK'),
('international', 'asia', 'Malaysia', 5, 10, 35000, 'MMK'),
('international', 'asia', 'Japan', 5, 10, 65000, 'MMK'),
('international', 'asia', 'Japan', 21, 30, 35000, 'MMK'),
('international', 'asia', 'Taiwan', 21, 30, 35000, 'MMK'),

-- Europe
('international', 'europe', 'Czech Republic', 3, 10, 120000, 'MMK'),
('international', 'europe', 'Denmark', 5, 10, 15000, 'MMK'),
('international', 'europe', 'Estonia', 5, 10, 35000, 'MMK'),
('international', 'europe', 'Slovakia', 5, 10, 80000, 'MMK'),
('international', 'europe', 'Netherlands', 11, 20, 50000, 'MMK'),
('international', 'europe', 'Poland', 11, 20, 120000, 'MMK'),
('international', 'europe', 'Germany', 21, 30, 11000, 'MMK'),
('international', 'europe', 'Austria', 21, 30, 33000, 'MMK'),
('international', 'europe', 'Belgium', 21, 30, 70000, 'MMK'),

-- Oceania
('international', 'oceania', 'Australia', 5, 10, 95000, 'MMK'),
('international', 'oceania', 'Australia', 11, 20, 75000, 'MMK'),
('international', 'oceania', 'Australia', 21, 30, 70000, 'MMK'),
('international', 'oceania', 'New Zealand', 5, 10, 95000, 'MMK'),
('international', 'oceania', 'New Zealand', 11, 20, 75000, 'MMK'),
('international', 'oceania', 'New Zealand', 21, 30, 70000, 'MMK'),

-- North America
('international', 'north_america', 'USA', 5, 10, 119000, 'MMK'),
('international', 'north_america', 'USA', 11, 20, 95000, 'MMK'),
('international', 'north_america', 'USA', 21, 30, 75000, 'MMK'),
('international', 'north_america', 'Canada', 5, 10, 119000, 'MMK'),
('international', 'north_america', 'Canada', 11, 20, 95000, 'MMK'),
('international', 'north_america', 'Canada', 21, 30, 75000, 'MMK'),
('international', 'north_america', 'Mexico', 5, 10, 119000, 'MMK'),
('international', 'north_america', 'Mexico', 11, 20, 95000, 'MMK'),
('international', 'north_america', 'Mexico', 21, 30, 75000, 'MMK'),

-- Middle East
('international', 'middle_east', 'Israel', 5, 10, 120000, 'MMK'),
('international', 'middle_east', 'Israel', 11, 20, 90000, 'MMK'),
('international', 'middle_east', 'Saudi Arabia', 5, 10, 80000, 'MMK'),
('international', 'middle_east', 'Kuwait', 11, 20, 70000, 'MMK'),
('international', 'middle_east', 'Bahrain', 21, 30, 60000, 'MMK');

-- Insert FAQ data
INSERT INTO public.faqs_2026_02_03_21_00 (question, answer, category, sort_order) VALUES
('How do I track my package?', 'Simply enter your Tracking ID (e.g., BE-12345) on our Homepage or Tracking page. You can track up to 10 numbers at once by separating them with commas.', 'tracking', 1),
('How does Cash on Delivery (COD) work?', 'We collect payment from the receiver upon delivery. The funds are then remitted to the sender''s bank account according to our remittance schedule (usually within 24-48 hours after delivery).', 'payment', 2),
('What are your operating hours?', 'Our hubs in Yangon, Mandalay, and Nay Pyi Taw operate Monday to Saturday, from 9:00 AM to 5:30 PM. We are closed on Sundays and Public Holidays.', 'general', 3),
('What is the maximum weight I can send?', 'For domestic shipments, we accept packages up to 50kg. For international air cargo, weight limits vary by destination. Contact us for specific requirements.', 'shipping', 4),
('How long does delivery take?', 'Domestic express delivery typically takes 1-2 days within major cities. International shipments vary by destination, usually 3-7 business days.', 'delivery', 5),
('Do you provide insurance for shipments?', 'Yes, we offer cargo insurance for high-value items. Insurance coverage and rates depend on the declared value and destination.', 'insurance', 6);

-- Insert prohibited items data
INSERT INTO public.prohibited_items_2026_02_03_21_00 (item_name, description, icon, category) VALUES
('Explosives & Fireworks', 'Any explosive materials, fireworks, or pyrotechnic devices', 'fas fa-bomb', 'dangerous'),
('Flammables', 'Petrol, lighter fluid, paint, aerosols, and other flammable liquids', 'fas fa-fire', 'dangerous'),
('Toxic Substances & Illegal Drugs', 'Poisonous chemicals, illegal drugs, and controlled substances', 'fas fa-skull-crossbones', 'dangerous'),
('Live Animals', 'Live animals without special permits and proper documentation', 'fas fa-paw', 'restricted'),
('Cash & High-Value Bullion', 'Currency, precious metals, and high-value items without proper declaration', 'fas fa-money-bill-wave', 'restricted'),
('Lithium Batteries', 'Loose or damaged lithium batteries (properly packaged devices are allowed)', 'fas fa-battery-full', 'restricted');

-- Insert content pages data
INSERT INTO public.content_pages_2026_02_03_21_00 (page_key, title, content, meta_description) VALUES
('packaging_guide', 'Packaging Best Practices', 'Proper packaging ensures your shipment arrives safely. Follow these 3 steps: 1. Use a new, high-quality corrugated carton. 2. Fill all voids with bubble wrap, foam, or air pillows. 3. Use strong packing tape in H-seal method.', 'Learn how to properly package your shipments for safe delivery with Britium Express'),
('trade_terms', 'Understanding Trade Terms (Incoterms)', 'Incoterms® define who is responsible for the shipping costs and risks. Common terms include EXW (Ex Works), FOB (Free On Board), and CIF (Cost, Insurance & Freight).', 'Understanding international trade terms and Incoterms for shipping with Britium Express'),
('contact_info', 'Contact Information', 'Phone: +95-9-897447744, Email: info@britiumexpress.com, Address: No. 277, Corner of Anawrahta Road and Bo Moe Gyo St., East Dagon Township, Yangon', 'Contact Britium Express for logistics and delivery services in Myanmar');

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_pricing_service_region ON public.pricing_2026_02_03_21_00(service_type, region);
CREATE INDEX IF NOT EXISTS idx_faqs_category ON public.faqs_2026_02_03_21_00(category, sort_order);
CREATE INDEX IF NOT EXISTS idx_services_category ON public.services_2026_02_03_21_00(category, sort_order);
CREATE INDEX IF NOT EXISTS idx_content_pages_key ON public.content_pages_2026_02_03_21_00(page_key);

-- Enable RLS (Row Level Security)
ALTER TABLE public.services_2026_02_03_21_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pricing_2026_02_03_21_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.faqs_2026_02_03_21_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_pages_2026_02_03_21_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.prohibited_items_2026_02_03_21_00 ENABLE ROW LEVEL SECURITY;

-- Create policies for public read access
CREATE POLICY "Public read access for services" ON public.services_2026_02_03_21_00
    FOR SELECT USING (is_active = true);

CREATE POLICY "Public read access for pricing" ON public.pricing_2026_02_03_21_00
    FOR SELECT USING (is_active = true);

CREATE POLICY "Public read access for faqs" ON public.faqs_2026_02_03_21_00
    FOR SELECT USING (is_active = true);

CREATE POLICY "Public read access for content pages" ON public.content_pages_2026_02_03_21_00
    FOR SELECT USING (is_active = true);

CREATE POLICY "Public read access for prohibited items" ON public.prohibited_items_2026_02_03_21_00
    FOR SELECT USING (is_active = true);