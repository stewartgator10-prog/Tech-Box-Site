-- ============================================================================
--  Tech Box Solutions — Prospects (outbound lead research)
--  Migration 1 of 2. Run this FIRST, then supabase-prospects-thurmont-seed.sql
--  Supabase → SQL Editor → New query → paste → Run
--
--  `contacts` = people who came to us. `prospects` = businesses we found and
--  scored ourselves. Separate tables on purpose: a prospect has no inbound
--  message and carries research + a readiness score instead.
--  Safe to re-run.
-- ============================================================================

-- ── STATUS ENUM ─────────────────────────────────────────────────────────────
do $$
begin
  if not exists (select 1 from pg_type where typname = 'prospect_status') then
    create type prospect_status as enum ('identified','contacted','confirmed','denied');
  end if;
end
$$;

-- ── TABLE ───────────────────────────────────────────────────────────────────
create table if not exists public.prospects (
  id                uuid primary key default gen_random_uuid(),

  -- Identity
  business_name     text not null,
  address           text,
  town              text not null default 'Thurmont',
  state             text not null default 'MD',
  category          text,                       -- 'Trades', 'Beauty', 'Food & Drink', …
  owner_name        text,                       -- null when not found
  phone             text,
  website           text,                       -- null = no owned site (the whole point)

  -- Research
  presence_type     text,                       -- 'none' | 'social_only' | 'abandoned_site' | 'aggregator_only' | 'has_site'
  findings          text,                       -- what the research turned up
  pitch             text,                       -- recommended opening angle
  source            text default 'Thurmont Main Street directory + Google Places',
  verified          boolean not null default false,  -- true = website absence confirmed by hand
  review_count      integer,
  rating            numeric(2,1),

  -- Scoring model (see notes below; total is computed)
  gap_score         smallint not null default 0 check (gap_score    between 0 and 30),
  ticket_score      smallint not null default 0 check (ticket_score between 0 and 25),
  pain_score        smallint not null default 0 check (pain_score   between 0 and 20),
  reach_score       smallint not null default 0 check (reach_score  between 0 and 15),
  demand_score      smallint not null default 0 check (demand_score between 0 and 10),

  total_score       smallint generated always as (
                      gap_score + ticket_score + pain_score + reach_score + demand_score
                    ) stored,

  -- Pipeline
  status            prospect_status not null default 'identified',
  status_note       text,
  last_contacted_at timestamptz,

  -- Is there anyone left to call? Score says how good a prospect is, not
  -- whether it still exists. See supabase-prospects-002-trading-status.sql.
  --   open | review (sources conflict, confirm by phone) | closed
  trading_status    text not null default 'open'
                    check (trading_status in ('open','review','closed')),

  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),

  constraint prospects_unique_business unique (business_name, town, state)
);

-- ============================================================================
--  SCORING MODEL — 100 points, five weighted factors
-- ============================================================================
--
--  gap_score (0-30)  How much is missing, digitally
--    30  Nothing owned. Only unclaimed third-party listings.
--    25  Social only (Facebook / Instagram), no site.
--    20  Abandoned or "under construction" site attempt.
--    10  Thin site that exists but does no work.
--
--  ticket_score (0-25)  What one closed job is worth to them
--    25  Trades, contractors, auto — jobs in the thousands.
--    18  Professional services, catering, property mgmt.
--    12  Salon, restaurant, retail — low ticket, high frequency.
--
--  pain_score (0-20)  Evidence they're already losing money on this
--    20  Reviews explicitly cite missed calls, no-shows, no callbacks.
--    12  Wait-time complaints, or wrong info on unclaimed listings.
--     5  No visible operational signal.
--
--  reach_score (0-15)  How easy it is to get a human on the phone
--    15  Named owner + direct phone.
--    10  Phone only.
--     5  Neither.
--
--  demand_score (0-10)  Existing customer base worth capturing
--    10  500+ reviews    7  100-499    4  20-99    2  under 20
--
--  Tiers: 80+ call this week · 65-79 warm · 50-64 nurture · under 50 park
-- ============================================================================

-- ── INDEXES ─────────────────────────────────────────────────────────────────
create index if not exists prospects_status_idx   on public.prospects (status);
create index if not exists prospects_score_idx    on public.prospects (total_score desc);
create index if not exists prospects_category_idx on public.prospects (category);

-- ── keep updated_at fresh ───────────────────────────────────────────────────
-- Reuses set_updated_at() from supabase-schema.sql; defined here too so this
-- file stands on its own.
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists prospects_set_updated_at on public.prospects;
create trigger prospects_set_updated_at
  before update on public.prospects
  for each row execute function public.set_updated_at();

-- ── TRIAGE VIEW ─────────────────────────────────────────────────────────────
drop view if exists public.prospect_triage;

create view public.prospect_triage as
select
  id,
  business_name,
  category,
  owner_name,
  phone,
  total_score,
  status,
  trading_status,
  case
    when trading_status = 'closed' then 'Closed'
    when trading_status = 'review' then 'Confirm still trading'
    when total_score >= 80 then 'Call this week'
    when total_score >= 65 then 'Warm'
    when total_score >= 50 then 'Nurture'
    else 'Park'
  end as tier
from public.prospects
order by
  case trading_status when 'open' then 0 when 'review' then 1 else 2 end,
  total_score desc,
  business_name;

-- ── ROW LEVEL SECURITY ──────────────────────────────────────────────────────
-- This table sits behind a public static site. RLS is the only thing standing
-- between the anon key and the whole prospect list. Authenticated only.
alter table public.prospects enable row level security;

drop policy if exists "authenticated full access to prospects" on public.prospects;
create policy "authenticated full access to prospects"
  on public.prospects for all
  to authenticated
  using (true) with check (true);

-- No policy for the anon role, so signed-out visitors get zero rows.
