TraceBack: Get It Back, anywhere in the world

A real-time lost-and-found web app. Anyone can report a lost or found item with its exact date, time and location, 
and every new report appears live on a world map for everyone else.
Live demo: https://fascinating-manatee-5f7017.netlify.app
Author: Vikash Raj

<!-- Add screenshots here, e.g. ![Home](docs/home.png) -->
Why this project

Lost items are usually reported in scattered WhatsApp groups and notice boards, 
with no location and no way to search. FindIt puts every report on one map, 
sorted by distance and time, so the person who finds something and the person 
who lost it can actually meet and get item back securely.

Features
-> World map with a pin for every report (OpenStreetMap + Leaflet)
-> Real-time updates: new, edited and deleted reports appear in every open browser without a refresh (Supabase Realtime)
-> Exact date and time for each report, stored in UTC and shown in the viewer's local time
-> Pick a location 4 ways: search a place, click the map, drag the pin, or use GPS
-> "Near me" filter with a 1, 5, 25 or 100 km radius, sorted by distance
-> Search and filters by lost/found, category, date range and keyword
-> Photo upload, resized in the browser before upload
-> Passwordless login with an email magic link (Google sign-in optional)
-> Private contact details: shown only to signed-in users, never publicly
-> Owner controls: mark as resolved, reopen or delete your own reports
-> Shareable links for every report
-> Responsive layout for phone and desktop, with automatic dark mode

Tech used:-
Layer	Technology
Frontend	HTML, CSS, vanilla JavaScript (single file, no build step)
Map	Leaflet + OpenStreetMap tiles
Geocoding	OpenStreetMap Nominatim
Backend	Supabase (PostgreSQL, Auth, Realtime, Storage)
Hosting	Netlify (any static host works)
