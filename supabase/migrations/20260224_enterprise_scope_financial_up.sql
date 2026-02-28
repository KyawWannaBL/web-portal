begin;

-- Add scope_level (S1–S5)
alter table if exists public.roles
add column if not exists scope_level int default 3;

-- Example mapping (adjust as needed)
update public.roles set scope_level = 5 where lower(code::text) in ('super_admin','app_owner');
update public.roles set scope_level = 4 where lower(code::text) in ('regional_manager');
update public.roles set scope_level = 3 where lower(code::text) in ('substation_manager','warehouse_manager');
update public.roles set scope_level = 2 where lower(code::text) in ('supervisor');
update public.roles set scope_level = 1 where lower(code::text) in ('staff','driver','helper','rider');

commit;