# Tech Box Solutions

Marketing site + lead-capture CRM for **Tech Box Solutions** — websites, custom
tools, and AI solutions for small businesses.

- `index.html` — the marketing site (HTML + CSS + vanilla JS, no build step).
- `admin.html` — password-protected CRM for leads, customers, and projects.
- `netlify/functions/submit-lead.js` — receives the contact form, stores the
  lead in Supabase, and forwards it to email.
- `supabase-schema.sql` — one-time database setup for the CRM.

## Local development

```bash
npm install        # installs the function's Supabase dependency
netlify dev        # serves the site + functions locally at http://localhost:8888
```

Plain static preview without functions: `npx serve .`

## Contact form → email + CRM

The form posts to the `submit-lead` Netlify Function, which:

1. Inserts the lead into the Supabase `contacts` table (stage = `lead`), and
2. Forwards it to email via Formspree (form `xojonvjy`) so you still get an inbox
   notification.

If the Supabase env vars are absent the function still emails you — a lead is
never lost.

## CRM (Supabase)

Data lives in two tables (see `supabase-schema.sql`):

- **contacts** — every inquiry; `stage` moves `lead → qualified → customer → lost`.
- **projects** — work tied to a contact; `status` moves `open → in_progress → complete`.

Row-Level Security is on: the public site has no direct DB access. The function
writes leads with the `service_role` key (server-side only). `admin.html` reads
and manages everything after signing in with Supabase Auth.

### One-time setup

1. **Database** — Supabase → SQL Editor → run `supabase-schema.sql`.
2. **Admin user** — Supabase → Authentication → Users → add your login (email + password).
3. **Netlify env vars** (Site settings → Environment variables, or `netlify env:set`):
   - `SUPABASE_URL` = your project URL
   - `SUPABASE_SERVICE_ROLE_KEY` = the secret service role key (**never commit this**)
   - `FORMSPREE_ENDPOINT` *(optional)* = override the default Formspree form
4. **Admin keys** — in `admin.html`, set `SUPABASE_URL` and `SUPABASE_ANON_KEY`
   (both public/safe) near the top of the script.

## SEO

- Keyword-focused `<title>` / meta description, Open Graph + Twitter cards, canonical URL.
- JSON-LD structured data: `ProfessionalService` + `FAQPage`.
- `robots.txt` and `sitemap.xml` (admin page excluded from indexing).

## Deployment

Live at **techboxsolution.com**, hosted on Netlify (project `techboxsolutions`),
DNS via Cloudflare.

Deploy from the CLI:

```bash
netlify deploy --prod
```

`netlify.toml` sets the publish directory to the repo root and the functions
directory to `netlify/functions` — no build command needed for this static site.
