begin;

-- Remove policies (safe)
do $$
begin
  if to_regclass('public.shipments') is not null then
    execute 'drop policy if exists "Shipment Select" on public.shipments';
    execute 'drop policy if exists "Shipment Insert" on public.shipments';
    execute 'drop policy if exists "Shipment Update" on public.shipments';
    execute 'drop policy if exists "Shipment Delete" on public.shipments';
  end if;

  if to_regclass('public.profiles') is not null then
    execute 'drop policy if exists "Profile Self Read" on public.profiles';
    execute 'drop policy if exists "Profile Self Update" on public.profiles';
  end if;

  if to_regclass('public.permissions') is not null then
    execute 'drop policy if exists "Permissions Read" on public.permissions';
  end if;

  if to_regclass('public.roles') is not null then
    execute 'drop policy if exists "Roles Read" on public.roles';
  end if;

  if to_regclass('public.role_permissions') is not null then
    execute 'drop policy if exists "Role Permissions Read" on public.role_permissions';
  end if;

  if to_regclass('public.user_permissions') is not null then
    execute 'drop policy if exists "User Permissions Self Read" on public.user_permissions';
  end if;

  if to_regclass('public.branches') is not null then
    execute 'drop policy if exists "Branches Read" on public.branches';
  end if;
end $$;

-- Remove seeded data from app tables first
do $$
declare
  v_ids uuid[];
begin
  select array_agg(u.id)
  into v_ids
  from auth.users u
  where lower(u.email) in (select lower(email) from public.seed_users_import);

  if v_ids is null then
    return;
  end if;

  -- user_permissions
  if to_regclass('public.user_permissions') is not null then
    delete from public.user_permissions where user_id = any(v_ids);
  end if;

  -- branch assignments
  if to_regclass('public.user_branch_assignments') is not null then
    delete from public.user_branch_assignments where user_id = any(v_ids);
  end if;

  -- admin users table
  if to_regclass('public.admin_users_2026_02_04_16_00') is not null then
    if exists(select 1 from information_schema.columns where table_schema='public' and table_name='admin_users_2026_02_04_16_00' and column_name='user_id') then
      delete from public.admin_users_2026_02_04_16_00 where user_id = any(v_ids);
    elsif exists(select 1 from information_schema.columns where table_schema='public' and table_name='admin_users_2026_02_04_16_00' and column_name='email') then
      delete from public.admin_users_2026_02_04_16_00
      where lower(email::text) in (select lower(email) from public.seed_users_import);
    end if;
  end if;

  -- profiles
  if to_regclass('public.profiles') is not null then
    delete from public.profiles where id = any(v_ids);
  end if;

  -- auth identities then users
  delete from auth.identities where user_id = any(v_ids);
  delete from auth.users where id = any(v_ids);
end $$;

-- (Optional) keep helper functions, or drop them if you want a true rollback:
-- NOTE: do NOT drop has_permission if other policies depend on it in other migrations.
-- drop function if exists public.branch_key_from_email(text);
-- drop function if exists public.resolve_branch_id(text);
-- drop function if exists public.is_role(text);

commit;