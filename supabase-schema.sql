-- ============================================================================
--  Tech Box Solutions — CRM schema for Supabase
--  Run this once in your Supabase project: SQL Editor → New query → paste → Run
-- ============================================================================

-- ── CONTACTS ────────────────────────────────────────────────────────────────
-- Every inbound inquiry starts life here as stage = 'lead'. As you work the
-- pipeline you move a contact through the stages. A contact at stage 'customer'
-- is what the site calls an "open customer".
create table if not exists public.contacts (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  name        text not null,
  business    text,
  email       text not null,
  phone       text,
  industry    text,              -- what they said they need (website / tool / AI / …)
  message     text,              -- "what's slowing you down"
  source      text default 'website form',
  stage       text not null default 'lead'
              check (stage in ('lead','qualified','customer','lost')),
  notes       text               -- your private working notes
);

create index if not exists contacts_stage_idx      on public.contacts (stage);
create index if not exists contacts_created_at_idx  on public.contacts (created_at desc);

-- ── PROJECTS ────────────────────────────────────────────────────────────────
-- Work you're doing for a contact. Tied to a contact via contact_id.
create table if not exists public.projects (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  contact_id  uuid references public.contacts(id) on delete cascade,
  title       text not null,
  description text,
  status      text not null default 'open'
              check (status in ('open','in_progress','complete','on_hold','cancelled')),
  value       numeric(12,2)      -- estimated / contracted $ value, optional
);

create index if not exists projects_contact_id_idx on public.projects (contact_id);
create index if not exists projects_status_idx      on public.projects (status);

-- ── keep updated_at fresh ────────────────────────────────────────────────────
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists contacts_set_updated_at on public.contacts;
create trigger contacts_set_updated_at
  before update on public.contacts
  for each row execute function public.set_updated_at();

drop trigger if exists projects_set_updated_at on public.projects;
create trigger projects_set_updated_at
  before update on public.projects
  for each row execute function public.set_updated_at();

-- ── ROW LEVEL SECURITY ───────────────────────────────────────────────────────
-- RLS on. The public website has NO direct access to these tables — inserts
-- happen server-side in the Netlify function using the service_role key, which
-- bypasses RLS. The admin page signs in with Supabase Auth and gets full access.
alter table public.contacts enable row level security;
alter table public.projects enable row level security;

-- Authenticated (logged-in admin) users can do everything.
drop policy if exists "authenticated full access to contacts" on public.contacts;
create policy "authenticated full access to contacts"
  on public.contacts for all
  to authenticated
  using (true) with check (true);

drop policy if exists "authenticated full access to projects" on public.projects;
create policy "authenticated full access to projects"
  on public.projects for all
  to authenticated
  using (true) with check (true);

-- NOTE: the anon (public) role gets no policy, so it can read/write nothing.
-- That's intentional and secure. The website form never touches Supabase
-- directly; only the Netlify function (service_role) writes leads.
