begin;

-- ============================================================
-- 0) SCHEMA + EXTENSIONS
-- ============================================================
create schema if not exists app;

-- crypt() helper (usually already enabled)
create extension if not exists pgcrypto;

-- ============================================================
-- 1) STAGING TABLE (you already created; keep safe)
-- ============================================================
create table if not exists public.seed_users_import (
  email text primary key,
  role text not null,
  full_name text not null
);

-- ============================================================
-- 2) REQUIRED TABLES (create ONLY if missing)
--    (your DB already has these, but we keep "if not exists")
-- ============================================================
create table if not exists public.user_branch_assignments (
  user_id uuid not null,
  branch_id uuid not null,
  created_at timestamptz not null default now(),
  primary key (user_id, branch_id)
);

create table if not exists public.user_permissions (
  user_id uuid not null,
  permission_id uuid not null,
  created_at timestamptz not null default now(),
  primary key (user_id, permission_id)
);

-- Optional admin users table (only if it exists in YOUR DB)
-- If it does not exist, we just skip insert later.
-- (No create here because you had a dated table name previously.)

-- ============================================================
-- 3) HELPERS: ROLE + PERMISSION + BRANCH SCOPE
-- ============================================================

-- 3.1 Current user role (from profiles.role)
create or replace function app.current_role()
returns text
language sql
stable
as $$
  select p.role
  from public.profiles p
  where p.id = auth.uid()
  limit 1
$$;

-- 3.2 "Is admin" helper
create or replace function app.is_admin()
returns boolean
language sql
stable
as $$
  select coalesce(app.current_role() in (
    'APP_OWNER','SUPER_ADMIN','OPERATIONS_ADMIN','HR_ADMIN','FINANCE_STAFF','MARKETING_ADMIN'
  ), false)
$$;

-- 3.3 Branch access list for current user
create or replace function app.my_branch_ids()
returns table(branch_id uuid)
language sql
stable
as $$
  select uba.branch_id
  from public.user_branch_assignments uba
  where uba.user_id = auth.uid()
$$;

-- 3.4 Permission check (FIXES your "permission_code does not exist")
-- NOTE: we KEEP parameter name p_permission to avoid "cannot change name of input parameter"
create or replace function app.has_permission(p_permission text)
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.user_permissions up
    join public.permissions perm on perm.id = up.permission_id
    where up.user_id = auth.uid()
      and perm.code = p_permission
  )
$$;

-- ============================================================
-- 4) BRANCH UUID MAPPING (REAL UUIDs, not names)
--    Strategy:
--    - Try map by email tokens: ygn/mdy/npw or prefix before "_" (aln_br -> aln)
--    - Match against branches.code OR branches.slug OR branches.name (case-insensitive)
--    - If no match, branch_id = NULL (still seeds user)
-- ============================================================

create or replace function app.guess_branch_id_from_email(p_email text)
returns uuid
language plpgsql
stable
as $$
declare
  v_token text;
  v_branch uuid;
begin
  -- normalize
  v_token := lower(p_email);

  -- common region shortcuts
  if v_token like '%_ygn%' or v_token like '%yangon%' then
    select b.id into v_branch
    from public.branches b
    where lower(coalesce(b.code,'')) in ('ygn','yangon')
       or lower(coalesce(b.slug,'')) in ('ygn','yangon')
       or lower(coalesce(b.name,'')) like '%yangon%'
    limit 1;
    return v_branch;
  end if;

  if v_token like '%_mdy%' or v_token like '%mandalay%' then
    select b.id into v_branch
    from public.branches b
    where lower(coalesce(b.code,'')) in ('mdy','mandalay')
       or lower(coalesce(b.slug,'')) in ('mdy','mandalay')
       or lower(coalesce(b.name,'')) like '%mandalay%'
    limit 1;
    return v_branch;
  end if;

  if v_token like '%_npw%' or v_token like '%nay%' then
    select b.id into v_branch
    from public.branches b
    where lower(coalesce(b.code,'')) in ('npw','naypyitaw','nay_pyi_taw')
       or lower(coalesce(b.slug,'')) in ('npw','naypyitaw','nay_pyi_taw')
       or lower(coalesce(b.name,'')) like '%nay%'
    limit 1;
    return v_branch;
  end if;

  -- token from prefix before "_"  (aln_br@ -> aln)
  v_token := split_part(lower(p_email), '_', 1);

  select b.id into v_branch
  from public.branches b
  where lower(coalesce(b.code,'')) = v_token
     or lower(coalesce(b.slug,'')) = v_token
     or lower(coalesce(b.name,'')) like ('%' || v_token || '%')
  limit 1;

  return v_branch;
end;
$$;

-- ============================================================
-- 5) SEED USERS (AUTH + PROFILES + BRANCH ASSIGNMENT)
--    - Avoids instance_id / confirmed_at
--    - Avoids identities.provider_id null issue by NOT inserting identities directly
--    - Uses minimal safe columns for auth.users
-- ============================================================

do $$
declare
  r record;
  v_uid uuid;
  v_default_password text := 'P@ssw0rd1';  -- must change on first login
  v_branch uuid;
  v_has_auth_users boolean;
begin
  -- Check auth.users exists (it should)
  select exists(
    select 1 from information_schema.tables
    where table_schema='auth' and table_name='users'
  ) into v_has_auth_users;

  if not v_has_auth_users then
    raise exception 'auth.users table not found. This project auth schema is missing.';
  end if;

  for r in
    select email, role, full_name
    from public.seed_users_import
  loop
    -- 5.1 Create auth user (if missing)
    select u.id into v_uid
    from auth.users u
    where lower(u.email) = lower(r.email)
    limit 1;

    if v_uid is null then
      v_uid := gen_random_uuid();

      -- Insert minimal compatible columns (works across more Supabase versions)
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
        raw_user_meta_data
      )
      values (
        v_uid,
        'authenticated',
        'authenticated',
        lower(r.email),
        crypt(v_default_password, gen_salt('bf')),
        now(),
        now(),
        now(),
        jsonb_build_object(
          'app_role', r.role,
          'must_change_password', true
        ),
        jsonb_build_object(
          'full_name', r.full_name
        )
      );
    end if;

    -- 5.2 Insert profile (NO "branch" column)
    -- We only insert columns that we know exist in your list: id, email, role, etc.
    insert into public.profiles (
      id,
      email,
      role,
      created_at,
      updated_at
    )
    values (
      v_uid,
      lower(r.email),
      r.role,
      now(),
      now()
    )
    on conflict (id) do update set
      email = excluded.email,
      role  = excluded.role,
      updated_at = now();

    -- If your profiles table has full_name / must_change_password, set them safely:
    if exists(
      select 1 from information_schema.columns
      where table_schema='public' and table_name='profiles' and column_name='full_name'
    ) then
      execute format('update public.profiles set full_name = $1 where id = $2')
      using r.full_name, v_uid;
    end if;

    if exists(
      select 1 from information_schema.columns
      where table_schema='public' and table_name='profiles' and column_name='must_change_password'
    ) then
      execute format('update public.profiles set must_change_password = true where id = $1')
      using v_uid;
    end if;

    -- 5.3 Branch assignment
    v_branch := app.guess_branch_id_from_email(r.email);
    if v_branch is not null then
      insert into public.user_branch_assignments(user_id, branch_id)
      values (v_uid, v_branch)
      on conflict do nothing;
    end if;

  end loop;
end
$$;

-- ============================================================
-- 6) AUTO ASSIGN ROLE PERMISSIONS -> USER PERMISSIONS
--    role_permissions(role_id, permission_id) + roles(name/code)
-- ============================================================

-- Assumption: roles table has "code" (or "name") matching your role strings.
-- We'll support either by checking columns.

do $$
declare
  v_role_col text;
begin
  -- Find role identifier column in roles (prefer code, fallback name)
  if exists(
    select 1 from information_schema.columns
    where table_schema='public' and table_name='roles' and column_name='code'
  ) then
    v_role_col := 'code';
  elsif exists(
    select 1 from information_schema.columns
    where table_schema='public' and table_name='roles' and column_name='name'
  ) then
    v_role_col := 'name';
  else
    raise notice 'roles table missing code/name; skipping role_permissions -> user_permissions assignment.';
    return;
  end if;

  execute format($SQL$
    insert into public.user_permissions(user_id, permission_id)
    select p.id as user_id, rp.permission_id
    from public.profiles p
    join public.roles ro on lower(ro.%I) = lower(p.role)
    join public.role_permissions rp on rp.role_id = ro.id
    where p.email in (select email from public.seed_users_import)
    on conflict do nothing
  $SQL$, v_role_col);
end
$$;

-- ============================================================
-- 7) OPTIONAL: INSERT ADMINS INTO admin_users_2026_02_04_16_00 (IF EXISTS)
-- ============================================================

do $$
begin
  if exists(
    select 1 from information_schema.tables
    where table_schema='public' and table_name='admin_users_2026_02_04_16_00'
  ) then
    execute $SQL$
      insert into public.admin_users_2026_02_04_16_00 (user_id, email, role, created_at)
      select p.id, p.email, p.role, now()
      from public.profiles p
      where p.email in (select email from public.seed_users_import)
        and p.role in ('APP_OWNER','SUPER_ADMIN','OPERATIONS_ADMIN','HR_ADMIN','FINANCE_STAFF','MARKETING_ADMIN')
      on conflict do nothing
    $SQL$;
  end if;
end
$$;

-- ============================================================
-- 8) SAFE RLS ENABLE + POLICIES (BRANCH + ROLE + SCOPE)
--    We only apply when tables exist + expected columns exist.
-- ============================================================

-- 8.1 PROFILES RLS
alter table if exists public.profiles enable row level security;

drop policy if exists "profiles_self_read" on public.profiles;
create policy "profiles_self_read"
on public.profiles
for select
to authenticated
using (id = auth.uid() or app.is_admin());

drop policy if exists "profiles_self_update" on public.profiles;
create policy "profiles_self_update"
on public.profiles
for update
to authenticated
using (id = auth.uid() or app.is_admin())
with check (id = auth.uid() or app.is_admin());

-- 8.2 SHIPMENTS RLS (branch-scoped if shipments.branch_id exists)
do $$
begin
  if exists(select 1 from information_schema.tables where table_schema='public' and table_name='shipments') then
    execute 'alter table public.shipments enable row level security';

    if exists(
      select 1 from information_schema.columns
      where table_schema='public' and table_name='shipments' and column_name='branch_id'
    ) then
      execute 'drop policy if exists "shipments_branch_read" on public.shipments';
      execute $SQL$
        create policy "shipments_branch_read"
        on public.shipments
        for select
        to authenticated
        using (
          app.is_admin()
          or branch_id in (select branch_id from app.my_branch_ids())
        )
      $SQL$;

      execute 'drop policy if exists "shipments_branch_write" on public.shipments';
      execute $SQL$
        create policy "shipments_branch_write"
        on public.shipments
        for insert
        to authenticated
        with check (
          app.is_admin()
          or branch_id in (select branch_id from app.my_branch_ids())
        )
      $SQL$;
    else
      raise notice 'shipments.branch_id not found -> skipped branch-scoped shipment policies.';
    end if;
  end if;
end
$$;

-- 8.3 AUDIT LOGS RLS (own + admin)
alter table if exists public.audit_logs enable row level security;

do $$
begin
  if exists(
    select 1 from information_schema.columns
    where table_schema='public' and table_name='audit_logs' and column_name='user_id'
  ) then
    execute 'drop policy if exists "audit_logs_self_read" on public.audit_logs';
    execute $SQL$
      create policy "audit_logs_self_read"
      on public.audit_logs
      for select
      to authenticated
      using (user_id = auth.uid() or app.is_admin())
    $SQL$;
  end if;
end
$$;

commit;