# Prospects tab — Supabase setup

The CRM's **Prospects** tab reads a `prospects` table that doesn't exist yet in
Supabase. Two SQL files create it and fill it with the Thurmont research. Both
live in this repo, both are copy-paste jobs, and both are safe to run twice.

Until you run them, the CRM works exactly as before — the Prospects tab just
shows a red setup notice instead of a list.

---

## What you're loading

| | |
|---|---|
| **Table** | `public.prospects` — separate from `contacts` |
| **Rows** | 49 Thurmont, MD businesses with no real website |
| **Sorted by** | `total_score` — a 0–100 readiness score, highest first |
| **Access** | Signed-in users only (row-level security, same as the rest of the CRM) |

`contacts` is people who came to us. `prospects` is businesses we found and
scored ourselves. They stay separate: a prospect has no inbound message, and
carries research plus a score instead.

---

## Step 1 — Create the table

1. Open [supabase.com](https://supabase.com) and sign in.
2. Pick the project **osrdaywdwfbknibegohi** (the one the CRM points at).
3. Left sidebar → **SQL Editor** → **New query**.
4. Open `supabase-prospects-schema.sql` from this repo, select all, copy.
5. Paste into the editor and click **Run** (or Ctrl+Enter).

You should see **Success. No rows returned.** That's correct — this step only
creates things.

## Step 2 — Load the Thurmont prospects

1. Still in the SQL Editor → **New query** (a fresh tab, not the same one).
2. Open `supabase-prospects-thurmont-seed.sql`, select all, copy.
3. Paste and **Run**.

You should see **Success. No rows returned.** again.

## Step 3 — Confirm it worked

New query, run this:

```sql
select count(*) from public.prospects;
```

Expect **49**. To eyeball the top of the list:

```sql
select * from public.prospect_triage limit 10;
```

`G & S Electric` should be at the top with a score of 92.

## Step 4 — Check the CRM

Open `/admin.html`, sign in, click the **Prospects** tab. You'll get the list
sorted by score, with the stat strip switching to prospect counts.

---

## Order matters

Run **schema first, seed second**. If you run the seed against a project that
has no `prospects` table, Postgres returns `relation "public.prospects" does
not exist` — nothing is broken, just run step 1 and try again.

## Re-running is fine

- The schema file guards every object (`if not exists`, `create or replace`,
  `drop policy if exists`), so re-running changes nothing.
- The seed ends in `on conflict ... do nothing`, keyed on business name + town
  + state. Rows already there are skipped, and **statuses and notes you've set
  in the CRM are never overwritten.**

That means you can paste an updated seed file later to add new businesses
without touching the ones you've already worked.

---

## How the score works

100 points across five factors. The colored bar on each row is these five, in
order, at their relative weights.

| Factor | Max | What it measures |
|---|---|---|
| **Gap** | 30 | How much is missing digitally — 30 = owns nothing, 25 = social only, 20 = abandoned site attempt, 10 = thin site |
| **Ticket** | 25 | What one closed job is worth — 25 trades/auto, 18 professional services, 12 salon/restaurant/retail |
| **Pain** | 20 | Evidence they're already losing money — 20 = reviews cite missed calls, 12 = wait-time or bad-listing complaints, 5 = no signal |
| **Reach** | 15 | How easy to get a human — 15 named owner + phone, 10 phone only, 5 neither |
| **Demand** | 10 | Existing customer base — 10 = 500+ reviews, 7 = 100–499, 4 = 20–99, 2 = under 20 |

**Tiers:** 80+ call this week · 65–79 warm · 50–64 nurture · under 50 park.

## Reading the list

- **✓ Verified** — the website absence was confirmed by hand. Eight rows carry
  it. Everything else came from a blank website field in the Town of Thurmont
  Main Street directory and still needs a 30-second check before you call. The
  **Look Up** button on each row opens a Google search for exactly that.
- **Status** — `identified` → `contacted` → `confirmed` / `denied`. Saving a
  row as *contacted* stamps `last_contacted_at` automatically.
- **Note** — free text, one line, for "left voicemail, call back Tues."

## Adding prospects later

Either insert them with SQL in the same shape as the seed file, or add a row
directly in Supabase → **Table Editor** → `prospects`. Only `business_name` is
required; scores default to 0, which puts the row at the bottom until you
fill them in. `total_score` is computed by the database — you can't set it
directly, and you don't need to.
