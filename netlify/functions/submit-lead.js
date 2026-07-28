// ============================================================================
//  submit-lead — receives the contact form, stores the lead in Supabase,
//  and forwards it to email (via Formspree). Runs server-side on Netlify so
//  the Supabase service_role key is never exposed to the browser.
//
//  Required Netlify environment variables:
//    SUPABASE_URL                 e.g. https://xxxx.supabase.co
//    SUPABASE_SERVICE_ROLE_KEY    (secret — set in Netlify, never commit)
//  Optional:
//    FORMSPREE_ENDPOINT           e.g. https://formspree.io/f/xojonvjy
//                                 (defaults to the existing form if unset)
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const FORMSPREE_ENDPOINT =
  process.env.FORMSPREE_ENDPOINT || 'https://formspree.io/f/xojonvjy';

exports.handler = async (event) => {
  if (event.httpMethod !== 'POST') {
    return json(405, { error: 'Method not allowed' });
  }

  let body;
  try {
    body = JSON.parse(event.body || '{}');
  } catch {
    return json(400, { error: 'Invalid request.' });
  }

  const name     = (body.name || '').trim();
  const email    = (body.email || '').trim();
  const business = (body.business || '').trim();
  const phone    = (body.phone || '').trim();
  const industry = (body.industry || '').trim();
  const message  = (body.problem || '').trim();
  const honeypot = (body.website || '').trim();

  // Honeypot: a real user leaves this empty. Silently accept & drop for bots.
  if (honeypot) return json(200, { ok: true });

  if (!name || !email || !message) {
    return json(400, { error: 'Please fill in your name, email, and message.' });
  }
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    return json(400, { error: 'Please enter a valid email address.' });
  }

  // ── 1. Store the lead in Supabase ─────────────────────────────────────────
  const { SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY } = process.env;
  if (SUPABASE_URL && SUPABASE_SERVICE_ROLE_KEY) {
    try {
      const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
        auth: { persistSession: false },
      });
      const { error } = await supabase.from('contacts').insert({
        name, business, email, phone, industry, message,
        source: 'website form', stage: 'lead',
      });
      if (error) console.error('Supabase insert error:', error.message);
    } catch (err) {
      // Don't fail the whole request if the DB write hiccups — the email below
      // is the safety net so a lead is never lost.
      console.error('Supabase insert threw:', err);
    }
  } else {
    console.warn('Supabase env vars missing — skipping DB insert.');
  }

  // ── 2. Forward to email via Formspree ─────────────────────────────────────
  try {
    const res = await fetch(FORMSPREE_ENDPOINT, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
      body: JSON.stringify({ name, email, business, phone, industry, message }),
    });
    if (!res.ok) {
      console.error('Formspree responded', res.status);
      // Lead is already in Supabase; report success so the visitor isn't blocked.
    }
  } catch (err) {
    console.error('Formspree forward failed:', err);
  }

  return json(200, { ok: true });
};

function json(statusCode, payload) {
  return {
    statusCode,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  };
}
