-- QR Code tracking and management system
-- Current time: 2026-02-18 17:00

-- Create QR codes table for tracking QR code generation and usage
CREATE TABLE IF NOT EXISTS public.qr_codes_2026_02_18_17_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    qr_data TEXT NOT NULL, -- The data encoded in the QR code (AWB, tracking number, etc.)
    qr_type VARCHAR(50) DEFAULT 'SHIPMENT', -- SHIPMENT, PACKAGE, ASSET, etc.
    shipment_id TEXT, -- Reference to shipment if applicable
    generated_by TEXT, -- User who generated the QR code
    generated_at TIMESTAMPTZ DEFAULT NOW(),
    scan_count INTEGER DEFAULT 0,
    last_scanned_at TIMESTAMPTZ,
    last_scanned_by TEXT,
    is_active BOOLEAN DEFAULT true,
    metadata JSONB DEFAULT '{}', -- Additional data like size, format, etc.
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create QR scan logs table for detailed tracking
CREATE TABLE IF NOT EXISTS public.qr_scan_logs_2026_02_18_17_00 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    qr_code_id UUID REFERENCES public.qr_codes_2026_02_18_17_00(id),
    qr_data TEXT NOT NULL,
    scanned_by TEXT NOT NULL,
    scanned_at TIMESTAMPTZ DEFAULT NOW(),
    scan_location JSONB, -- GPS coordinates if available
    device_info JSONB, -- Browser, device type, etc.
    scan_result VARCHAR(50) DEFAULT 'SUCCESS', -- SUCCESS, ERROR, INVALID
    notes TEXT
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_qr_codes_data ON public.qr_codes_2026_02_18_17_00(qr_data);
CREATE INDEX IF NOT EXISTS idx_qr_codes_shipment ON public.qr_codes_2026_02_18_17_00(shipment_id);
CREATE INDEX IF NOT EXISTS idx_qr_codes_generated_by ON public.qr_codes_2026_02_18_17_00(generated_by);
CREATE INDEX IF NOT EXISTS idx_qr_scan_logs_qr_code ON public.qr_scan_logs_2026_02_18_17_00(qr_code_id);
CREATE INDEX IF NOT EXISTS idx_qr_scan_logs_scanned_by ON public.qr_scan_logs_2026_02_18_17_00(scanned_by);

-- Function to generate or retrieve QR code
CREATE OR REPLACE FUNCTION public.generate_qr_code_2026_02_18_17_00(
    p_qr_data TEXT,
    p_qr_type VARCHAR(50) DEFAULT 'SHIPMENT',
    p_shipment_id TEXT DEFAULT NULL,
    p_generated_by TEXT DEFAULT 'system'
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_qr_id UUID;
BEGIN
    -- Check if QR code already exists
    SELECT id INTO v_qr_id
    FROM public.qr_codes_2026_02_18_17_00
    WHERE qr_data = p_qr_data AND is_active = true;
    
    -- If not exists, create new QR code record
    IF v_qr_id IS NULL THEN
        INSERT INTO public.qr_codes_2026_02_18_17_00 (
            qr_data,
            qr_type,
            shipment_id,
            generated_by
        ) VALUES (
            p_qr_data,
            p_qr_type,
            p_shipment_id,
            p_generated_by
        ) RETURNING id INTO v_qr_id;
    ELSE
        -- Update existing record
        UPDATE public.qr_codes_2026_02_18_17_00
        SET updated_at = NOW()
        WHERE id = v_qr_id;
    END IF;
    
    RETURN v_qr_id;
END;
$$;

-- Function to log QR code scan
CREATE OR REPLACE FUNCTION public.log_qr_scan_2026_02_18_17_00(
    p_qr_data TEXT,
    p_scanned_by TEXT,
    p_scan_location JSONB DEFAULT NULL,
    p_device_info JSONB DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_qr_id UUID;
    v_scan_id UUID;
BEGIN
    -- Find the QR code
    SELECT id INTO v_qr_id
    FROM public.qr_codes_2026_02_18_17_00
    WHERE qr_data = p_qr_data AND is_active = true;
    
    -- If QR code doesn't exist, create it
    IF v_qr_id IS NULL THEN
        v_qr_id := public.generate_qr_code_2026_02_18_17_00(p_qr_data, 'UNKNOWN', NULL, 'scanner');
    END IF;
    
    -- Log the scan
    INSERT INTO public.qr_scan_logs_2026_02_18_17_00 (
        qr_code_id,
        qr_data,
        scanned_by,
        scan_location,
        device_info
    ) VALUES (
        v_qr_id,
        p_qr_data,
        p_scanned_by,
        p_scan_location,
        p_device_info
    ) RETURNING id INTO v_scan_id;
    
    -- Update scan count and last scan info
    UPDATE public.qr_codes_2026_02_18_17_00
    SET 
        scan_count = scan_count + 1,
        last_scanned_at = NOW(),
        last_scanned_by = p_scanned_by,
        updated_at = NOW()
    WHERE id = v_qr_id;
    
    RETURN v_scan_id;
END;
$$;

-- Function to get QR code statistics
CREATE OR REPLACE FUNCTION public.get_qr_stats_2026_02_18_17_00(
    p_user_id TEXT DEFAULT NULL,
    p_days INTEGER DEFAULT 30
)
RETURNS TABLE (
    total_generated BIGINT,
    total_scanned BIGINT,
    unique_scanners BIGINT,
    most_scanned_data TEXT,
    recent_activity JSONB
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    WITH stats AS (
        SELECT 
            COUNT(*) as generated_count,
            SUM(scan_count) as total_scan_count,
            COUNT(DISTINCT last_scanned_by) FILTER (WHERE last_scanned_by IS NOT NULL) as unique_scanner_count
        FROM public.qr_codes_2026_02_18_17_00
        WHERE (p_user_id IS NULL OR generated_by = p_user_id)
        AND generated_at >= NOW() - INTERVAL '1 day' * p_days
    ),
    most_scanned AS (
        SELECT qr_data
        FROM public.qr_codes_2026_02_18_17_00
        WHERE (p_user_id IS NULL OR generated_by = p_user_id)
        AND generated_at >= NOW() - INTERVAL '1 day' * p_days
        ORDER BY scan_count DESC
        LIMIT 1
    ),
    recent AS (
        SELECT jsonb_agg(
            jsonb_build_object(
                'qr_data', qr_data,
                'type', qr_type,
                'generated_at', generated_at,
                'scan_count', scan_count
            ) ORDER BY generated_at DESC
        ) as activity
        FROM public.qr_codes_2026_02_18_17_00
        WHERE (p_user_id IS NULL OR generated_by = p_user_id)
        AND generated_at >= NOW() - INTERVAL '1 day' * p_days
        LIMIT 10
    )
    SELECT 
        s.generated_count,
        s.total_scan_count,
        s.unique_scanner_count,
        ms.qr_data,
        r.activity
    FROM stats s
    CROSS JOIN most_scanned ms
    CROSS JOIN recent r;
END;
$$;

-- Enable RLS
ALTER TABLE public.qr_codes_2026_02_18_17_00 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.qr_scan_logs_2026_02_18_17_00 ENABLE ROW LEVEL SECURITY;

-- RLS Policies for QR codes
CREATE POLICY "Users can view all QR codes" ON public.qr_codes_2026_02_18_17_00
    FOR SELECT USING (true);

CREATE POLICY "Users can insert QR codes" ON public.qr_codes_2026_02_18_17_00
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update their own QR codes" ON public.qr_codes_2026_02_18_17_00
    FOR UPDATE USING (generated_by = auth.uid()::text OR auth.role() = 'authenticated');

-- RLS Policies for QR scan logs
CREATE POLICY "Users can view QR scan logs" ON public.qr_scan_logs_2026_02_18_17_00
    FOR SELECT USING (true);

CREATE POLICY "Users can insert QR scan logs" ON public.qr_scan_logs_2026_02_18_17_00
    FOR INSERT WITH CHECK (true);

-- Insert some sample QR codes for demo
INSERT INTO public.qr_codes_2026_02_18_17_00 (qr_data, qr_type, shipment_id, generated_by, scan_count) VALUES
('LGT-2026-882931', 'SHIPMENT', 'shp_1', 'admin@britiumexpress.com', 5),
('LGT-2026-445672', 'SHIPMENT', 'shp_2', 'ops@britiumexpress.com', 3),
('LGT-2026-334001', 'SHIPMENT', 'shp_5', 'warehouse@britiumexpress.com', 1),
('ASSET-SCANNER-001', 'ASSET', NULL, 'admin@britiumexpress.com', 12),
('VEHICLE-LGT-2026-X1', 'VEHICLE', NULL, 'ops@britiumexpress.com', 8);

-- Insert sample scan logs
INSERT INTO public.qr_scan_logs_2026_02_18_17_00 (qr_code_id, qr_data, scanned_by, scan_result) 
SELECT 
    id,
    qr_data,
    'rider@britiumexpress.com',
    'SUCCESS'
FROM public.qr_codes_2026_02_18_17_00 
WHERE qr_type = 'SHIPMENT'
LIMIT 3;