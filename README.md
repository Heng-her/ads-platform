# Ads Platform

A modern advertising platform built with a **pnpm monorepo** architecture.

- **Frontend**: Nuxt 4, Vue 3, Nuxt UI, Pinia, Tailwind CSS (Deployed on **Cloudflare Pages**)
- **Backend**: Hono API server, Drizzle ORM, Cloudflare D1 Database (Deployed on **Cloudflare Workers**)
- **Shared**: `@ads-platform/shared` package for shared types, schemas, and utilities

---

## 🛠️ Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v20+)
- [pnpm](https://pnpm.io/) (v10+)

### Installation

Install dependencies from the repository root:

```bash
pnpm install
```

---

## 🚀 Development Server

Run frontend and backend dev servers:

```bash
# Start all workspace projects in dev mode
pnpm dev

# Or start individually:
pnpm dev:frontend   # Starts Nuxt on http://localhost:3000
pnpm dev:backend    # Starts Hono/Wrangler on http://localhost:8787
```

---

## 📦 Building

Build all workspace packages for production:

```bash
pnpm build
```

---

## 🚀 Deployment (Cloudflare)

### Option 1: Direct CLI Deployment (Recommended)

Make sure you are logged in to Cloudflare Wrangler CLI:

```bash
npx wrangler login
# Check your login status:
wrangler whoami
```

Deploy directly from your terminal:

```bash
# Deploy Frontend to Cloudflare Pages
pnpm deploy:frontend

# Deploy Backend to Cloudflare Workers
pnpm deploy:backend

# Deploy Both Frontend and Backend
pnpm deploy:all
```

---

### Option 2: Cloudflare Dashboard (Git Integration / CI)

If you connect your GitHub repository to Cloudflare Pages/Workers:

| Setting | Recommended Value |
| :--- | :--- |
| **Root directory** | `/` |
| **Build command** | `pnpm --filter frontend build` |
| **Deploy command** | `pnpm exec wrangler pages deploy apps/frontend/.output/public` |
| **Environment Variable** | `NPM_FLAGS = --no-frozen-lockfile` |

---

## 🗄️ Database Management (D1 & Drizzle)

From the project root:

```bash
# Generate D1 database migrations
pnpm --filter backend db:generate

# Apply migrations locally
pnpm --filter backend db:migrate:local

# Apply migrations to production Cloudflare D1
pnpm --filter backend db:migrate:prod
```

---

## 📂 Repository Structure

```text
ads-platform/
├── apps/
│   ├── frontend/     # Nuxt 4 web application
│   └── backend/      # Hono Cloudflare Worker API
├── packages/
│   └── shared/       # Shared TypeScript types & utilities
├── package.json      # Workspace root package.json
└── pnpm-workspace.yaml
```
