-- Shipping Calculator System: Local & International Rates
-- Current time: 2026-02-18 18:00

-- Create Myanmar states and divisions table
CREATE TABLE IF NOT EXISTS public.myanmar_states_divisions_2026_02_18_18_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(10) NOT NULL UNIQUE, -- YGN, MDY, NPT, etc.
    name_en TEXT NOT NULL,
    name_mm TEXT NOT NULL,
    type VARCHAR(20) NOT NULL, -- STATE, DIVISION, UNION_TERRITORY
    capital_en TEXT,
    capital_mm TEXT,
    zone_classification VARCHAR(20) DEFAULT 'STANDARD', -- METRO, STANDARD, REMOTE
    base_rate_multiplier DECIMAL(3,2) DEFAULT 1.00,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create townships table
CREATE TABLE IF NOT EXISTS public.townships_2026_02_18_18_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    state_division_id UUID REFERENCES public.myanmar_states_divisions_2026_02_18_18_00(id),
    code VARCHAR(15) NOT NULL,
    name_en TEXT NOT NULL,
    name_mm TEXT NOT NULL,
    postal_code VARCHAR(10),
    delivery_zone VARCHAR(20) DEFAULT 'STANDARD', -- CITY_CENTER, STANDARD, SUBURBAN, REMOTE
    distance_from_capital_km INTEGER,
    delivery_time_days INTEGER DEFAULT 1,
    rate_multiplier DECIMAL(3,2) DEFAULT 1.00,
    is_cod_available BOOLEAN DEFAULT true,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create international destinations table
CREATE TABLE IF NOT EXISTS public.international_destinations_2026_02_18_18_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    country_code VARCHAR(3) NOT NULL, -- ISO 3166-1 alpha-3
    country_name_en TEXT NOT NULL,
    country_name_mm TEXT NOT NULL,
    region VARCHAR(50), -- ASIA, EUROPE, AMERICAS, AFRICA, OCEANIA
    capital_city_en TEXT,
    capital_city_mm TEXT,
    currency_code VARCHAR(3),
    time_zone VARCHAR(50),
    
    -- Shipping Classifications
    zone_category VARCHAR(20) DEFAULT 'ZONE_3', -- ZONE_1, ZONE_2, ZONE_3, ZONE_4, ZONE_5
    delivery_time_days INTEGER DEFAULT 7,
    customs_clearance_days INTEGER DEFAULT 2,
    
    -- Service Availability
    express_available BOOLEAN DEFAULT true,
    standard_available BOOLEAN DEFAULT true,
    economy_available BOOLEAN DEFAULT false,
    cod_available BOOLEAN DEFAULT false,
    
    -- Restrictions
    restricted_items JSONB DEFAULT '[]',
    prohibited_items JSONB DEFAULT '[]',
    max_weight_kg DECIMAL(8,2) DEFAULT 30.00,
    max_dimensions_cm JSONB DEFAULT '{"length": 120, "width": 80, "height": 80}',
    
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create domestic shipping rates table
CREATE TABLE IF NOT EXISTS public.domestic_shipping_rates_2026_02_18_18_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    service_type VARCHAR(20) NOT NULL, -- EXPRESS, STANDARD, ECONOMY
    
    -- Weight-based rates (MMK)
    weight_from_kg DECIMAL(8,2) NOT NULL,
    weight_to_kg DECIMAL(8,2) NOT NULL,
    base_rate_mmk DECIMAL(10,2) NOT NULL,
    
    -- Zone multipliers
    metro_multiplier DECIMAL(3,2) DEFAULT 1.00,
    standard_multiplier DECIMAL(3,2) DEFAULT 1.20,
    remote_multiplier DECIMAL(3,2) DEFAULT 1.50,
    
    -- Additional charges
    cod_fee_mmk DECIMAL(8,2) DEFAULT 2000,
    cod_percentage DECIMAL(5,2) DEFAULT 2.00,
    insurance_percentage DECIMAL(5,2) DEFAULT 1.00,
    fuel_surcharge_percentage DECIMAL(5,2) DEFAULT 5.00,
    
    -- Delivery time
    delivery_time_days INTEGER DEFAULT 1,
    
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create international shipping rates table
CREATE TABLE IF NOT EXISTS public.international_shipping_rates_2026_02_18_18_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    destination_id UUID REFERENCES public.international_destinations_2026_02_18_18_00(id),
    service_type VARCHAR(20) NOT NULL, -- EXPRESS, STANDARD, ECONOMY
    
    -- Weight-based rates (USD)
    weight_from_kg DECIMAL(8,2) NOT NULL,
    weight_to_kg DECIMAL(8,2) NOT NULL,
    base_rate_usd DECIMAL(10,2) NOT NULL,
    
    -- Volume weight calculation
    volume_weight_divisor INTEGER DEFAULT 5000, -- cm³/kg for air cargo
    min_chargeable_weight_kg DECIMAL(8,2) DEFAULT 0.5,
    
    -- Additional charges
    fuel_surcharge_percentage DECIMAL(5,2) DEFAULT 15.00,
    security_fee_usd DECIMAL(8,2) DEFAULT 5.00,
    customs_clearance_fee_usd DECIMAL(8,2) DEFAULT 25.00,
    remote_area_fee_usd DECIMAL(8,2) DEFAULT 0.00,
    
    -- Insurance and COD
    insurance_percentage DECIMAL(5,2) DEFAULT 2.00,
    max_insurance_usd DECIMAL(10,2) DEFAULT 5000.00,
    
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create air cargo volume calculation table
CREATE TABLE IF NOT EXISTS public.air_cargo_specifications_2026_02_18_18_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    airline_code VARCHAR(10) NOT NULL,
    airline_name_en TEXT NOT NULL,
    airline_name_mm TEXT NOT NULL,
    
    -- Volume weight calculations
    volume_weight_divisor INTEGER DEFAULT 6000, -- Standard IATA: 6000 cm³/kg
    dimensional_weight_divisor INTEGER DEFAULT 5000, -- Some airlines use 5000
    
    -- Size restrictions
    max_length_cm INTEGER DEFAULT 300,
    max_width_cm INTEGER DEFAULT 200,
    max_height_cm INTEGER DEFAULT 160,
    max_weight_kg DECIMAL(8,2) DEFAULT 1000.00,
    
    -- Special handling
    oversized_threshold_cm INTEGER DEFAULT 200,
    oversized_fee_percentage DECIMAL(5,2) DEFAULT 25.00,
    fragile_handling_fee_usd DECIMAL(8,2) DEFAULT 15.00,
    
    -- Routes served
    destinations_served JSONB DEFAULT '[]', -- Array of country codes
    
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create shipping calculation history table
CREATE TABLE IF NOT EXISTS public.shipping_calculations_2026_02_18_18_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT,
    user_type VARCHAR(20), -- CUSTOMER, MERCHANT, RIDER
    
    -- Shipment details
    origin_type VARCHAR(20), -- DOMESTIC, INTERNATIONAL
    origin_location JSONB,
    destination_location JSONB,
    
    -- Package details
    actual_weight_kg DECIMAL(8,2) NOT NULL,
    dimensions_cm JSONB NOT NULL, -- {length, width, height}
    volume_weight_kg DECIMAL(8,2),
    chargeable_weight_kg DECIMAL(8,2),
    
    -- Service selection
    service_type VARCHAR(20),
    airline_code VARCHAR(10),
    
    -- Calculation results
    base_rate DECIMAL(10,2),
    additional_charges JSONB, -- Breakdown of all charges
    total_amount DECIMAL(10,2),
    currency VARCHAR(3),
    
    -- Delivery estimates
    estimated_delivery_days INTEGER,
    estimated_delivery_date DATE,
    
    -- Quote validity
    quote_valid_until TIMESTAMPTZ,
    is_booked BOOLEAN DEFAULT false,
    booking_reference TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_townships_state_division ON public.townships_2026_02_18_18_00(state_division_id);
CREATE INDEX IF NOT EXISTS idx_international_rates_destination ON public.international_shipping_rates_2026_02_18_18_00(destination_id);
CREATE INDEX IF NOT EXISTS idx_domestic_rates_weight ON public.domestic_shipping_rates_2026_02_18_18_00(weight_from_kg, weight_to_kg);
CREATE INDEX IF NOT EXISTS idx_international_rates_weight ON public.international_shipping_rates_2026_02_18_18_00(weight_from_kg, weight_to_kg);
CREATE INDEX IF NOT EXISTS idx_calculations_user ON public.shipping_calculations_2026_02_18_18_00(user_id, created_at DESC);

-- Function to calculate domestic shipping rate
CREATE OR REPLACE FUNCTION public.calculate_domestic_rate_2026_02_18_18_00(
    p_weight_kg DECIMAL,
    p_township_id UUID,
    p_service_type VARCHAR,
    p_cod_amount DECIMAL DEFAULT 0,
    p_declared_value DECIMAL DEFAULT 0
)
RETURNS JSONB
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
    v_township RECORD;
    v_state RECORD;
    v_rate RECORD;
    v_base_rate DECIMAL;
    v_zone_multiplier DECIMAL;
    v_cod_fee DECIMAL := 0;
    v_insurance_fee DECIMAL := 0;
    v_fuel_surcharge DECIMAL;
    v_total DECIMAL;
    v_delivery_days INTEGER;
BEGIN
    -- Get township and state information
    SELECT t.*, s.zone_classification, s.base_rate_multiplier
    INTO v_township, v_state
    FROM public.townships_2026_02_18_18_00 t
    JOIN public.myanmar_states_divisions_2026_02_18_18_00 s ON t.state_division_id = s.id
    WHERE t.id = p_township_id AND t.is_active = true;
    
    IF NOT FOUND THEN
        RETURN jsonb_build_object('error', 'Township not found');
    END IF;
    
    -- Get applicable rate
    SELECT * INTO v_rate
    FROM public.domestic_shipping_rates_2026_02_18_18_00
    WHERE service_type = p_service_type
    AND p_weight_kg >= weight_from_kg 
    AND p_weight_kg <= weight_to_kg
    AND is_active = true
    ORDER BY weight_from_kg DESC
    LIMIT 1;
    
    IF NOT FOUND THEN
        RETURN jsonb_build_object('error', 'No rate found for this weight');
    END IF;
    
    -- Calculate base rate
    v_base_rate := v_rate.base_rate_mmk;
    
    -- Apply zone multiplier
    v_zone_multiplier := CASE v_state.zone_classification
        WHEN 'METRO' THEN v_rate.metro_multiplier
        WHEN 'STANDARD' THEN v_rate.standard_multiplier
        WHEN 'REMOTE' THEN v_rate.remote_multiplier
        ELSE 1.00
    END;
    
    v_base_rate := v_base_rate * v_zone_multiplier * v_township.rate_multiplier;
    
    -- Calculate COD fee
    IF p_cod_amount > 0 THEN
        v_cod_fee := GREATEST(v_rate.cod_fee_mmk, p_cod_amount * v_rate.cod_percentage / 100);
    END IF;
    
    -- Calculate insurance fee
    IF p_declared_value > 0 THEN
        v_insurance_fee := p_declared_value * v_rate.insurance_percentage / 100;
    END IF;
    
    -- Calculate fuel surcharge
    v_fuel_surcharge := v_base_rate * v_rate.fuel_surcharge_percentage / 100;
    
    -- Calculate total
    v_total := v_base_rate + v_cod_fee + v_insurance_fee + v_fuel_surcharge;
    
    -- Calculate delivery time
    v_delivery_days := v_rate.delivery_time_days + COALESCE(v_township.delivery_time_days, 0);
    
    RETURN jsonb_build_object(
        'base_rate', v_base_rate,
        'zone_multiplier', v_zone_multiplier,
        'cod_fee', v_cod_fee,
        'insurance_fee', v_insurance_fee,
        'fuel_surcharge', v_fuel_surcharge,
        'total_amount', v_total,
        'currency', 'MMK',
        'delivery_days', v_delivery_days,
        'service_type', p_service_type,
        'destination', jsonb_build_object(
            'township', v_township.name_en,
            'township_mm', v_township.name_mm,
            'zone', v_state.zone_classification
        )
    );
END;
$$;

-- Function to calculate international shipping rate
CREATE OR REPLACE FUNCTION public.calculate_international_rate_2026_02_18_18_00(
    p_actual_weight_kg DECIMAL,
    p_length_cm DECIMAL,
    p_width_cm DECIMAL,
    p_height_cm DECIMAL,
    p_destination_id UUID,
    p_service_type VARCHAR,
    p_airline_code VARCHAR DEFAULT NULL,
    p_declared_value_usd DECIMAL DEFAULT 0
)
RETURNS JSONB
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
    v_destination RECORD;
    v_rate RECORD;
    v_airline RECORD;
    v_volume_cm3 DECIMAL;
    v_volume_weight_kg DECIMAL;
    v_chargeable_weight_kg DECIMAL;
    v_base_rate DECIMAL;
    v_fuel_surcharge DECIMAL;
    v_security_fee DECIMAL;
    v_customs_fee DECIMAL;
    v_insurance_fee DECIMAL := 0;
    v_oversized_fee DECIMAL := 0;
    v_total DECIMAL;
    v_delivery_days INTEGER;
BEGIN
    -- Get destination information
    SELECT * INTO v_destination
    FROM public.international_destinations_2026_02_18_18_00
    WHERE id = p_destination_id AND is_active = true;
    
    IF NOT FOUND THEN
        RETURN jsonb_build_object('error', 'Destination not found');
    END IF;
    
    -- Get rate information
    SELECT * INTO v_rate
    FROM public.international_shipping_rates_2026_02_18_18_00
    WHERE destination_id = p_destination_id
    AND service_type = p_service_type
    AND p_actual_weight_kg >= weight_from_kg 
    AND p_actual_weight_kg <= weight_to_kg
    AND is_active = true
    ORDER BY weight_from_kg DESC
    LIMIT 1;
    
    IF NOT FOUND THEN
        RETURN jsonb_build_object('error', 'No rate found for this destination and weight');
    END IF;
    
    -- Get airline specifications if provided
    IF p_airline_code IS NOT NULL THEN
        SELECT * INTO v_airline
        FROM public.air_cargo_specifications_2026_02_18_18_00
        WHERE airline_code = p_airline_code AND is_active = true;
    END IF;
    
    -- Calculate volume weight
    v_volume_cm3 := p_length_cm * p_width_cm * p_height_cm;
    v_volume_weight_kg := v_volume_cm3 / COALESCE(v_airline.volume_weight_divisor, v_rate.volume_weight_divisor);
    
    -- Determine chargeable weight (higher of actual or volume weight)
    v_chargeable_weight_kg := GREATEST(
        p_actual_weight_kg, 
        v_volume_weight_kg, 
        v_rate.min_chargeable_weight_kg
    );
    
    -- Calculate base rate
    v_base_rate := v_rate.base_rate_usd * v_chargeable_weight_kg;
    
    -- Calculate additional charges
    v_fuel_surcharge := v_base_rate * v_rate.fuel_surcharge_percentage / 100;
    v_security_fee := v_rate.security_fee_usd;
    v_customs_fee := v_rate.customs_clearance_fee_usd;
    
    -- Calculate insurance fee
    IF p_declared_value_usd > 0 THEN
        v_insurance_fee := LEAST(
            p_declared_value_usd * v_rate.insurance_percentage / 100,
            v_rate.max_insurance_usd
        );
    END IF;
    
    -- Calculate oversized fee if applicable
    IF v_airline.id IS NOT NULL AND (
        p_length_cm > v_airline.oversized_threshold_cm OR
        p_width_cm > v_airline.oversized_threshold_cm OR
        p_height_cm > v_airline.oversized_threshold_cm
    ) THEN
        v_oversized_fee := v_base_rate * v_airline.oversized_fee_percentage / 100;
    END IF;
    
    -- Calculate total
    v_total := v_base_rate + v_fuel_surcharge + v_security_fee + v_customs_fee + 
               v_insurance_fee + v_oversized_fee + v_rate.remote_area_fee_usd;
    
    -- Calculate delivery time
    v_delivery_days := v_destination.delivery_time_days + v_destination.customs_clearance_days;
    
    RETURN jsonb_build_object(
        'actual_weight_kg', p_actual_weight_kg,
        'volume_weight_kg', v_volume_weight_kg,
        'chargeable_weight_kg', v_chargeable_weight_kg,
        'base_rate', v_base_rate,
        'fuel_surcharge', v_fuel_surcharge,
        'security_fee', v_security_fee,
        'customs_fee', v_customs_fee,
        'insurance_fee', v_insurance_fee,
        'oversized_fee', v_oversized_fee,
        'remote_area_fee', v_rate.remote_area_fee_usd,
        'total_amount', v_total,
        'currency', 'USD',
        'delivery_days', v_delivery_days,
        'service_type', p_service_type,
        'airline_used', COALESCE(v_airline.airline_name_en, 'Standard Air Cargo'),
        'destination', jsonb_build_object(
            'country', v_destination.country_name_en,
            'country_mm', v_destination.country_name_mm,
            'zone', v_destination.zone_category
        )
    );
END;
$$;

-- Enable RLS
ALTER TABLE public.myanmar_states_divisions_2026_02_18_18_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.townships_2026_02_18_18_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.international_destinations_2026_02_18_18_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.domestic_shipping_rates_2026_02_18_18_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.international_shipping_rates_2026_02_18_18_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.air_cargo_specifications_2026_02_18_18_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shipping_calculations_2026_02_18_18_00 ENABLE ROW LEVEL SECURITY;

-- RLS Policies (permissive for demo)
CREATE POLICY "Allow all operations" ON public.myanmar_states_divisions_2026_02_18_18_00 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.townships_2026_02_18_18_00 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.international_destinations_2026_02_18_18_00 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.domestic_shipping_rates_2026_02_18_18_00 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.international_shipping_rates_2026_02_18_18_00 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.air_cargo_specifications_2026_02_18_18_00 FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations" ON public.shipping_calculations_2026_02_18_18_00 FOR ALL USING (true) WITH CHECK (true);