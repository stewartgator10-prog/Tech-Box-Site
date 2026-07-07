# The Tech Box

Marketing / portfolio site for The Tech Box — custom digital tools for small businesses.

Single-page static site: `index.html` (HTML + CSS + vanilla JS, no build step, no framework).

## Local development

No build tooling required. Either:

- Open `index.html` directly in a browser, or
- Serve it locally so relative paths/fonts behave exactly like production:
  ```bash
  npx serve .
  ```

## Contact form

Submissions go through Formspree (form ID `xojonvjy`, set in the `<script>` block
at the bottom of `index.html`). No server-side code or secrets involved.

## Deployment

Live at **techboxsolution.com**, hosted on Netlify, DNS managed through Cloudflare
(A record `@` → Netlify, CNAME `www` → `techboxsolutions.netlify.app`).

This repo is connected to Netlify via **continuous deployment**: every push to
`main` triggers an automatic build and deploy. `netlify.toml` sets the publish
directory to the repo root — no build command needed since this is a static site.
