# AGENTS.md — Ads Platform Project Guidelines

Welcome to the **Ads Platform** repository. This document serves as the primary reference and instructions manual for AI coding assistants (and developers) working on this codebase.

---

## 🏗️ 1. Architecture & Monorepo Overview

This project is structured as a **pnpm monorepo**:

```text
ads-platform/
├── apps/
│   ├── frontend/         # Nuxt 4, Vue 3, Nuxt UI, Pinia, Tailwind CSS (Deployed on Cloudflare Pages)
│   └── backend/          # Hono API framework, Drizzle ORM (Deployed on Cloudflare Workers)
├── packages/
│   └── shared/           # @ads-platform/shared (TypeScript types, schemas, crypto utilities)
├── .skills/              # Domain-specific AI skill guidelines (Web3, ERC-20, Escrow)
├── package.json          # Root workspace configuration & scripts
└── pnpm-workspace.yaml   # pnpm workspace definition & build settings
```

### Tech Stack Details
- **Frontend (`apps/frontend`)**:
  - Framework: [Nuxt 4](https://nuxt.com/) (Vue 3 with `<script setup>` Composition API)
  - UI Library: `@nuxt/ui` with Tailwind CSS
  - State Management: Pinia (`@pinia/nuxt`)
  - Rich Text Editor: TipTap (`@tiptap/vue-3`)
  - Platform: Cloudflare Pages
- **Backend (`apps/backend`)**:
  - API Framework: [Hono](https://hono.dev/)
  - Database: Cloudflare D1 (Serverless SQLite) with [Drizzle ORM](https://orm.drizzle.team/)
  - Key-Value Cache: Cloudflare KV (`CACHE_KV`)
  - Media & Assets: Cloudflare R2 (`ASSETS_BUCKET`) + External Crypten Upload API
  - Authentication: JWT (`jose`) + Bcrypt (`bcryptjs`)
  - Platform: Cloudflare Workers
- **Shared (`packages/shared`)**:
  - Shared validation schemas (`zod`)
  - Shared TypeScript interfaces & types
  - Shared cryptographic utilities (AES payload encryption)

---

## 🚀 2. Essential Commands

All commands are executed from the **repository root**:

### Dependency Management
```powershell
pnpm install
```
> [!NOTE]
> `.npmrc` is configured with `virtual-store-dir=node_modules/.p` and `package-import-method=copy` to prevent Windows NTFS file locking issues with native binaries (`esbuild.exe`, `better-sqlite3`).

### Development Servers
```powershell
# Run both Frontend and Backend concurrently:
pnpm dev

# Or run individually:
pnpm dev:backend     # Hono Worker on http://localhost:8787
pnpm dev:frontend    # Nuxt 4 on http://localhost:3000
```

### Database & Migrations (Cloudflare D1 & Drizzle)
```powershell
# Run local migrations:
pnpm run migration

# Full setup (Run migrations + seed initial users & system settings to local DB):
pnpm run db:setup

# Individual DB commands:
pnpm run db:migrate:local   # Apply migrations to local D1
pnpm run db:migrate:prod    # Apply migrations to remote Cloudflare D1
pnpm run db:seed:local       # Seed local D1 database
pnpm run db:seed:prod        # Seed remote Cloudflare D1 database
```

> [!CAUTION]
> **Do NOT run `pnpm run db:generate` blindly.** The project already maintains numbered migrations `0000` to `0023` in `apps/backend/drizzle/`. Only run `drizzle-kit generate` when deliberately adding a new schema migration.

### Code Quality & Builds
```powershell
# Typechecking:
pnpm --filter backend typecheck
pnpm --filter frontend typecheck
pnpm -r lint

# Production Builds:
pnpm build
```

### Deployment (Cloudflare)
```powershell
pnpm deploy:frontend   # Deploy Frontend to Cloudflare Pages
pnpm deploy:backend    # Deploy Backend to Cloudflare Workers
pnpm deploy:all        # Deploy both
```

---

## 🔑 3. Environment Variables & Secrets

### Frontend (`apps/frontend/.env`)
```env
# API Endpoint
NUXT_PUBLIC_API_BASE="http://localhost:8787/api"

# Public Web URL
NUXT_PUBLIC_SITE_URL="http://localhost:3000"

# Cryptographic Keys (matching backend crypto utils)
NUXT_PUBLIC_CRYPTO_SECRET="ads-platform-default-secure-key"
NUXT_CRYPTO_SECRET="ads-platform-secure-secret-key"

# Google OAuth (Optional)
NUXT_PUBLIC_GOOGLE_CLIENT_ID=""
```

### Backend (`apps/backend/.dev.vars` & `wrangler.jsonc`)
```env
# Mode
ENVIRONMENT="development"

# Auth Secrets
JWT_SECRET="dev_secure_jwt_secret_key_min_32_characters_long"
ADMIN_SECRET="Admin@123456"

# Image Upload API
UPLOAD_API_BASE_URL="https://api-upload-image-8ym9.onrender.com"
UPLOAD_API_KEY="crypten-api-key"
UPLOAD_API_BYPASS_SECRET="crypten-bypass-secret"

# Optional Services
GOOGLE_TRANSLATE_API_KEY=""
```

---

## 👥 4. Default Seed Accounts & Roles

The initial seed creates two pre-configured accounts:

| Role | Email | Password | Access / Purpose |
| :--- | :--- | :--- | :--- |
| **ADMIN** | `admin@adsplatform.com` | `Admin@123456` | Full platform control, System Settings (`/admin/settings`), Review Campaigns |
| **CREATOR** | `creator@adsplatform.com` | `Creator@123456` | Creator Studio, Create & Manage Campaigns, Earnings & Withdrawals |

- **Login Page**: `http://localhost:3000/auth/login`
- **Admin Dashboard**: `http://localhost:3000/admin`
- **Creator Studio**: `http://localhost:3000/creator`

---

## 🛡️ 5. Rules & Best Practices for AI Agents

When modifying or generating code in this repository, always follow these rules:

### 1. Cloudflare Workers Runtime Constraints
- The backend runs on Cloudflare Workers (V8 Edge Isolates). **Do NOT use Node.js-only packages** that rely on native C++ bindings (e.g. `better-sqlite3` must not be imported in worker request handlers).
- Use `c.env.DB` (Cloudflare D1) for all database operations via `drizzle-orm/d1`.
- Use `c.env.CACHE_KV` for caching and rate limiting.
- Worker entry point: `apps/backend/src/index.ts`.

### 2. Frontend Conventions (Nuxt 4)
- Use Vue 3 `<script setup lang="ts">`.
- Use Nuxt composables (`useApi()`, `useAppToast()`, `useAuthStore()`).
- Keep components modular inside `apps/frontend/app/components/`.
- Handle encrypted payloads when communicating with secure API actions via `encryptData()` / `decryptData()`.

### 3. Web3 & Payments (ERC-20 & Escrow)
- Follow the guidelines in `.skills/erc-skill.md`.
- Never assume `approve()` transfers tokens — it only grants allowance.
- Token movement must always be executed via `transferFrom()` inside escrow contracts.
- Always validate token allowance before calling escrow deposits.

### 4. Database Schema Changes
- Schema source files are located in `apps/backend/src/db/schema/`.
- Before adding a migration, inspect `apps/backend/drizzle/meta/_journal.json` to ensure continuous index numbering.
- After schema modifications, verify locally with `pnpm run db:migrate:local`.

---

## 🧼 6. Coding Style & Clean Architecture (សម្រាប់ងាយស្រួល Maintenance)

ដើម្បីឱ្យកូដងាយស្រួលអាន ងាយស្រួលកែប្រែ និង Maintenance បានយូរអង្វែង សូមអនុវត្តតាមគោលការណ៍ខាងក្រោម៖

### 1. Frontend (Nuxt 4 / Vue 3)
- **Single Responsibility**: Component នីមួយៗត្រូវធ្វើការតែមួយមុខច្បាស់លាស់។ ប្រសិនបើ Component វែងលើសពី ២០០-៣០០ បន្ទាត់ ត្រូវបំបែកវាជា Sub-components តូចៗក្នុង `components/<domain>/`។
- **Business Logic in Composables / Pinia**: កុំដាក់ Logic គណនាស្មុគស្មាញ ឬការ Fetch ទិន្នន័យច្រើននៅក្នុង `<template>` ឬ `<script setup>` ផ្ទាល់។ ត្រូវទាញវាទៅក្នុង Composables (`composables/use<Feature>.ts`) ឬ Pinia Store (`stores/<feature>.ts`)។
- **Shared Types**: ត្រូវប្រើប្រាស់ Type & Interface ចេញពី package `@ads-platform/shared`។ ហាមដាច់ខាតការប្រើ `any` នៅពេលដែលមាន Type រួចជាស្រេច។
- **3 Standard UI States**: រាល់ Page ឬ Component ដែលទាញយក Data ពី API ត្រូវតែមាន State ច្បាស់លាស់ចំនួន ៣៖
  1. `isLoading`: បង្ហាញ Skeleton Loader ឬ Spinner
  2. `isEmpty`: បង្ហាញ Empty State UI (icon + អត្ថបទពន្យល់ច្បាស់ៗ)
  3. `isError`: បង្ហាញ Error Message / Toast ច្បាស់លាស់ រួមជាមួយប៊ូតុង Retry

### 2. Backend (Hono / Cloudflare Workers)
- **Layered Architecture (3 ស្រទាប់ដាច់ពីគ្នា)**:
  1. **Route / Action Layer** (`src/actions/`, `src/routes/`): ទទួល Request, ផ្ទៀងផ្ទាត់ទិន្នន័យជាមួយ Zod Schema, និងបញ្ជូនបន្ត។ ហាមសរសេរ SQL ឬ Logic គណនាវែងអន្លាយនៅត្រង់នេះ។
  2. **Service Layer** (`src/services/`): ផ្ទុក Pure Business Logic (ដូចជាការគណនា, ការបញ្ជូន Notification, ការត្រួតពិនិត្យសិទ្ធិ)។
  3. **Data / DB Layer** (`src/db/`): ទាក់ទងជាមួយ Cloudflare D1 តាមរយៈ Drizzle ORM queries តែប៉ុណ្ណោះ។
- **Single Unified API Response Type (`ApiResponse<T>` — NO `data: any`)**: 
  - ❌ **ហាមដាច់ខាតការប្រើ `data: any`**: ព្រោះ `any` ធ្វើឱ្យបាត់បង់ Type-Safety រវាង Frontend និង Backend។
  - ✅ **ត្រូវប្រើ generic interface តែមួយគត់ `ApiResponse<T>` ចេញពី `@ads-platform/shared`**:
    - `ApiResponse<T>` = `{ code: 1 | 0, msg: string, time: number, data: T }`
    - ជោគជ័យ: `ApiResponse<T>` (ឧ. `ApiResponse<User>`, `ApiResponse<Campaign[]>`) តាមរយៈ `sendSuccess<T>(c, data, msg)`
    - បរាជ័យ: `ApiResponse<null>` (ទិន្នន័យ `data` ត្រូវតែជា `null`) តាមរយៈ `sendError(c, msg, null, status)`

---

## 🚫 7. គោលការណ៍ដាច់ខាត៖ ហាមប្រើ Mock Data នៅពេល API Error ឬ Empty

**STRICT RULE: NEVER USE MOCK / FAKE / HARDCODED DATA WHEN API FAILS OR RETURNS EMPTY.**

1. **នៅពេល API Error (បរាជ័យ):**
   - ❌ **ហាមដាច់ខាត:** មិនត្រូវយក Dummy / Mock Data មកជំនួសដើម្បីបន្លំភ្នែកនោះឡើយ (ឧទាហរណ៍៖ `catch (err) { items.value = mockItems }` គឺហាមដាច់ខាត!)។
   - ✅ **ត្រូវធ្វើ:** ទុក Data ជា `[]` ឬ `null`, បង្ហាញ Error Message ពិតប្រាកដតាមរយៈ Toast (`toast.error(...)`) ឬ Error Alert Card, និងផ្តល់ប៊ូតុង **"Try Again"** សម្រាប់ឱ្យ User អាចចុច Retry បាន។

2. **នៅពេល API ឆ្លើយតបជោគជ័យ តែទិន្នន័យទទេ (Empty `[]` ឬ `null`):**
   - ❌ **ហាមដាច់ខាត:** កុំបង្កើត Mock Items មកបង្ហាញជំនួសឱ្យសោះ។
   - ✅ **ត្រូវធ្វើ:** ត្រូវបង្ហាញ **Empty State UI** ពិតប្រាកដ (ឧ. រូប Icon ប្រអប់ទទេ + សារ "មិនទាន់មានទិន្នន័យនៅឡើយទេ" / "No items found")។

---

## 🌐 8. Language & Communication (ភាសា និងការប្រាស្រ័យទាក់ទង)

- **Always respond in Khmer (ឆ្លើយតបជាភាសាខ្មែរជានិច្ច)**:
  - AI Agents working on this project must **ALWAYS** respond and communicate with the user in **Khmer (ភាសាខ្មែរ)**.
  - All explanations, guides, troubleshooting steps, and architectural suggestions must be clearly presented in Khmer.
  - Code snippets, CLI commands, file paths, variables, and technical terms should remain in standard English for technical accuracy.
