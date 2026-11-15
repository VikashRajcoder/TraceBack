-- =====================================================================
-- FindIt: Lost & Found  |  Supabase schema
-- Run this whole file once in: Supabase Dashboard -> SQL Editor -> New query
-- =====================================================================

-- 1) Items (public: anyone can read; only logged-in owners can write)
create table if not exists public.items (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null default auth.uid() references auth.users(id) on delete cascade,
  kind         text not null check (kind in ('lost', 'found')),
  title        text not null check (char_length(title) between 3 and 100),
  description  text check (char_length(description) <= 1000),
  category     text not null default 'other',
  event_time   timestamptz not null,                 -- exact date & time lost/found
  lat          double precision not null check (lat between -90 and 90),
  lng          double precision not null check (lng between -180 and 180),
  place_text   text check (char_length(place_text) <= 300),
  image_url    text,
  status       text not null default 'open' check (status in ('open', 'resolved')),
  created_at   timestamptz not null default now()
);

create index if not exists items_event_time_idx on public.items (event_time desc);
create index if not exists items_status_idx     on public.items (status);
create index if not exists items_user_idx       on public.items (user_id);

-- 2) Contacts (private: only signed-in users can read; only the owner can write)
--    Kept in a separate table so phone numbers / emails are never public.
create table if not exists public.item_contacts (
  item_id  uuid primary key references public.items(id) on delete cascade,
  contact  text not null check (char_length(contact) between 3 and 200)
);

-- 3) Row Level Security
alter table public.items         enable row level security;
alter table public.item_contacts enable row level security;

drop policy if exists "items are public"        on public.items;
drop policy if exists "owner inserts items"     on public.items;
drop policy if exists "owner updates items"     on public.items;
drop policy if exists "owner deletes items"     on public.items;

create policy "items are public"    on public.items for select using (true);
create policy "owner inserts items" on public.items for insert to authenticated
  with check (auth.uid() = user_id);
create policy "owner updates items" on public.items for update to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "owner deletes items" on public.items for delete to authenticated
  using (auth.uid() = user_id);

drop policy if exists "signed-in users read contacts" on public.item_contacts;
drop policy if exists "owner inserts contact"         on public.item_contacts;
drop policy if exists "owner updates contact"         on public.item_contacts;

create policy "signed-in users read contacts" on public.item_contacts
  for select to authenticated using (true);
create policy "owner inserts contact" on public.item_contacts
  for insert to authenticated
  with check (exists (select 1 from public.items i where i.id = item_id and i.user_id = auth.uid()));
create policy "owner updates contact" on public.item_contacts
  for update to authenticated
  using (exists (select 1 from public.items i where i.id = item_id and i.user_id = auth.uid()));

-- 4) Realtime: push new / changed / deleted items to every open browser
do $$
begin
  alter publication supabase_realtime add table public.items;
exception when duplicate_object then
  null; -- already added
end $$;

-- 5) Photo storage bucket (public read, users upload into their own folder)
insert into storage.buckets (id, name, public)
values ('item-photos', 'item-photos', true)
on conflict (id) do nothing;

drop policy if exists "photos are public"       on storage.objects;
drop policy if exists "users upload own photos" on storage.objects;
drop policy if exists "users delete own photos" on storage.objects;

create policy "photos are public" on storage.objects
  for select using (bucket_id = 'item-photos');
create policy "users upload own photos" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'item-photos' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "users delete own photos" on storage.objects
  for delete to authenticated
  using (bucket_id = 'item-photos' and (storage.foldername(name))[1] = auth.uid()::text);
