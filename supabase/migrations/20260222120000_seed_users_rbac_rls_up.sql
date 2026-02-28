begin;

-- =========================
-- 0) Preconditions / helpers
-- =========================

-- Ensure extensions used by hashing / uuids exist
create extension if not exists pgcrypto;

-- Seed table already created by you, but keep safe
create table if not exists public.seed_users_import (
  email text primary key,
  role text not null,
  full_name text not null
);

-- =========================
-- 1) Functions (NO param rename issues)
-- =========================

-- has_permission(text) implemented WITHOUT naming input parameter
-- so it can be CREATE OR REPLACE safely even if older function exists.
create or replace function public.has_permission(text)
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.user_permissions up
    join public.permissions p on p.id = up.permission_id
    where up.user_id = auth.uid()
      and lower(p.code) = lower($1)
  );
$$;

-- Determine if current user is SUPER_ADMIN / APP_OWNER (based on profiles.role)
create or replace function public.is_role(text)
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.profiles pr
    where pr.id = auth.uid()
      and lower(pr.role::text) = lower($1)
  );
$$;

-- Branch lookup: returns UUID by trying to match:
-- - branches.code (if exists) OR branches.name (if exists)
create or replace function public.resolve_branch_id(p_branch_key text)
returns uuid
language plpgsql
stable
as $$
declare
  v_branch_id uuid;
  v_has_code boolean;
  v_has_name boolean;
begin
  if p_branch_key is null or length(trim(p_branch_key)) = 0 then
    return null;
  end if;

  select exists(
    select 1 from information_schema.columns
    where table_schema='public' and table_name='branches' and column_name='code'
  ) into v_has_code;

  select exists(
    select 1 from information_schema.columns
    where table_schema='public' and table_name='branches' and column_name='name'
  ) into v_has_name;

  if v_has_code then
    execute format('select id from public.branches where lower(code::text)=lower($1) limit 1')
      into v_branch_id
      using p_branch_key;
    if v_branch_id is not null then return v_branch_id; end if;
  end if;

  if v_has_name then
    execute format('select id from public.branches where lower(name::text)=lower($1) limit 1')
      into v_branch_id
      using p_branch_key;
    if v_branch_id is not null then return v_branch_id; end if;
  end if;

  return null;
end;
$$;

-- Derive branch key from email patterns
create or replace function public.branch_key_from_email(p_email text)
returns text
language plpgsql
stable
as $$
declare
  e text := lower(coalesce(p_email,''));
  localpart text;
begin
  -- common patterns
  if e like '%_ygn%' or e like '%yangon%' then return 'YGN'; end if;
  if e like '%_mdy%' or e like '%mandalay%' then return 'MDY'; end if;
  if e like '%_npw%' or e like '%nay%' then return 'NPW'; end if;

  -- substation pattern: aln_br@..., tgg_br@...
  localpart := split_part(e, '@', 1);
  if localpart like '%_br' then
    return upper(split_part(localpart, '_', 1));
  end if;

  return null;
end;
$$;

-- =========================
-- 2) Seed AUTH users + identities + profiles + assignments
-- =========================

do $$
declare
  r record;
  v_user_id uuid;
  v_default_password text := 'P@ssw0rd1';
  v_branch_key text;
  v_branch_id uuid;

  v_profiles_has_branch_id boolean;
  v_profiles_has_email boolean;
  v_profiles_has_full_name boolean;
  v_profiles_has_role boolean;
  v_profiles_has_must_change boolean;

  v_admin_users_table regclass;
  v_admin_users_has_user_id boolean;
  v_admin_users_has_email boolean;
  v_admin_users_has_role boolean;

  v_uba_table regclass;
  v_uba_has_user_id boolean;
  v_uba_has_branch_id boolean;

begin
  -- detect columns in profiles
  select exists(select 1 from information_schema.columns where table_schema='public' and table_name='profiles' and column_name='branch_id')
    into v_profiles_has_branch_id;

  select exists(select 1 from information_schema.columns where table_schema='public' and table_name='profiles' and column_name='email')
    into v_profiles_has_email;

  select exists(select 1 from information_schema.columns where table_schema='public' and table_name='profiles' and column_name='full_name')
    into v_profiles_has_full_name;

  select exists(select 1 from information_schema.columns where table_schema='public' and table_name='profiles' and column_name='role')
    into v_profiles_has_role;

  select exists(select 1 from information_schema.columns where table_schema='public' and table_name='profiles' and column_name='must_change_password')
    into v_profiles_has_must_change;

  -- optional admin_users table
  v_admin_users_table := to_regclass('public.admin_users_2026_02_04_16_00');
  if v_admin_users_table is not null then
    select exists(select 1 from information_schema.columns where table_schema='public' and table_name='admin_users_2026_02_04_16_00' and column_name='user_id')
      into v_admin_users_has_user_id;
    select exists(select 1 from information_schema.columns where table_schema='public' and table_name='admin_users_2026_02_04_16_00' and column_name='email')
      into v_admin_users_has_email;
    select exists(select 1 from information_schema.columns where table_schema='public' and table_name='admin_users_2026_02_04_16_00' and column_name='role')
      into v_admin_users_has_role;
  end if;

  -- optional user_branch_assignments
  v_uba_table := to_regclass('public.user_branch_assignments');
  if v_uba_table is not null then
    select exists(select 1 from information_schema.columns where table_schema='public' and table_name='user_branch_assignments' and column_name='user_id')
      into v_uba_has_user_id;
    select exists(select 1 from information_schema.columns where table_schema='public' and table_name='user_branch_assignments' and column_name='branch_id')
      into v_uba_has_branch_id;
  end if;

  for r in
    select lower(email) as email, role, full_name
    from public.seed_users_import
    order by email
  loop
    -- 2.1 create auth.users if missing
    select id into v_user_id from auth.users where lower(email) = r.email limit 1;

    if v_user_id is null then
      v_user_id := gen_random_uuid();

      insert into auth.users (
        id,
        aud,
        role,
        email,
        encrypted_password,
        email_confirmed_at,
        created_at,
        updated_at,
        raw_app_meta_data,
        raw_user_meta_data,
        is_sso_user
      ) values (
        v_user_id,
        'authenticated',
        'authenticated',
        r.email,
        crypt(v_default_password, gen_salt('bf')),
        now(),
        now(),
        now(),
        jsonb_build_object(
          'role', r.role,
          'must_change_password', true
        ),
        jsonb_build_object(
          'full_name', r.full_name
        ),
        false
      )
      on conflict (id) do nothing;

      -- identities: provider_id must be NOT NULL in your schema
      insert into auth.identities (
        id,
        user_id,
        provider,
        provider_id,
        identity_data,
        created_at,
        updated_at
      ) values (
        gen_random_uuid(),
        v_user_id,
        'email',
        r.email,
        jsonb_build_object(
          'sub', v_user_id::text,
          'email', r.email
        ),
        now(),
        now()
      )
      on conflict do nothing;
    end if;

    -- 2.2 resolve branch_id if possible
    v_branch_key := public.branch_key_from_email(r.email);
    v_branch_id := public.resolve_branch_id(v_branch_key);

    -- 2.3 insert/update profiles (only with columns that exist)
    if to_regclass('public.profiles') is not null then
      -- build dynamic insert to avoid missing-column errors
      if v_profiles_has_branch_id then
        execute $q$
          insert into public.profiles (id, email, full_name, role, branch_id, must_change_password, created_at, updated_at)
          values ($1, $2, $3, $4, $5, true, now(), now())
          on conflict (id) do update
            set email = excluded.email,
                full_name = excluded.full_name,
                role = excluded.role,
                branch_id = excluded.branch_id,
                must_change_password = excluded.must_change_password,
                updated_at = now()
        $q$
        using v_user_id, r.email, r.full_name, r.role, v_branch_id;
      else
        execute $q$
          insert into public.profiles (id, email, full_name, role, must_change_password, created_at, updated_at)
          values ($1, $2, $3, $4, true, now(), now())
          on conflict (id) do update
            set email = excluded.email,
                full_name = excluded.full_name,
                role = excluded.role,
                must_change_password = excluded.must_change_password,
                updated_at = now()
        $q$
        using v_user_id, r.email, r.full_name, r.role;
      end if;
    end if;

    -- 2.4 insert into admin_users_* if present and user is admin tier
    if v_admin_users_table is not null then
      if lower(r.role) in ('app_owner','super_admin','operations_admin','hr_admin','finance_staff','finance_user','marketing_admin','supervisor','warehouse_manager','substation_manager') then
        -- try best-effort insert depending on available columns
        if v_admin_users_has_user_id and v_admin_users_has_email and v_admin_users_has_role then
          execute $q$
            insert into public.admin_users_2026_02_04_16_00 (user_id, email, role, created_at, updated_at)
            values ($1, $2, $3, now(), now())
            on conflict do nothing
          $q$
          using v_user_id, r.email, r.role;
        elsif v_admin_users_has_email and v_admin_users_has_role then
          execute $q$
            insert into public.admin_users_2026_02_04_16_00 (email, role, created_at, updated_at)
            values ($1, $2, now(), now())
            on conflict do nothing
          $q$
          using r.email, r.role;
        elsif v_admin_users_has_user_id then
          execute $q$
            insert into public.admin_users_2026_02_04_16_00 (user_id, created_at, updated_at)
            values ($1, now(), now())
            on conflict do nothing
          $q$
          using v_user_id;
        end if;
      end if;
    end if;

    -- 2.5 user_branch_assignments (if exists + we resolved a real branch uuid)
    if v_uba_table is not null and v_branch_id is not null and v_uba_has_user_id and v_uba_has_branch_id then
      execute $q$
        insert into public.user_branch_assignments (user_id, branch_id, created_at, updated_at)
        values ($1, $2, now(), now())
        on conflict do nothing
      $q$
      using v_user_id, v_branch_id;
    end if;

  end loop;

  -- 2.6 Auto-assign role_permissions => user_permissions (if tables exist)
  if to_regclass('public.user_permissions') is not null
     and to_regclass('public.roles') is not null
     and to_regclass('public.role_permissions') is not null
     and to_regclass('public.permissions') is not null
     and to_regclass('public.profiles') is not null
  then
    -- IMPORTANT: profiles.role might be enum -> cast to text
    insert into public.user_permissions(user_id, permission_id)
    select pr.id as user_id, rp.permission_id
    from public.profiles pr
    join public.roles ro
      on lower(ro.code::text) = lower(pr.role::text)
    join public.role_permissions rp
      on rp.role_id = ro.id
    where pr.email in (select lower(email) from public.seed_users_import)
    on conflict do nothing;
  end if;

end $$;

-- =========================
-- 3) SAFE RLS enable + minimal baseline policies (branch + role aware)
-- =========================

-- Enable RLS only on tables that exist (core)
do $$
declare
  t text;
begin
  foreach t in array[
    'profiles',
    'users',
    'shipments',
    'audit_logs',
    'permissions',
    'roles',
    'role_permissions',
    'user_permissions',
    'user_branch_assignments',
    'user_sessions',
    'active_sessions',
    'approvals',
    'approval_requests',
    'branches'
  ] loop
    if to_regclass('public.'||t) is not null then
      execute format('alter table public.%I enable row level security', t);
    end if;
  end loop;
end $$;

-- PROFILES policies (self read/update)
do $$
begin
  if to_regclass('public.profiles') is not null then
    execute 'drop policy if exists "Profile Self Read" on public.profiles';
    execute 'drop policy if exists "Profile Self Update" on public.profiles';

    execute $p$
      create policy "Profile Self Read"
      on public.profiles
      for select
      to authenticated
      using (id = auth.uid())
    $p$;

    execute $p$
      create policy "Profile Self Update"
      on public.profiles
      for update
      to authenticated
      using (id = auth.uid())
      with check (id = auth.uid())
    $p$;
  end if;
end $$;

-- PERMISSIONS / ROLES / ROLE_PERMISSIONS are readable by authenticated
do $$
begin
  if to_regclass('public.permissions') is not null then
    execute 'drop policy if exists "Permissions Read" on public.permissions';
    execute 'create policy "Permissions Read" on public.permissions for select to authenticated using (true)';
  end if;

  if to_regclass('public.roles') is not null then
    execute 'drop policy if exists "Roles Read" on public.roles';
    execute 'create policy "Roles Read" on public.roles for select to authenticated using (true)';
  end if;

  if to_regclass('public.role_permissions') is not null then
    execute 'drop policy if exists "Role Permissions Read" on public.role_permissions';
    execute 'create policy "Role Permissions Read" on public.role_permissions for select to authenticated using (true)';
  end if;

  if to_regclass('public.user_permissions') is not null then
    execute 'drop policy if exists "User Permissions Self Read" on public.user_permissions';
    execute $p$
      create policy "User Permissions Self Read"
      on public.user_permissions
      for select
      to authenticated
      using (user_id = auth.uid() or public.is_role('SUPER_ADMIN') or public.is_role('APP_OWNER'))
    $p$;
  end if;
end $$;

-- BRANCHES readable by authenticated
do $$
begin
  if to_regclass('public.branches') is not null then
    execute 'drop policy if exists "Branches Read" on public.branches';
    execute 'create policy "Branches Read" on public.branches for select to authenticated using (true)';
  end if;
end $$;

-- SHIPMENTS baseline:
-- - SUPER_ADMIN / APP_OWNER full access
-- - otherwise: branch-scoped if shipments has branch_id
do $$
declare
  has_branch_id boolean;
begin
  if to_regclass('public.shipments') is null then
    return;
  end if;

  select exists(
    select 1 from information_schema.columns
    where table_schema='public' and table_name='shipments' and column_name='branch_id'
  ) into has_branch_id;

  execute 'drop policy if exists "Shipment Select" on public.shipments';
  execute 'drop policy if exists "Shipment Insert" on public.shipments';
  execute 'drop policy if exists "Shipment Update" on public.shipments';
  execute 'drop policy if exists "Shipment Delete" on public.shipments';

  if has_branch_id and to_regclass('public.user_branch_assignments') is not null then
    execute $p$
      create policy "Shipment Select"
      on public.shipments
      for select
      to authenticated
      using (
        public.is_role('APP_OWNER')
        or public.is_role('SUPER_ADMIN')
        or exists (
          select 1
          from public.user_branch_assignments uba
          where uba.user_id = auth.uid()
            and uba.branch_id = shipments.branch_id
        )
      )
    $p$;

    execute $p$
      create policy "Shipment Insert"
      on public.shipments
      for insert
      to authenticated
      with check (
        public.is_role('APP_OWNER')
        or public.is_role('SUPER_ADMIN')
        or exists (
          select 1
          from public.user_branch_assignments uba
          where uba.user_id = auth.uid()
            and uba.branch_id = shipments.branch_id
        )
      )
    $p$;

    execute $p$
      create policy "Shipment Update"
      on public.shipments
      for update
      to authenticated
      using (
        public.is_role('APP_OWNER')
        or public.is_role('SUPER_ADMIN')
        or exists (
          select 1
          from public.user_branch_assignments uba
          where uba.user_id = auth.uid()
            and uba.branch_id = shipments.branch_id
        )
      )
      with check (
        public.is_role('APP_OWNER')
        or public.is_role('SUPER_ADMIN')
        or exists (
          select 1
          from public.user_branch_assignments uba
          where uba.user_id = auth.uid()
            and uba.branch_id = shipments.branch_id
        )
      )
    $p$;

    execute $p$
      create policy "Shipment Delete"
      on public.shipments
      for delete
      to authenticated
      using (public.is_role('APP_OWNER') or public.is_role('SUPER_ADMIN'))
    $p$;
  else
    -- if no branch_id column, fall back to admin-only access to avoid accidental wide-open reads
    execute $p$
      create policy "Shipment Select"
      on public.shipments
      for select
      to authenticated
      using (public.is_role('APP_OWNER') or public.is_role('SUPER_ADMIN'))
    $p$;

    execute $p$
      create policy "Shipment Insert"
      on public.shipments
      for insert
      to authenticated
      with check (public.is_role('APP_OWNER') or public.is_role('SUPER_ADMIN'))
    $p$;

    execute $p$
      create policy "Shipment Update"
      on public.shipments
      for update
      to authenticated
      using (public.is_role('APP_OWNER') or public.is_role('SUPER_ADMIN'))
      with check (public.is_role('APP_OWNER') or public.is_role('SUPER_ADMIN'))
    $p$;

    execute $p$
      create policy "Shipment Delete"
      on public.shipments
      for delete
      to authenticated
      using (public.is_role('APP_OWNER') or public.is_role('SUPER_ADMIN'))
    $p$;
  end if;
end $$;

-- =========================
-- 4) Performance indexes (safe guards)
-- =========================

-- user_permissions lookup
do $$
begin
  if to_regclass('public.user_permissions') is not null then
    execute 'create index if not exists idx_user_permissions_user on public.user_permissions(user_id)';
    execute 'create index if not exists idx_user_permissions_perm on public.user_permissions(permission_id)';
  end if;

  if to_regclass('public.user_branch_assignments') is not null then
    execute 'create index if not exists idx_uba_user on public.user_branch_assignments(user_id)';
    execute 'create index if not exists idx_uba_branch on public.user_branch_assignments(branch_id)';
  end if;

  if to_regclass('public.shipments') is not null then
    -- create only if those columns exist
    if exists(select 1 from information_schema.columns where table_schema='public' and table_name='shipments' and column_name='branch_id') then
      execute 'create index if not exists idx_shipments_branch on public.shipments(branch_id)';
    end if;
    if exists(select 1 from information_schema.columns where table_schema='public' and table_name='shipments' and column_name='status') then
      execute 'create index if not exists idx_shipments_status on public.shipments(status)';
    end if;
    if exists(select 1 from information_schema.columns where table_schema='public' and table_name='shipments' and column_name='created_at') then
      execute 'create index if not exists idx_shipments_created_at on public.shipments(created_at)';
    end if;
  end if;
end $$;

commit;