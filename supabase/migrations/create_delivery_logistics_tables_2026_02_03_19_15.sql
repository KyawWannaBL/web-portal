-- Britium Express Delivery and Logistics System
-- Create comprehensive delivery management tables

-- Shipment status enum
CREATE TYPE shipment_status AS ENUM (
  'pending',
  'pickup_scheduled',
  'picked_up',
  'in_transit',
  'arrived_at_hub',
  'out_for_delivery',
  'delivered',
  'failed_delivery',
  'returned',
  'cancelled'
);

-- Payment status enum
CREATE TYPE payment_status AS ENUM (
  'pending',
  'paid',
  'partial',
  'refunded',
  'disputed'
);

-- Delivery type enum
CREATE TYPE delivery_type AS ENUM (
  'standard',
  'express',
  'same_day',
  'next_day',
  'scheduled'
);

-- Merchants table
CREATE TABLE public.merchants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  merchant_code TEXT UNIQUE NOT NULL,
  business_name TEXT NOT NULL,
  business_type TEXT,
  business_license TEXT,
  tax_id TEXT,
  contact_person TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT NOT NULL,
  address TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  postal_code TEXT,
  bank_account_name TEXT,
  bank_account_number TEXT,
  bank_name TEXT,
  bank_branch TEXT,
  pricing_tier TEXT DEFAULT 'standard',
  commission_rate DECIMAL(5,2) DEFAULT 5.00,
  credit_limit DECIMAL(12,2) DEFAULT 0,
  current_balance DECIMAL(12,2) DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  verification_status TEXT DEFAULT 'pending',
  verified_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Customers table
CREATE TABLE public.customers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  customer_code TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT,
  address TEXT,
  city TEXT,
  state TEXT,
  postal_code TEXT,
  preferred_language TEXT DEFAULT 'en',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Shipments table
CREATE TABLE public.shipments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  way_id TEXT UNIQUE NOT NULL,
  merchant_id UUID NOT NULL REFERENCES public.merchants(id),
  sender_name TEXT NOT NULL,
  sender_phone TEXT NOT NULL,
  sender_address TEXT NOT NULL,
  sender_city TEXT NOT NULL,
  sender_state TEXT NOT NULL,
  receiver_name TEXT NOT NULL,
  receiver_phone TEXT NOT NULL,
  receiver_address TEXT NOT NULL,
  receiver_city TEXT NOT NULL,
  receiver_state TEXT NOT NULL,
  pickup_branch_id UUID REFERENCES public.branches(id),
  delivery_branch_id UUID REFERENCES public.branches(id),
  assigned_rider_id UUID REFERENCES public.users(id),
  package_description TEXT,
  package_weight DECIMAL(8,2),
  package_dimensions JSONB, -- {length, width, height}
  package_value DECIMAL(12,2),
  delivery_type delivery_type DEFAULT 'standard',
  status shipment_status DEFAULT 'pending',
  payment_method TEXT DEFAULT 'cod', -- cod, prepaid, credit
  payment_status payment_status DEFAULT 'pending',
  delivery_fee DECIMAL(10,2) NOT NULL,
  cod_amount DECIMAL(12,2) DEFAULT 0,
  insurance_fee DECIMAL(10,2) DEFAULT 0,
  total_amount DECIMAL(12,2) NOT NULL,
  special_instructions TEXT,
  pickup_date DATE,
  delivery_date DATE,
  estimated_delivery TIMESTAMPTZ,
  actual_pickup_time TIMESTAMPTZ,
  actual_delivery_time TIMESTAMPTZ,
  delivery_attempts INTEGER DEFAULT 0,
  max_delivery_attempts INTEGER DEFAULT 3,
  priority_level INTEGER DEFAULT 1, -- 1=normal, 2=high, 3=urgent
  is_fragile BOOLEAN DEFAULT false,
  requires_signature BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  created_by UUID REFERENCES public.users(id)
);

-- Shipment tracking table
CREATE TABLE public.shipment_tracking (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shipment_id UUID NOT NULL REFERENCES public.shipments(id) ON DELETE CASCADE,
  status shipment_status NOT NULL,
  location TEXT,
  coordinates POINT,
  notes TEXT,
  handled_by UUID REFERENCES public.users(id),
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  is_customer_visible BOOLEAN DEFAULT true
);

-- Delivery routes table
CREATE TABLE public.delivery_routes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  route_name TEXT NOT NULL,
  rider_id UUID NOT NULL REFERENCES public.users(id),
  branch_id UUID NOT NULL REFERENCES public.branches(id),
  route_date DATE NOT NULL,
  start_time TIMESTAMPTZ,
  end_time TIMESTAMPTZ,
  total_shipments INTEGER DEFAULT 0,
  completed_shipments INTEGER DEFAULT 0,
  failed_shipments INTEGER DEFAULT 0,
  total_distance DECIMAL(8,2), -- in kilometers
  estimated_duration INTEGER, -- in minutes
  actual_duration INTEGER, -- in minutes
  status TEXT DEFAULT 'planned', -- planned, in_progress, completed, cancelled
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Route shipments junction table
CREATE TABLE public.route_shipments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  route_id UUID NOT NULL REFERENCES public.delivery_routes(id) ON DELETE CASCADE,
  shipment_id UUID NOT NULL REFERENCES public.shipments(id) ON DELETE CASCADE,
  sequence_order INTEGER NOT NULL,
  estimated_arrival TIMESTAMPTZ,
  actual_arrival TIMESTAMPTZ,
  delivery_status TEXT DEFAULT 'pending',
  delivery_notes TEXT,
  UNIQUE(route_id, shipment_id)
);

-- Pricing rules table
CREATE TABLE public.pricing_rules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  rule_name TEXT NOT NULL,
  from_city TEXT NOT NULL,
  to_city TEXT NOT NULL,
  from_state TEXT NOT NULL,
  to_state TEXT NOT NULL,
  delivery_type delivery_type NOT NULL,
  base_price DECIMAL(10,2) NOT NULL,
  price_per_kg DECIMAL(10,2) DEFAULT 0,
  price_per_km DECIMAL(10,2) DEFAULT 0,
  minimum_charge DECIMAL(10,2) NOT NULL,
  maximum_charge DECIMAL(10,2),
  fuel_surcharge_rate DECIMAL(5,2) DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  effective_from DATE NOT NULL,
  effective_until DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Financial transactions table
CREATE TABLE public.financial_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  transaction_id TEXT UNIQUE NOT NULL,
  transaction_type TEXT NOT NULL, -- payment, refund, commission, settlement
  reference_type TEXT NOT NULL, -- shipment, merchant_settlement, rider_payment
  reference_id UUID NOT NULL,
  merchant_id UUID REFERENCES public.merchants(id),
  user_id UUID REFERENCES public.users(id),
  amount DECIMAL(12,2) NOT NULL,
  currency TEXT DEFAULT 'MMK',
  payment_method TEXT,
  payment_gateway TEXT,
  gateway_transaction_id TEXT,
  status payment_status DEFAULT 'pending',
  description TEXT,
  metadata JSONB,
  processed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- System settings table
CREATE TABLE public.system_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  setting_key TEXT UNIQUE NOT NULL,
  setting_value TEXT NOT NULL,
  setting_type TEXT NOT NULL, -- string, number, boolean, json
  description TEXT,
  is_public BOOLEAN DEFAULT false,
  updated_by UUID REFERENCES public.users(id),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert default system settings
INSERT INTO public.system_settings (setting_key, setting_value, setting_type, description, is_public) VALUES
  ('way_id_length', '6', 'number', 'Length of Way ID trailing number', false),
  ('promotion_code_length', '8', 'number', 'Length of promotion codes', false),
  ('last_pickup_hour', '18', 'number', 'Last pickup hour in 24hr format', false),
  ('last_delivery_hour', '20', 'number', 'Last delivery hour in 24hr format', false),
  ('return_charges_percentage', '15', 'number', 'Return charges as percentage', false),
  ('customer_contact_phone', '+95 9 123 456 789', 'string', 'Customer support phone', true),
  ('max_station_distance', '5000', 'number', 'Maximum station distance in meters', false),
  ('same_day_plan_hour', '14', 'number', 'Same day delivery cut-off hour', false),
  ('auto_assign_deliveryman', 'true', 'boolean', 'Auto assign deliveryman', false),
  ('auto_create_customer', 'true', 'boolean', 'Auto create customer accounts', false),
  ('auto_add_recipient', 'true', 'boolean', 'Auto add recipients to address book', false),
  ('allow_cash_advance', 'false', 'boolean', 'Allow cash advance for merchants', false),
  ('allow_direct_order', 'true', 'boolean', 'Allow merchant direct orders', false),
  ('remind_refund', 'true', 'boolean', 'Remind refund on next pickup', false);

-- Create indexes for performance
CREATE INDEX idx_merchants_user_id ON public.merchants(user_id);
CREATE INDEX idx_merchants_merchant_code ON public.merchants(merchant_code);
CREATE INDEX idx_customers_customer_code ON public.customers(customer_code);
CREATE INDEX idx_shipments_way_id ON public.shipments(way_id);
CREATE INDEX idx_shipments_merchant_id ON public.shipments(merchant_id);
CREATE INDEX idx_shipments_status ON public.shipments(status);
CREATE INDEX idx_shipments_assigned_rider ON public.shipments(assigned_rider_id);
CREATE INDEX idx_shipments_pickup_date ON public.shipments(pickup_date);
CREATE INDEX idx_shipments_delivery_date ON public.shipments(delivery_date);
CREATE INDEX idx_shipment_tracking_shipment_id ON public.shipment_tracking(shipment_id);
CREATE INDEX idx_shipment_tracking_timestamp ON public.shipment_tracking(timestamp);
CREATE INDEX idx_delivery_routes_rider_id ON public.delivery_routes(rider_id);
CREATE INDEX idx_delivery_routes_date ON public.delivery_routes(route_date);
CREATE INDEX idx_financial_transactions_reference ON public.financial_transactions(reference_type, reference_id);
CREATE INDEX idx_financial_transactions_merchant ON public.financial_transactions(merchant_id);
CREATE INDEX idx_system_settings_key ON public.system_settings(setting_key);

-- Enable RLS on all tables
ALTER TABLE public.merchants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shipments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shipment_tracking ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.delivery_routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.route_shipments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pricing_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.financial_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.system_settings ENABLE ROW LEVEL SECURITY;

-- RLS Policies for merchants
CREATE POLICY "Merchants can view their own data" ON public.merchants
  FOR SELECT USING (
    user_id IN (SELECT id FROM public.users WHERE firebase_uid = auth.uid()::text)
  );

CREATE POLICY "Admins can view all merchants" ON public.merchants
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.users u 
      WHERE u.firebase_uid = auth.uid()::text 
      AND u.role IN ('super_admin', 'admin', 'manager')
    )
  );

-- RLS Policies for shipments
CREATE POLICY "Users can view related shipments" ON public.shipments
  FOR SELECT USING (
    merchant_id IN (
      SELECT m.id FROM public.merchants m 
      JOIN public.users u ON m.user_id = u.id 
      WHERE u.firebase_uid = auth.uid()::text
    ) OR
    assigned_rider_id IN (
      SELECT id FROM public.users WHERE firebase_uid = auth.uid()::text
    ) OR
    EXISTS (
      SELECT 1 FROM public.users u 
      WHERE u.firebase_uid = auth.uid()::text 
      AND u.role IN ('super_admin', 'admin', 'manager', 'warehouse_staff')
    )
  );

-- RLS Policies for system settings
CREATE POLICY "Public settings are viewable by all" ON public.system_settings
  FOR SELECT USING (is_public = true OR auth.role() = 'authenticated');

CREATE POLICY "Admins can manage settings" ON public.system_settings
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.users u 
      WHERE u.firebase_uid = auth.uid()::text 
      AND u.role IN ('super_admin', 'admin')
    )
  );

-- Triggers for updated_at
CREATE TRIGGER update_merchants_updated_at BEFORE UPDATE ON public.merchants
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_customers_updated_at BEFORE UPDATE ON public.customers
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_shipments_updated_at BEFORE UPDATE ON public.shipments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_delivery_routes_updated_at BEFORE UPDATE ON public.delivery_routes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_pricing_rules_updated_at BEFORE UPDATE ON public.pricing_rules
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_financial_transactions_updated_at BEFORE UPDATE ON public.financial_transactions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();