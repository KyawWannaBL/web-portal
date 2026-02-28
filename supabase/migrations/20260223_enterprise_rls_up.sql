begin;

-- ============================================================
-- 1️⃣ CORE SECURITY FUNCTIONS
-- ============================================================

-- Permission check (NO parameter naming conflicts)
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
      and lower(p.code::text) = lower($1)
  );
$$;

-- Check if current user has role
create or replace function public.has_role(text)
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

-- Branch scope check
create or replace function public.can_access_branch(uuid)
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.user_branch_assignments uba
    where uba.user_id = auth.uid()
      and uba.branch_id = $1
  )
  or public.has_role('SUPER_ADMIN')
  or public.has_role('APP_OWNER');
$$;

-- ============================================================
-- 2️⃣ ENABLE RLS (SAFE)
-- ============================================================

do $$
declare
  t text;
begin
  foreach t in array[
    'profiles',
    'shipments',
    'audit_logs',
    'approvals',
    'approval_requests',
    'branches',
    'user_permissions',
    'role_permissions'
  ] loop
    if to_regclass('public.'||t) is not null then
      execute format('alter table public.%I enable row level security', t);
    end if;
  end loop;
end $$;

-- ============================================================
-- 3️⃣ PROFILES POLICIES (S1 Self + S5 Admin)
-- ============================================================

drop policy if exists profiles_self_read on public.profiles;
create policy profiles_self_read
on public.profiles
for select
to authenticated
using (
  id = auth.uid()
  or public.has_role('SUPER_ADMIN')
  or public.has_role('APP_OWNER')
);

drop policy if exists profiles_self_update on public.profiles;
create policy profiles_self_update
on public.profiles
for update
to authenticated
using (id = auth.uid())
with check (id = auth.uid());

-- ============================================================
-- 4️⃣ SHIPMENTS (Branch Scoped S3)
-- ============================================================

do $$
begin
  if to_regclass('public.shipments') is not null then

    drop policy if exists shipment_select on public.shipments;
    drop policy if exists shipment_insert on public.shipments;
    drop policy if exists shipment_update on public.shipments;
    drop policy if exists shipment_delete on public.shipments;

    if exists(
      select 1 from information_schema.columns
      where table_schema='public'
        and table_name='shipments'
        and column_name='branch_id'
    ) then

      execute $p$
        create policy shipment_select
        on public.shipments
        for select
        to authenticated
        using (
          public.can_access_branch(branch_id)
        )
      $p$;

      execute $p$
        create policy shipment_insert
        on public.shipments
        for insert
        to authenticated
        with check (
          public.can_access_branch(branch_id)
        )
      $p$;

      execute $p$
        create policy shipment_update
        on public.shipments
        for update
        to authenticated
        using (
          public.can_access_branch(branch_id)
        )
        with check (
          public.can_access_branch(branch_id)
        )
      $p$;

      execute $p$
        create policy shipment_delete
        on public.shipments
        for delete
        to authenticated
        using (
          public.has_role('SUPER_ADMIN')
          or public.has_role('APP_OWNER')
        )
      $p$;

    end if;
  end if;
end $$;

-- ============================================================
-- 5️⃣ AUDIT LOGS (Self + Admin)
-- ============================================================

do $$
begin
  if to_regclass('public.audit_logs') is not null
     and exists(select 1 from information_schema.columns
                where table_schema='public'
                and table_name='audit_logs'
                and column_name='user_id')
  then

    drop policy if exists audit_self_read on public.audit_logs;

    execute $p$
      create policy audit_self_read
      on public.audit_logs
      for select
      to authenticated
      using (
        user_id = auth.uid()
        or public.has_role('SUPER_ADMIN')
        or public.has_role('APP_OWNER')
      )
    $p$;
  end if;
end $$;

-- ============================================================
-- 6️⃣ SEGREGATION OF DUTIES (Approvals)
-- ============================================================

create or replace function public.prevent_self_approval()
returns trigger
language plpgsql
as $$
begin
  if (to_jsonb(new) ? 'requester_id')
     and (to_jsonb(new) ? 'approver_id')
     and new.requester_id = new.approver_id then
    raise exception 'Segregation of duties violation';
  end if;
  return new;
end;
$$;

do $$
begin
  if to_regclass('public.approvals') is not null then
    drop trigger if exists trg_prevent_self_approval on public.approvals;
    create trigger trg_prevent_self_approval
    before insert or update
    on public.approvals
    for each row
    execute function public.prevent_self_approval();
  end if;
end $$;

-- ============================================================
-- 7️⃣ PERFORMANCE INDEX TUNING
-- ============================================================

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
    if exists(select 1 from information_schema.columns
              where table_schema='public'
              and table_name='shipments'
              and column_name='branch_id') then
      execute 'create index if not exists idx_shipments_branch on public.shipments(branch_id)';
    end if;
  end if;
end $$;

commit;