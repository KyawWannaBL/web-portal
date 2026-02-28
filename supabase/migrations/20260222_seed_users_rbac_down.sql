begin;

-- Remove user_permissions granted from roles for seeded emails
delete from public.user_permissions up
using public.permissions perm
where up.permission_id = perm.id
  and up.user_id in (
    select p.id from public.profiles p
    where p.email in (select email from public.seed_users_import)
  );

-- Remove branch assignments for seeded users
delete from public.user_branch_assignments
where user_id in (
  select p.id from public.profiles p
  where p.email in (select email from public.seed_users_import)
);

-- Remove optional admin user inserts if table exists
do $$
begin
  if exists(
    select 1 from information_schema.tables
    where table_schema='public' and table_name='admin_users_2026_02_04_16_00'
  ) then
    execute $SQL$
      delete from public.admin_users_2026_02_04_16_00
      where email in (select email from public.seed_users_import)
    $SQL$;
  end if;
end
$$;

-- Remove profiles for seeded users
delete from public.profiles
where email in (select email from public.seed_users_import);

-- Remove auth users (best effort; may be blocked on hosted)
delete from auth.users
where lower(email) in (select lower(email) from public.seed_users_import);

-- (Optional) keep seed table rows; if you want to remove them:
-- delete from public.seed_users_import;

commit;