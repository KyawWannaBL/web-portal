-- Check actual table structures first
SELECT 
    table_name,
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public' 
    AND table_name IN ('branches', 'shipments', 'profiles')
ORDER BY table_name, ordinal_position;

-- Check existing data
SELECT 'Existing Branches' as info, COUNT(*) as count FROM public.branches
UNION ALL
SELECT 'Existing Shipments' as info, COUNT(*) as count FROM public.shipments
UNION ALL
SELECT 'Existing Profiles' as info, COUNT(*) as count FROM public.profiles;