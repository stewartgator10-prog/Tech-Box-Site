-- ============================================================================
--  Prospects — migration 002: trading_status
--  Run in Supabase → SQL Editor. Safe to re-run.
--
--  Research can't always tell whether a business still exists. Delphey
--  Construction surfaced the problem: no website and a named owner scored it
--  84 and put it top of the call list, while its Yelp page says CLOSED.
--  Score answers "how good a prospect is this"; it can't answer "is there
--  anyone left to call".
--
--  Already applied to the live project on 2026-07-29. This file exists so the
--  schema is reproducible from the repo.
-- ============================================================================

alter table public.prospects
  add column if not exists trading_status text not null default 'open'
    check (trading_status in ('open','review','closed'));

-- open   — trading, as far as anyone knows (the default)
-- review — sources conflict; a human needs to ring the number and confirm
-- closed — confirmed shut; keep the row so it isn't researched again

create index if not exists prospects_trading_status_idx
  on public.prospects (trading_status);

-- ---------- Triage view ----------
-- Rebuilt rather than replaced: adding a column mid-list changes the output
-- signature, and `create or replace view` cannot rename or reorder columns.
-- Nothing else depends on this view — admin.html queries the table directly.

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

-- A flagged row never reads as "call this week" no matter how high it scores,
-- and sorts below every open prospect.
