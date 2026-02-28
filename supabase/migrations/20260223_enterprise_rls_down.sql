begin;

-- Drop policies
do $$
begin
  if to_regclass('public.shipments') is not null then
    execute 'drop policy if exists shipment_select on public.shipments';
    execute 'drop policy if exists shipment_insert on public.shipments';
    execute 'drop policy if exists shipment_update on public.shipments';
    execute 'drop policy if exists shipment_delete on public.shipments';
  end if;

  if to_regclass('public.profiles') is not null then
    execute 'drop policy if exists profiles_self_read on public.profiles';
    execute 'drop policy if exists profiles_self_update on public.profiles';
  end if;

  if to_regclass('public.audit_logs') is not null then
    execute 'drop policy if exists audit_self_read on public.audit_logs';
  end if;
end $$;

-- Drop trigger
do $$
begin
  if to_regclass('public.approvals') is not null then
    execute 'drop trigger if exists trg_prevent_self_approval on public.approvals';
  end if;
end $$;

-- Drop functions
drop function if exists public.prevent_self_approval();
drop function if exists public.can_access_branch(uuid);
drop function if exists public.has_role(text);
-- DO NOT drop has_permission unless sure nothing else depends on it

commit;