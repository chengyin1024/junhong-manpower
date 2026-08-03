create table if not exists public.manpower_saturday_overtime_records (
  id uuid primary key default gen_random_uuid(),
  work_date date not null,
  people jsonb not null default '[]'::jsonb,
  status text not null default 'pending' check (status in ('pending', 'completed')),
  finish_time text check (finish_time in ('15:00', '17:00')),
  created_at timestamptz not null default now(),
  completed_at timestamptz
);

alter table public.manpower_saturday_overtime_records
  add column if not exists product_name text;

alter table public.manpower_saturday_overtime_records
  add column if not exists deleted_at timestamptz;

alter table public.manpower_saturday_overtime_records
  add column if not exists finish_times jsonb not null default '{}'::jsonb;

create index if not exists manpower_saturday_overtime_records_status_date_idx
  on public.manpower_saturday_overtime_records (status, work_date desc);

alter table public.manpower_saturday_overtime_records enable row level security;

grant select, insert, update on public.manpower_saturday_overtime_records to anon, authenticated;

drop policy if exists "Saturday overtime public access" on public.manpower_saturday_overtime_records;
create policy "Saturday overtime public access"
  on public.manpower_saturday_overtime_records
  for all
  to anon, authenticated
  using (true)
  with check (true);
