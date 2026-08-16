// ── PROJECTS ──────────────────────────────────────────────────
// Serves the public case-study list for the Our Work section.
//
// The page already renders every project from static markup, so this
// endpoint is pure enrichment: it adds live deploy state and the current
// primary URL straight from the Netlify API.
//
// Only projects on ALLOWLIST are ever returned. Internal tooling, client
// work under NDA, and personal projects live in the same Netlify team, so
// the allowlist — not the API response — decides what is public.

const NETLIFY_API = 'https://api.netlify.com/api/v1';

// The public portfolio. `id` is the Netlify site_id; everything else is
// the editorial copy that the static markup also carries, kept here so a
// client-side render has the full record without a second source.
const ALLOWLIST = [
  {
    slug: 'af-environmental',
    id: '8f1904ac-101c-4c97-8e8e-4702c258a384',
    name: 'AF Environmental',
    kind: 'Website',
    sector: 'Rugged services',
  },
  {
    slug: 'chip-drop',
    id: '5288f62f-5a90-4f4c-85d5-0925c955f89d',
    name: 'Chip Drop Dispatch',
    kind: 'Custom tool',
    sector: 'Tree & land',
  },
  {
    slug: 'fleetview',
    id: '6f42fae5-1bd1-4536-8577-91ea8fd6f2b0',
    name: 'FleetView',
    kind: 'Custom tool',
    sector: 'Fleet & equipment',
  },
  {
    slug: 'eddm-tracker',
    id: 'e2f3f44e-be60-4829-a549-d92e4da92dca',
    name: 'EDDM Tracker',
    kind: 'Dashboard',
    sector: 'Direct mail',
  },
  {
    slug: 'carddesk',
    id: 'f1aa096b-4e59-42b9-9670-de9bb1ef1072',
    name: 'CardDesk',
    kind: 'Custom tool',
    sector: 'Collectibles & resale',
  },
  {
    slug: 'fieldwork-ledger',
    id: '02c4c0a6-c717-43ba-b39f-c8449b58a7a3',
    name: 'Fieldwork Ledger',
    kind: 'Custom tool',
    sector: 'Field operations',
  },
  {
    slug: 'stewpendous-radar',
    id: 'f9c18110-55ce-497f-862d-b582fb2a8004',
    name: 'Stewpendous Radar',
    kind: 'Market research',
    sector: 'Live events',
  },
  {
    slug: 'stewpendous-cc',
    id: '02f7af83-3574-4f47-b4d6-5b14ebcb5c40',
    name: 'Stewpendous Command Center',
    kind: 'Internal command center',
    sector: 'Live events',
  },
];

// Netlify's site payload uses `state: "current"` on a healthy published
// deploy. Anything else we report as unknown rather than guessing.
function readDeploy(site) {
  const deploy = site && site.published_deploy;
  if (!deploy) return { live: null, published: null };
  return {
    live: deploy.state === 'ready',
    published: deploy.published_at || null,
  };
}

async function fetchSite(id, token, signal) {
  const res = await fetch(`${NETLIFY_API}/sites/${id}`, {
    headers: { Authorization: `Bearer ${token}` },
    signal,
  });
  if (!res.ok) throw new Error(`Netlify API ${res.status} for site ${id}`);
  return res.json();
}

// Shapes the public payload. Netlify site ids never leave the server —
// and neither do the project URLs. These are private client systems, so
// the marketing page states that we built them without handing visitors
// a door into a customer's live app.
function present(project, { live, published }) {
  return {
    slug: project.slug,
    name: project.name,
    kind: project.kind,
    sector: project.sector,
    live,
    published,
  };
}

export default async function handler() {
  const token = process.env.NETLIFY_AUTH_TOKEN;

  // No token configured — still a valid response. The page keeps its
  // static copy and simply skips the live badges.
  if (!token) {
    return Response.json(
      {
        enriched: false,
        projects: ALLOWLIST.map(p =>
          present(p, { live: null, published: null }),
        ),
      },
      { headers: { 'Cache-Control': 'public, max-age=300' } },
    );
  }

  // One slow site shouldn't hang the whole section.
  const timeout = AbortSignal.timeout(6000);

  const projects = await Promise.all(
    ALLOWLIST.map(async project => {
      try {
        const site = await fetchSite(project.id, token, timeout);
        const { live, published } = readDeploy(site);
        return present(project, { live, published });
      } catch {
        // Degrade to the static record rather than dropping the project.
        return present(project, { live: null, published: null });
      }
    }),
  );

  return Response.json(
    { enriched: true, projects },
    { headers: { 'Cache-Control': 'public, max-age=300' } },
  );
}

export const config = { path: '/api/projects' };
