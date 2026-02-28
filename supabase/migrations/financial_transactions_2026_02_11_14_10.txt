begin;

alter table if exists public.financial_transactions_2026_02_11_14_10
enable row level security;

drop policy if exists financial_select on public.financial_transactions_2026_02_11_14_10;
drop policy if exists financial_insert on public.financial_transactions_2026_02_11_14_10;
drop policy if exists financial_update on public.financial_transactions_2026_02_11_14_10;

-- SELECT
create policy financial_select
on public.financial_transactions_2026_02_11_14_10
for select
to authenticated
using (
  public.can_access_hierarchy(branch_id)
);

-- INSERT
create policy financial_insert
on public.financial_transactions_2026_02_11_14_10
for insert
to authenticated
with check (
  public.can_access_hierarchy(branch_id)
);

-- UPDATE only if not approved
create policy financial_update
on public.financial_transactions_2026_02_11_14_10
for update
to authenticated
using (
  public.can_access_hierarchy(branch_id)
  and status <> 'APPROVED'
)
with check (
  public.can_access_hierarchy(branch_id)
  and status <> 'APPROVED'
);

commit;