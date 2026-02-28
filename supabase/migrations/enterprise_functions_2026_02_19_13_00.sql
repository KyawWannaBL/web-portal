-- Database Functions and Triggers for Enterprise Logistics Platform
-- Created: 2026-02-19 13:00 UTC

-- =============================================
-- UTILITY FUNCTIONS
-- =============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at triggers to all relevant tables
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles_2026_02_19_13_00 FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_branches_updated_at BEFORE UPDATE ON public.branches_2026_02_19_13_00 FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_customers_updated_at BEFORE UPDATE ON public.customers_2026_02_19_13_00 FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_merchants_updated_at BEFORE UPDATE ON public.merchants_2026_02_19_13_00 FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_shipments_updated_at BEFORE UPDATE ON public.shipments_2026_02_19_13_00 FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_vehicles_updated_at BEFORE UPDATE ON public.vehicles_2026_02_19_13_00 FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_routes_updated_at BEFORE UPDATE ON public.routes_2026_02_19_13_00 FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_deliveries_updated_at BEFORE UPDATE ON public.deliveries_2026_02_19_13_00 FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_transactions_updated_at BEFORE UPDATE ON public.transactions_2026_02_19_13_00 FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_inventory_updated_at BEFORE UPDATE ON public.inventory_2026_02_19_13_00 FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- AWB NUMBER GENERATION
-- =============================================

-- Function to generate AWB numbers
CREATE OR REPLACE FUNCTION generate_awb_number()
RETURNS TEXT AS $$
DECLARE
    new_awb TEXT;
    counter INTEGER;
BEGIN
    -- Get current date in YYYYMMDD format
    SELECT TO_CHAR(NOW(), 'YYYYMMDD') INTO new_awb;
    
    -- Get count of shipments created today
    SELECT COUNT(*) + 1 INTO counter
    FROM public.shipments_2026_02_19_13_00
    WHERE DATE(created_at) = CURRENT_DATE;
    
    -- Format: YYYYMMDD + 6-digit counter (e.g., 20260219000001)
    new_awb := new_awb || LPAD(counter::TEXT, 6, '0');
    
    RETURN new_awb;
END;
$$ LANGUAGE plpgsql;

-- Function to generate customer codes
CREATE OR REPLACE FUNCTION generate_customer_code()
RETURNS TEXT AS $$
DECLARE
    new_code TEXT;
    counter INTEGER;
BEGIN
    -- Get count of customers
    SELECT COUNT(*) + 1 INTO counter
    FROM public.customers_2026_02_19_13_00;
    
    -- Format: CUST + 6-digit counter (e.g., CUST000001)
    new_code := 'CUST' || LPAD(counter::TEXT, 6, '0');
    
    RETURN new_code;
END;
$$ LANGUAGE plpgsql;

-- Function to generate merchant codes
CREATE OR REPLACE FUNCTION generate_merchant_code()
RETURNS TEXT AS $$
DECLARE
    new_code TEXT;
    counter INTEGER;
BEGIN
    -- Get count of merchants
    SELECT COUNT(*) + 1 INTO counter
    FROM public.merchants_2026_02_19_13_00;
    
    -- Format: MERCH + 6-digit counter (e.g., MERCH000001)
    new_code := 'MERCH' || LPAD(counter::TEXT, 6, '0');
    
    RETURN new_code;
END;
$$ LANGUAGE plpgsql;

-- Function to generate transaction numbers
CREATE OR REPLACE FUNCTION generate_transaction_number()
RETURNS TEXT AS $$
DECLARE
    new_number TEXT;
    counter INTEGER;
BEGIN
    -- Get current date in YYYYMMDD format
    SELECT TO_CHAR(NOW(), 'YYYYMMDD') INTO new_number;
    
    -- Get count of transactions created today
    SELECT COUNT(*) + 1 INTO counter
    FROM public.transactions_2026_02_19_13_00
    WHERE DATE(created_at) = CURRENT_DATE;
    
    -- Format: TXN + YYYYMMDD + 4-digit counter (e.g., TXN202602190001)
    new_number := 'TXN' || new_number || LPAD(counter::TEXT, 4, '0');
    
    RETURN new_number;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- AUDIT AND LOGGING FUNCTIONS
-- =============================================

-- Function to log audit events
CREATE OR REPLACE FUNCTION log_audit_event(
    p_user_id UUID,
    p_action VARCHAR(100),
    p_resource_type VARCHAR(100),
    p_resource_id UUID DEFAULT NULL,
    p_old_values JSONB DEFAULT NULL,
    p_new_values JSONB DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    audit_id UUID;
BEGIN
    INSERT INTO public.audit_logs_2026_02_19_13_00 (
        user_id, action, resource_type, resource_id, old_values, new_values
    ) VALUES (
        p_user_id, p_action, p_resource_type, p_resource_id, p_old_values, p_new_values
    ) RETURNING id INTO audit_id;
    
    RETURN audit_id;
END;
$$ LANGUAGE plpgsql;

-- Function to create notification
CREATE OR REPLACE FUNCTION create_notification(
    p_recipient_id UUID,
    p_title VARCHAR(255),
    p_message TEXT,
    p_type VARCHAR(50) DEFAULT 'INFO',
    p_category VARCHAR(50) DEFAULT NULL,
    p_reference_type VARCHAR(50) DEFAULT NULL,
    p_reference_id UUID DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    notification_id UUID;
BEGIN
    INSERT INTO public.notifications_2026_02_19_13_00 (
        recipient_id, title, message, type, category, reference_type, reference_id
    ) VALUES (
        p_recipient_id, p_title, p_message, p_type, p_category, p_reference_type, p_reference_id
    ) RETURNING id INTO notification_id;
    
    RETURN notification_id;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- SHIPMENT MANAGEMENT FUNCTIONS
-- =============================================

-- Function to create shipment with automatic AWB generation
CREATE OR REPLACE FUNCTION create_shipment(
    p_merchant_id UUID,
    p_customer_id UUID,
    p_sender_name VARCHAR(255),
    p_sender_phone VARCHAR(20),
    p_sender_address TEXT,
    p_sender_city VARCHAR(100),
    p_sender_state VARCHAR(100),
    p_receiver_name VARCHAR(255),
    p_receiver_phone VARCHAR(20),
    p_receiver_address TEXT,
    p_receiver_city VARCHAR(100),
    p_receiver_state VARCHAR(100),
    p_package_type VARCHAR(50),
    p_weight DECIMAL(8,2),
    p_dimensions JSONB,
    p_declared_value DECIMAL(12,2),
    p_contents_description TEXT,
    p_service_type VARCHAR(50),
    p_payment_method VARCHAR(50),
    p_cod_amount DECIMAL(12,2),
    p_shipping_cost DECIMAL(10,2),
    p_insurance_cost DECIMAL(10,2),
    p_total_cost DECIMAL(10,2)
)
RETURNS UUID AS $$
DECLARE
    shipment_id UUID;
    awb_number TEXT;
BEGIN
    -- Generate AWB number
    SELECT generate_awb_number() INTO awb_number;
    
    -- Insert shipment
    INSERT INTO public.shipments_2026_02_19_13_00 (
        awb_number, merchant_id, customer_id,
        sender_name, sender_phone, sender_address, sender_city, sender_state,
        receiver_name, receiver_phone, receiver_address, receiver_city, receiver_state,
        package_type, weight, dimensions, declared_value, contents_description,
        service_type, payment_method, cod_amount, shipping_cost, insurance_cost, total_cost
    ) VALUES (
        awb_number, p_merchant_id, p_customer_id,
        p_sender_name, p_sender_phone, p_sender_address, p_sender_city, p_sender_state,
        p_receiver_name, p_receiver_phone, p_receiver_address, p_receiver_city, p_receiver_state,
        p_package_type, p_weight, p_dimensions, p_declared_value, p_contents_description,
        p_service_type, p_payment_method, p_cod_amount, p_shipping_cost, p_insurance_cost, p_total_cost
    ) RETURNING id INTO shipment_id;
    
    -- Create initial tracking entry
    INSERT INTO public.shipment_tracking_2026_02_19_13_00 (
        shipment_id, status, location, notes
    ) VALUES (
        shipment_id, 'CREATED', p_sender_city, 'Shipment created'
    );
    
    RETURN shipment_id;
END;
$$ LANGUAGE plpgsql;

-- Function to update shipment status
CREATE OR REPLACE FUNCTION update_shipment_status(
    p_shipment_id UUID,
    p_status VARCHAR(50),
    p_location VARCHAR(255),
    p_updated_by UUID,
    p_notes TEXT DEFAULT NULL
)
RETURNS BOOLEAN AS $$
BEGIN
    -- Update shipment status
    UPDATE public.shipments_2026_02_19_13_00
    SET status = p_status, current_location = p_location
    WHERE id = p_shipment_id;
    
    -- Add tracking entry
    INSERT INTO public.shipment_tracking_2026_02_19_13_00 (
        shipment_id, status, location, updated_by, notes
    ) VALUES (
        p_shipment_id, p_status, p_location, p_updated_by, p_notes
    );
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- FINANCIAL FUNCTIONS
-- =============================================

-- Function to record COD collection
CREATE OR REPLACE FUNCTION record_cod_collection(
    p_shipment_id UUID,
    p_collected_by UUID,
    p_amount DECIMAL(12,2),
    p_payment_method VARCHAR(50)
)
RETURNS UUID AS $$
DECLARE
    transaction_id UUID;
    transaction_number TEXT;
BEGIN
    -- Generate transaction number
    SELECT generate_transaction_number() INTO transaction_number;
    
    -- Insert transaction
    INSERT INTO public.transactions_2026_02_19_13_00 (
        transaction_number, transaction_type, reference_type, reference_id,
        amount, payment_method, collected_by, status
    ) VALUES (
        transaction_number, 'COD_COLLECTION', 'SHIPMENT', p_shipment_id,
        p_amount, p_payment_method, p_collected_by, 'COMPLETED'
    ) RETURNING id INTO transaction_id;
    
    RETURN transaction_id;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- INVENTORY FUNCTIONS
-- =============================================

-- Function to update inventory
CREATE OR REPLACE FUNCTION update_inventory(
    p_inventory_id UUID,
    p_movement_type VARCHAR(50),
    p_quantity INTEGER,
    p_reference_type VARCHAR(50),
    p_reference_id UUID,
    p_performed_by UUID,
    p_notes TEXT DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    current_stock INTEGER;
    new_stock INTEGER;
BEGIN
    -- Get current stock
    SELECT current_stock INTO current_stock
    FROM public.inventory_2026_02_19_13_00
    WHERE id = p_inventory_id;
    
    -- Calculate new stock based on movement type
    IF p_movement_type = 'IN' THEN
        new_stock := current_stock + p_quantity;
    ELSIF p_movement_type = 'OUT' THEN
        new_stock := current_stock - p_quantity;
        IF new_stock < 0 THEN
            RAISE EXCEPTION 'Insufficient stock. Current: %, Requested: %', current_stock, p_quantity;
        END IF;
    ELSE
        new_stock := current_stock;
    END IF;
    
    -- Update inventory
    UPDATE public.inventory_2026_02_19_13_00
    SET current_stock = new_stock
    WHERE id = p_inventory_id;
    
    -- Record movement
    INSERT INTO public.inventory_movements_2026_02_19_13_00 (
        inventory_id, movement_type, quantity, reference_type, reference_id, performed_by, notes
    ) VALUES (
        p_inventory_id, p_movement_type, p_quantity, p_reference_type, p_reference_id, p_performed_by, p_notes
    );
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- REPORTING FUNCTIONS
-- =============================================

-- Function to get dashboard metrics
CREATE OR REPLACE FUNCTION get_dashboard_metrics(
    p_user_id UUID DEFAULT NULL,
    p_branch_id UUID DEFAULT NULL,
    p_date_from DATE DEFAULT CURRENT_DATE - INTERVAL '30 days',
    p_date_to DATE DEFAULT CURRENT_DATE
)
RETURNS JSONB AS $$
DECLARE
    result JSONB;
    total_shipments INTEGER;
    pending_shipments INTEGER;
    delivered_shipments INTEGER;
    total_revenue DECIMAL(12,2);
    cod_collected DECIMAL(12,2);
    active_vehicles INTEGER;
BEGIN
    -- Get shipment metrics
    SELECT COUNT(*) INTO total_shipments
    FROM public.shipments_2026_02_19_13_00
    WHERE created_at::DATE BETWEEN p_date_from AND p_date_to
    AND (p_branch_id IS NULL OR origin_branch_id = p_branch_id);
    
    SELECT COUNT(*) INTO pending_shipments
    FROM public.shipments_2026_02_19_13_00
    WHERE status IN ('CREATED', 'PICKED_UP', 'IN_TRANSIT')
    AND (p_branch_id IS NULL OR origin_branch_id = p_branch_id);
    
    SELECT COUNT(*) INTO delivered_shipments
    FROM public.shipments_2026_02_19_13_00
    WHERE status = 'DELIVERED'
    AND created_at::DATE BETWEEN p_date_from AND p_date_to
    AND (p_branch_id IS NULL OR origin_branch_id = p_branch_id);
    
    -- Get financial metrics
    SELECT COALESCE(SUM(total_cost), 0) INTO total_revenue
    FROM public.shipments_2026_02_19_13_00
    WHERE created_at::DATE BETWEEN p_date_from AND p_date_to
    AND (p_branch_id IS NULL OR origin_branch_id = p_branch_id);
    
    SELECT COALESCE(SUM(amount), 0) INTO cod_collected
    FROM public.transactions_2026_02_19_13_00
    WHERE transaction_type = 'COD_COLLECTION'
    AND status = 'COMPLETED'
    AND created_at::DATE BETWEEN p_date_from AND p_date_to
    AND (p_branch_id IS NULL OR branch_id = p_branch_id);
    
    -- Get vehicle metrics
    SELECT COUNT(*) INTO active_vehicles
    FROM public.vehicles_2026_02_19_13_00
    WHERE status = 'AVAILABLE'
    AND (p_branch_id IS NULL OR home_branch_id = p_branch_id);
    
    -- Build result JSON
    result := jsonb_build_object(
        'total_shipments', total_shipments,
        'pending_shipments', pending_shipments,
        'delivered_shipments', delivered_shipments,
        'delivery_rate', CASE WHEN total_shipments > 0 THEN ROUND((delivered_shipments::DECIMAL / total_shipments) * 100, 2) ELSE 0 END,
        'total_revenue', total_revenue,
        'cod_collected', cod_collected,
        'active_vehicles', active_vehicles,
        'date_range', jsonb_build_object('from', p_date_from, 'to', p_date_to)
    );
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- SHIPPING RATE CALCULATION FUNCTIONS
-- =============================================

-- Function to calculate domestic shipping rate
CREATE OR REPLACE FUNCTION calculate_domestic_rate(
    p_from_state VARCHAR(100),
    p_to_state VARCHAR(100),
    p_weight DECIMAL(8,2),
    p_service_type VARCHAR(50) DEFAULT 'STANDARD'
)
RETURNS JSONB AS $$
DECLARE
    from_zone VARCHAR(50);
    to_zone VARCHAR(50);
    base_rate DECIMAL(10,2);
    per_kg_rate DECIMAL(10,2);
    remote_surcharge DECIMAL(10,2);
    fuel_surcharge_percent DECIMAL(5,2);
    total_cost DECIMAL(10,2);
    result JSONB;
BEGIN
    -- Get zones for states
    SELECT zone INTO from_zone
    FROM public.myanmar_locations_2026_02_19_13_00
    WHERE state_division = p_from_state
    LIMIT 1;
    
    SELECT zone INTO to_zone
    FROM public.myanmar_locations_2026_02_19_13_00
    WHERE state_division = p_to_state
    LIMIT 1;
    
    -- Get rate information
    SELECT dr.base_rate, dr.per_kg_rate, dr.remote_area_surcharge, dr.fuel_surcharge_percent
    INTO base_rate, per_kg_rate, remote_surcharge, fuel_surcharge_percent
    FROM public.domestic_rates_2026_02_19_13_00 dr
    WHERE dr.from_zone = from_zone
    AND dr.to_zone = to_zone
    AND dr.service_type = p_service_type
    AND p_weight >= dr.weight_from
    AND p_weight <= dr.weight_to
    AND dr.effective_from <= CURRENT_DATE
    AND (dr.effective_to IS NULL OR dr.effective_to >= CURRENT_DATE)
    ORDER BY dr.weight_from DESC
    LIMIT 1;
    
    -- Calculate total cost
    IF base_rate IS NOT NULL THEN
        total_cost := base_rate + (p_weight * per_kg_rate) + remote_surcharge;
        total_cost := total_cost + (total_cost * fuel_surcharge_percent / 100);
        
        result := jsonb_build_object(
            'success', true,
            'base_rate', base_rate,
            'per_kg_rate', per_kg_rate,
            'weight', p_weight,
            'remote_surcharge', remote_surcharge,
            'fuel_surcharge_percent', fuel_surcharge_percent,
            'total_cost', ROUND(total_cost, 2),
            'currency', 'MMK',
            'service_type', p_service_type
        );
    ELSE
        result := jsonb_build_object(
            'success', false,
            'error', 'No rate found for the specified route and weight'
        );
    END IF;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;