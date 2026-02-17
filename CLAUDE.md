# Birkat HaSadeh - Project Guide

## Overview
Hebrew RTL produce store (fruits & vegetables) for Beit Shemesh, Israel.
Two-page app: customer storefront (`public/index.html`) + admin panel (`public/admin.html`).

## Tech Stack
- **Frontend**: React 18 + ReactDOM + Babel (all via CDN, no build step)
- **Styling**: Tailwind CSS v2 (CDN), Noto Sans Hebrew font
- **Backend**: Supabase (PostgreSQL + Auth + RLS)
- **No bundler** - pure HTML files with inline JSX compiled by Babel in-browser

## Project Structure
```
public/           - HTML pages served to users
public/js/        - Shared JavaScript (Supabase init, product images, categories)
database/         - SQL files for Supabase setup
docs/             - Setup guide
```

## Key Architecture
- `public/js/shared.js` exports globals on `window`: `supabase`, `SUPABASE_URL`, `SUPABASE_KEY`, `PRODUCT_IMAGES`, `getProductImage`, `CATEGORIES`, `CATEGORY_MAP`
- Both HTML files use `<script type="text/babel">` for inline React/JSX
- The app works with fallback mock data when Supabase is not connected
- Daily prices are stored separately from products (prices change daily)
- Admin panel uses `sb` as variable name for the Supabase client (references `window.supabaseClient`)

## Database
- 6 tables: products, daily_prices, orders, order_items, store_settings, admin_users
- RLS enabled on all tables with admin-based policies
- UUID primary keys throughout
- Run SQL files in order: schema.sql → seed.sql → security.sql → functions.sql

## Conventions
- All user-facing text is in Hebrew
- Currency is NIS (Israeli Shekel)
- Categories: fruits, vegetables, herbs, citrus, exotic
- Units: kg or unit
