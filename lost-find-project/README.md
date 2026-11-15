# FindIt: Lost & Found setup guide

Files:
- `index.html`: the whole website (map, live feed, report form, login, photo upload)
- `schema.sql`: database, security rules, photo storage and realtime setup for Supabase

## 1. Create the Supabase backend (about 10 minutes)

1. Go to https://supabase.com, sign in, and click **New project**. Pick the region closest to your users (for India, Mumbai/Singapore).
2. Open **SQL Editor -> New query**, paste all of `schema.sql`, and click **Run**. It is safe to run twice.
3. Open **Project Settings -> API** and copy:
   - **Project URL**
   - **anon public** key
4. Open `index.html`, find the CONFIG block near the bottom, and paste both values:
   ```js
   const SUPABASE_URL      = 'https://aflhgqzuzfeantjsmlbn.supabase.co/rest/v1/';
   const SUPABASE_ANON_KEY = 'sb_publishable_dNlmS4Gg-yR_PlT81XRmjA_nftApGJ4';
   ```
   The anon key is meant to be public. Your data is protected by the row-level security rules in `schema.sql`. Never put the `service_role` key in this file.
5. Open **Authentication -> URL Configuration**:
   - **Site URL**: your live address (for example `https://vikashraj.online/lostfound/` or the folder you deploy to)
   - **Redirect URLs**: add the same address, and `http://localhost:5500/` for local testing
6. (Optional) **Authentication -> Providers -> Google**: enable it if you want the "Continue with Google" button. Email magic link works without it.
7. Check **Database -> Replication** that `items` is listed under `supabase_realtime`. The SQL does this already.

## 2. Test locally

Run `npx serve .` or use the VS Code Live Server extension in the folder, then open it in a browser. Location access only works on `https://` or `localhost`.

Test list:
1. Sign in with your email link.
2. Report a lost item, pin a location, add a photo.
3. Open the site in a second browser window and confirm the report appears live without refreshing.
4. Open the report while signed out and confirm the contact is hidden.

## 3. Go live

Any static host works:
- **Your own site (vikashraj.online)**: upload `index.html` into a folder such as `/lostfound/`, or serve it at a subdomain like `find.vikashraj.online`.
- **Netlify / Vercel / Cloudflare Pages / GitHub Pages**: drag the folder in or connect a repo. All are free for a site like this.

Update the Supabase **Site URL** and **Redirect URLs** to the final address, otherwise login links will point to the wrong place.

## How it works

| Need | How it is done |
|---|---|
| Anywhere in the world | Every item stores latitude/longitude and is shown on an OpenStreetMap world map |
| Real-time | Supabase Realtime pushes new, edited and deleted reports to every open browser |
| Exact date and time | `event_time` (timestamptz) is stored in UTC and shown in each viewer's local time |
| Current location | Browser GPS for "Near me" and "Use my location" |
| Privacy | Contact details live in a separate table that only signed-in users can read |
| Ownership | Only the person who posted can edit, resolve or delete a report |
| Photos | Resized in the browser (max 1200 px) and stored in the `item-photos` bucket |
| Shareable links | Each report has a link like `yoursite/#item=<id>` |

## Good next steps

- **Report/flag button** and a `moderators` role, since public sites attract spam. Easiest first step: in Supabase, delete bad rows from **Table editor**.
- **Matching alerts**: when a "found" item is posted within a few km of a "lost" item in the same category, email the owner. Use a Supabase Edge Function plus Resend or the built-in email.
- **Cleanup job**: auto-archive reports older than 90 days with `pg_cron`.
- **Heavier traffic**: for tens of thousands of items, add PostGIS and load only the items in the visible map area.
- **Safety text**: keep the on-page advice (ask for proof of ownership, meet in public places). Do not let people post Aadhaar/PAN/passport numbers in descriptions.
