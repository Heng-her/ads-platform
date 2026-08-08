# Ads Platform Backend API

A Cloudflare Workers & D1 database API built with **Hono**, **Drizzle ORM**, and **TypeScript**.

## Dev Server

Start local development server:

```bash
pnpm --filter backend dev
```

Base URL: `http://localhost:8787`

### Admin Upload Proxy

`POST /api/media/upload` is available only to authenticated `ADMIN` users for
the `campaigns`, `campaigns/covers`, `campaigns/gallery`, and
`campaigns/videos` folders. The proxy forwards the file to the upload service
with its bypass header held only in Worker secrets; browsers never receive it.

Configure these Worker secrets before deploying:

```bash
wrangler secret put UPLOAD_API_BASE_URL
wrangler secret put UPLOAD_API_KEY
wrangler secret put UPLOAD_API_BYPASS_SECRET
```

Set `UPLOAD_API_BASE_URL` to the upload service origin, without `/api`.

---

## Authentication

Protected routes require a Bearer token in the request header:

```http
Authorization: Bearer <YOUR_JWT_TOKEN>
```

---

## Standard Response Format

All endpoints return JSON in the following format:

**Success Response:**

```json
{
  "success": true,
  "data": { ... },
  "message": "Operation successful message"
}
```

**Error Response:**

```json
{
  "success": false,
  "error": "Error message details",
  "details": null
}
```

---

## REST API Endpoints

### 1. Health Check

- `GET /` - Public health check.

---

### 2. Authentication (`/api/auth`)

#### Register User

- **Endpoint:** `POST /api/auth/register`
- **Body:**

```json
{
  "username": "johndoe",
  "email": "john@example.com",
  "password": "password123",
  "role": "CREATOR" // "ADMIN" | "CREATOR" (Default: "CREATOR")
}
```

#### Login

- **Endpoint:** `POST /api/auth/login`
- **Body:**

```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

- **Response:** Returns `{ user, token }`.

---

### 3. Users (`/api/users`)

#### Get Current User Profile

- **Endpoint:** `GET /api/users/me`
- **Headers:** `Authorization: Bearer <token>`

#### List All Users (ADMIN Only)

- **Endpoint:** `GET /api/users`
- **Headers:** `Authorization: Bearer <token>`

#### Update User Status (ADMIN Only)

- **Endpoint:** `PATCH /api/users/:id/status`
- **Headers:** `Authorization: Bearer <token>`
- **Body:**

```json
{
  "status": "ACTIVE" // "ACTIVE" | "SUSPENDED" | "PENDING"
}
```

---

### 4. Campaigns (`/api/campaigns`)

#### List Campaigns

- **Endpoint:** `GET /api/campaigns?limit=3`
- **Next page:** `GET /api/campaigns?limit=3&cursor=<cursor>&snapshotAt=<timestamp>`
- Returns public, non-deleted campaigns ordered by `createdAt DESC, id DESC`.
  The first request creates `snapshotAt`; every subsequent request supplies that
  same value with the cursor so campaigns created later do not move into the
  active feed.

```json
{
  "code": 1,
  "data": {
    "items": [],
    "nextCursor": "eyJjcmVhdGVkQXQiOiIuLi4iLCJpZCI6Ii4uLiJ9",
    "hasMore": true,
    "snapshotAt": "2026-08-08T10:00:00.000Z"
  }
}
```

#### Count New Campaigns

- **Endpoint:** `GET /api/campaigns/new-count?snapshotAt=<timestamp>`
- Applies the same optional feed filters and returns `{ "count": 3 }` for
  public campaigns created after the active feed snapshot.

#### Create Campaign

- **Endpoint:** `POST /api/campaigns`
- **Headers:** `Authorization: Bearer <token>`
- **Body:**

```json
{
  "title": "Summer Promotion",
  "description": "Campaign description",
  "budget": 500,
  "dailyBudget": 50
}
```

#### Get Single Campaign

- **Endpoint:** `GET /api/campaigns/:id`
- **Headers:** `Authorization: Bearer <token>`

#### Update Campaign Status

- **Endpoint:** `PATCH /api/campaigns/:id/status`
- **Headers:** `Authorization: Bearer <token>`
- **Body:**

```json
{
  "status": "ACTIVE" // "DRAFT" | "PENDING_APPROVAL" | "ACTIVE" | "PAUSED" | "REJECTED" | "COMPLETED"
}
```

---

## Action Gateway API (`/api/action`)

In addition to REST endpoints, the backend provides a unified Action Gateway dispatcher.

### Dispatch Action (`POST /api/action`)

- **Headers:** `Authorization: Bearer <token>` (Required for protected actions)
- **Body:**

```json
{
  "action": "campaigns/create",
  "data": {
    "title": "Summer Promo",
    "budget": 500
  }
}
```

**Supported Actions:**

- `auth/register` (Public)
- `auth/login` (Public)
- `users/me` (Protected)
- `users/list` (ADMIN)
- `users/update-status` (ADMIN) - `data: { "id": "...", "status": "ACTIVE" }`
- `campaigns/list` (Protected)
- `campaigns/create` (Protected)
- `campaigns/get` (Protected) - `data: { "id": "..." }`
- `campaigns/update-status` (Protected) - `data: { "id": "...", "status": "ACTIVE" }`

### Delete Action (`DELETE /api/action`)

- **Body:**

```json
{
  "action": "campaigns/delete",
  "data": { "id": "<CAMPAIGN_ID>" }
}
```

---

## Hono RPC Client (TypeScript Frontend Integration)

In your frontend application:

```ts
import { hc } from "hono/client";
import type { AppType } from "backend";

const client = hc<AppType>("http://localhost:8787");

// Example: Login
const res = await client.api.auth.login.$post({
  json: { email: "john@example.com", password: "password123" },
});
const data = await res.json();
```
