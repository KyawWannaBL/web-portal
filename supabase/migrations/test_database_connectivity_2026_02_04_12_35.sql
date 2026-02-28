-- Test database connectivity and verify tables exist
-- Check if system_configuration table exists and has data
SELECT 'system_configuration' as table_name, COUNT(*) as record_count FROM public.system_configuration
UNION ALL
SELECT 'vouchers' as table_name, COUNT(*) as record_count FROM public.vouchers
UNION ALL
SELECT 'cash_advances' as table_name, COUNT(*) as record_count FROM public.cash_advances;

-- Insert a test system configuration if none exists
INSERT INTO public.system_configuration (setting_key, setting_value, setting_type, description)
SELECT 'test_setting', 'test_value', 'string', 'Test configuration entry'
WHERE NOT EXISTS (SELECT 1 FROM public.system_configuration WHERE setting_key = 'test_setting');

-- Show current system configuration
SELECT * FROM public.system_configuration ORDER BY setting_key;