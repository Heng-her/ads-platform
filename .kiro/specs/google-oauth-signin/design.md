# Google OAuth Sign-in / Sign-up Bugfix Design

## Overview

Seven defects prevent Google OAuth authentication from working and leave the email/password
login form wired to mock data. The fix implements the full OAuth 2.0 Authorization Code Flow
on the backend (two new Hono routes, no new npm packages), wires the Google buttons on both
auth pages, replaces the mock `setTimeout` in `login.vue` with a real API call, creates a
frontend `/auth/callback` page that receives the JWT from the redirect, makes `passwordHash`
nullable so OAuth-only accounts can be stored, and adds three new environment variables.

The fix is strictly additive on the backend (new routes, nullable column migration) and
surgical on the frontend (button wiring + real API call + one new page). No existing routes,
middleware, or JWT logic are changed.

## Glossary

- **Bug_Condition (C)**: Any of the seven defect conditions defined in the requirements (1.1–1.7).
- **Property (P)**: The desired observable behavior when a buggy input is supplied to the fixed code.
- **Preservation**: All existing behaviors (3.1–3.7) that must continue to work unchanged after the fix.
- **AuthService**: The class in `apps/backend/src/services/authService.ts` that handles register/login logic.
- **AuthRoutes**: The Hono router in `apps/backend/src/routes/authRoutes.ts` that exposes auth endpoints.
- **CloudflareBindings**: The TypeScript interface in `apps/backend/src/types/env.ts` describing all env vars.
- **handleLoginResponse**: The Pinia auth store action that encrypts and persists a login response.
- **state param**: A random CSRF token stored in KV with a 10-minute TTL, used to validate the OAuth callback.
- **PKCE**: Not used — standard Authorization Code Flow with `state` CSRF protection is sufficient here.

## OAuth Flow Diagram

```
Browser                 Backend (Hono/CF Workers)         Google OAuth          Frontend (Nuxt)
  |                              |                              |                      |
  |-- click "Sign in w/ Google" ->|                              |                      |
  |                    GET /api/auth/google                      |                      |
  |                    1. generate random `state`                |                      |
  |                    2. store state in KV (10-min TTL)         |                      |
  |                    3. build Google auth URL                   |                      |
  |<-- 302 redirect to Google auth URL --                        |                      |
  |                              |                              |                      |
  |--------------- browser navigates to Google auth ------------>|                      |
  |<-------------- Google shows consent screen ------------------|                      |
  |--------------- user consents ------------------------------>|                      |
  |<----- 302 redirect to /api/auth/google/callback?code=X&state=Y ------------------|  |
  |                              |                              |                      |
  |-- GET /api/auth/google/callback?code=X&state=Y ------------>|                      |
  |                    1. validate `state` against KV; delete    |                      |
  |                    2. POST to Google token endpoint          |                      |
  |                       (Fetch API, no library)                |                      |
  |                    3. GET Google userinfo endpoint           |                      |
  |                    4. find or create user in D1              |                      |
  |                    5. generateToken (existing util)          |                      |
  |<-- 302 redirect to {FRONTEND_URL}/auth/callback?token=JWT -->|                      |
  |                              |                              |                      |
  |------- browser navigates to /auth/callback?token=JWT ------------------------------>|
  |                                                                     1. read token   |
  |                                                                     2. GET /api/me  |
  |                                                                     3. handleLogin  |
  |                                                                     4. navigateTo('/')|
```


## Bug Details

### Bug Condition

The bugs manifest across seven distinct conditions (1.1–1.7). For testing purposes the bug
condition is divided into two groups:

**Group A — Missing Infrastructure** (backend routes + schema + frontend page)
Conditions 1.1, 1.2, 1.4, 1.5, 1.6, 1.7: these require new code to be written.

**Group B — Wrong Implementation** (mock login instead of real API)
Condition 1.3: the `handleSubmit` function in `login.vue` uses `setTimeout` with hardcoded
data instead of calling `/api/auth/login`.

**Formal Specification:**

```
FUNCTION isBugCondition(input)
  INPUT: input — a user action or system request
  OUTPUT: boolean

  RETURN (
    -- 1.1 / 1.2: Google button clicked but no navigation occurs
    (input.action == "clickGoogleButton" AND noNavigationOccurs())

    -- 1.3: Login form submitted but real API is not called
    OR (input.action == "submitLoginForm"
        AND input.credentials are valid email+password
        AND realApiWasNotCalled())

    -- 1.4: Callback route missing
    OR (input.method == "GET"
        AND input.path == "/api/auth/google/callback"
        AND routeDoesNotExist())

    -- 1.5: Initiate route missing
    OR (input.method == "GET"
        AND input.path == "/api/auth/google"
        AND routeDoesNotExist())

    -- 1.6: OAuth user insert fails on NOT NULL hash
    OR (input.action == "insertOAuthUser"
        AND input.passwordHash IS NULL
        AND dbConstraintViolationThrown())

    -- 1.7: Callback page missing
    OR (input.path == "/auth/callback"
        AND input.queryParam.token IS NOT NULL
        AND pageDoesNotExist())
  )
END FUNCTION
```

### Examples

- **Bug 1.1/1.2**: User clicks "Sign in with Google" on `/login` → nothing happens. No `onclick` handler, no navigation.
- **Bug 1.3**: User types `creator@newplatform.com` + valid password, submits → sees spinner for 1 s, gets logged in as a hardcoded user. Real `/api/auth/login` is never called.
- **Bug 1.4**: Google completes OAuth and redirects to `https://api.example.com/api/auth/google/callback?code=abc&state=xyz` → backend returns HTTP 404.
- **Bug 1.5**: Frontend navigates to `/api/auth/google` (after fix) → backend returns HTTP 404 today.
- **Bug 1.6**: Code path tries `db.insert(users).values({ ..., passwordHash: null })` → D1 throws `NOT NULL constraint failed: users.password_hash`.
- **Bug 1.7**: Backend redirects to `https://app.example.com/auth/callback?token=jwt` → Nuxt returns 404, token is lost.


## Expected Behavior

### Preservation Requirements

**Unchanged Behaviors:**
- Email/password registration via `POST /api/auth/register` continues to hash the password with bcrypt and return a JWT (Requirement 3.1).
- Email/password login via `POST /api/auth/login` continues to verify the bcrypt hash and return a JWT (Requirement 3.2).
- Invalid credential login continues to return "Invalid email or password" without leaking which field is wrong (Requirement 3.3).
- Suspended account login continues to return "Account has been suspended" (Requirement 3.4).
- Admin registration without correct `x-admin-secret` header continues to return 403 (Requirement 3.5).
- Rate limiting on the register endpoint continues to block excess requests (Requirement 3.6).
- Existing JWT middleware continues to validate tokens on protected routes without any change (Requirement 3.7).

**Scope:**
All inputs that do NOT involve Google OAuth flows or the mock login form are completely
unaffected. This includes:
- Any `POST /api/auth/register` or `POST /api/auth/login` request
- Any request to protected routes bearing a JWT
- Any admin-creation request
- The register.vue form submission (currently mock; not part of this fix scope — only login.vue mock is fixed)


## Hypothesized Root Cause

1. **No Google button click handlers (1.1, 1.2)**: The `<button>` elements in `login.vue` and `register.vue` have no `@click` handlers. They render but do nothing. Fix: add `@click="navigateTo('/api/auth/google', { external: true })"` (full-page navigation, not a Nuxt client-side route change, so the backend receives the request).

2. **Missing backend OAuth routes (1.4, 1.5)**: `authRoutes.ts` defines only `/register` and `/login`. No `.get('/google', ...)` or `.get('/google/callback', ...)` handlers exist. Fix: add two new GET handlers, either inline in `authRoutes.ts` or in a new `oauthRoutes.ts` file mounted at the same prefix.

3. **`passwordHash NOT NULL` schema constraint (1.6)**: The Drizzle schema declares `passwordHash: text("password_hash").notNull()`. OAuth users have no password. Fix: remove `.notNull()` and run a D1 migration to `ALTER TABLE users ALTER COLUMN password_hash DROP NOT NULL` (or recreate with a nullable column in SQLite). The `login()` method in `AuthService` must also guard against a `null` hash to avoid passing `null` to `bcrypt.compare`.

4. **Mock `setTimeout` in login.vue (1.3)**: `handleSubmit` is entirely local — no `useApi()` call, no `fetch`. Fix: rewrite to call the Hono RPC client (`useApi().api.auth.login.$post(...)`) and call `authStore.handleLoginResponse` on success, setting a reactive error message on failure.

5. **Missing `/auth/callback` Nuxt page (1.7)**: No file exists at `apps/frontend/app/pages/(auth)/callback.vue` or `apps/frontend/app/pages/auth/callback.vue`. Fix: create the page with a `useRoute` to read `?token`, call `/api/me` (or `/api/users/me`) to fetch the user profile, then `handleLoginResponse` + `navigateTo('/')`.

6. **No `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, `FRONTEND_URL` bindings (all OAuth routes)**: These are missing from `.dev.vars` and from the `CloudflareBindings` TypeScript interface. Fix: add them to both.


## Correctness Properties

Property 1: Bug Condition — Google OAuth Routes Respond and Complete the Flow

_For any_ request that triggers the bug condition (isBugCondition returns true), the fixed
system SHALL: (a) navigate the browser to Google when the OAuth button is clicked; (b) return
HTTP 302 from `/api/auth/google` pointing to Google's authorization URL; (c) return HTTP 302
from `/api/auth/google/callback` pointing to `{FRONTEND_URL}/auth/callback?token=<jwt>` after
successfully validating state, exchanging the code, and finding/creating the user; (d) accept
a `null` `passwordHash` without throwing a DB constraint error; (e) successfully store the
JWT and redirect to the dashboard when `/auth/callback` loads with a valid token; (f) call the
real `/api/auth/login` endpoint on login form submission and store the returned user.

**Validates: Requirements 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7**

Property 2: Preservation — Existing Auth Behavior Is Unchanged

_For any_ input where the bug condition does NOT hold (isBugCondition returns false) — that is,
any request to `/api/auth/register`, `/api/auth/login`, any protected-route JWT validation,
or any rate-limited registration — the fixed system SHALL produce exactly the same observable
response as the original system, preserving all credential validation, error messages, admin
guards, rate limiting, and JWT middleware behavior.

**Validates: Requirements 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7**


## Fix Implementation

### Changes Required

#### 1. `apps/backend/src/types/env.ts` — Add new env vars

**Specific Changes:**
- Add `GOOGLE_CLIENT_ID: string` to `CloudflareBindings`
- Add `GOOGLE_CLIENT_SECRET: string` to `CloudflareBindings`
- Add `FRONTEND_URL: string` to `CloudflareBindings`

#### 2. `apps/backend/.dev.vars` — Add placeholder values

**Specific Changes:**
- Add `GOOGLE_CLIENT_ID=your-google-client-id`
- Add `GOOGLE_CLIENT_SECRET=your-google-client-secret`
- Add `FRONTEND_URL=http://localhost:3000`

#### 3. `apps/backend/src/db/schema/users.ts` — Make passwordHash nullable

**Specific Changes:**
- Remove `.notNull()` from `passwordHash` field: `passwordHash: text("password_hash")`
- This changes the inferred `NewUser` type so `passwordHash` becomes optional

#### 4. D1 Migration — SQLite schema update

**Specific Changes:**
- Create migration file (e.g., `apps/backend/migrations/0002_nullable_password_hash.sql`)
- SQLite does not support `ALTER COLUMN`; migration recreates the table or uses a column rename workaround
- Practical approach: add a new nullable column, copy data, drop old, rename — or use Drizzle `migrate`

#### 5. `apps/backend/src/services/authService.ts` — Guard null hash in login()

**Specific Changes:**
- After fetching the user, add: `if (!user.passwordHash) { throw new Error("Invalid email or password") }`
- This prevents `bcrypt.compare(password, null)` which would throw a runtime error for OAuth users

#### 6. `apps/backend/src/routes/authRoutes.ts` (or new `oauthRoutes.ts`) — Add OAuth routes

**New Route: `GET /google`**
```
1. generate state = crypto.randomUUID()
2. await c.env.CACHE_KV.put(`oauth_state:${state}`, "1", { expirationTtl: 600 })
3. build URL:
   https://accounts.google.com/o/oauth2/v2/auth
   ?client_id={GOOGLE_CLIENT_ID}
   &redirect_uri={encodeURIComponent(backendCallbackUrl)}
   &response_type=code
   &scope=openid%20email%20profile
   &state={state}
4. return c.redirect(authUrl)
```

**New Route: `GET /google/callback`**
```
1. read code, state from query params
2. storedState = await c.env.CACHE_KV.get(`oauth_state:${state}`)
   if (!storedState) return sendError(c, "Invalid or expired state", null, 400)
3. await c.env.CACHE_KV.delete(`oauth_state:${state}`)
4. tokenRes = await fetch("https://oauth2.googleapis.com/token", {
     method: "POST", body: new URLSearchParams({
       code, client_id, client_secret, redirect_uri, grant_type: "authorization_code"
     })
   })
   if (!tokenRes.ok) return sendError(c, "Token exchange failed", null, 400)
5. { access_token } = await tokenRes.json()
6. profileRes = await fetch("https://www.googleapis.com/oauth2/v3/userinfo",
     { headers: { Authorization: `Bearer ${access_token}` } })
   { email, name, picture } = await profileRes.json()
7. existing = db.select().from(users).where(eq(users.email, email)).get()
   if (!existing) {
     userId = crypto.randomUUID()
     username = email.split("@")[0] + "_" + userId.slice(0, 6)  // ensure uniqueness
     db.insert(users).values({ id: userId, username, email,
       passwordHash: null, avatar: picture, role: "CREATOR", status: "ACTIVE" })
   } else { userId = existing.id }
8. token = await generateToken({ id: userId, email, role }, jwtSecret)
9. return c.redirect(`${FRONTEND_URL}/auth/callback?token=${token}`)
```

#### 7. `apps/frontend/app/pages/(auth)/login.vue` — Fix Google button + real login

**Specific Changes:**
- Google button: add `@click="navigateTo('/api/auth/google', { external: true })"`
- Replace entire `handleSubmit` function:
  - call `useApi().api.auth.login.$post({ json: { email, password } })`
  - on success (HTTP 200): call `authStore.handleLoginResponse(data.data)`, then `navigateTo('/')`
  - on error: show error message in a reactive `errorMessage` ref displayed in the template
  - manage `loading` state around the call

#### 8. `apps/frontend/app/pages/(auth)/register.vue` — Fix Google button

**Specific Changes:**
- Google button: add `@click="navigateTo('/api/auth/google', { external: true })"`

#### 9. `apps/frontend/app/pages/auth/callback.vue` — New page

**Specific Changes:**
- Read `token` from `useRoute().query.token`
- If no token, `navigateTo('/login')`
- Call backend `/api/me` (needs a new `GET /me` protected route) or `/api/users/me`
  to fetch the full user profile using the token as `Authorization: Bearer`
- Call `authStore.handleLoginResponse({ user, token, expiresAt })`
- `navigateTo('/')`

#### 10. `apps/backend/src/routes/authRoutes.ts` — New `GET /me` endpoint

**Specific Changes:**
- Add authenticated `GET /me` route (behind existing JWT middleware) that returns the
  current user's profile from D1, used by the frontend callback page


## Testing Strategy

### Validation Approach

Testing follows a two-phase approach: first surface counterexamples that confirm each defect
on unfixed code, then verify the fix satisfies Property 1 (bug condition fixed) and
Property 2 (existing behavior preserved). Because this feature spans HTTP routes, database
constraints, and frontend navigation, tests are split across unit, property-based, and
integration layers.

### Exploratory Bug Condition Checking

**Goal**: Confirm all seven defects exist on unfixed code before implementing anything.

**Test Plan**: Write tests against the current codebase to observe each failure mode.

**Test Cases:**

1. **Google button no-op test** (1.1/1.2): Mount `login.vue` in a component test harness, simulate a click on the Google button, assert that `window.location.href` changed — will fail because no handler exists.

2. **Mock login test** (1.3): Mount `login.vue`, fill in email/password, submit the form, assert that `fetch` or the Hono RPC client was called with `POST /api/auth/login` — will fail because `handleSubmit` uses `setTimeout` only.

3. **Route 404 tests** (1.4/1.5): Send `GET /api/auth/google` and `GET /api/auth/google/callback` to the Hono app — both return 404 on unfixed code.

4. **Nullable passwordHash test** (1.6): Attempt to insert a user with `passwordHash: null` into the test database — will throw `NOT NULL constraint failed`.

5. **Frontend callback 404 test** (1.7): Navigate to `/auth/callback?token=x` in the Nuxt app — returns 404 because the page file doesn't exist.

**Expected Counterexamples:**
- Google button click handler is absent → no navigation
- `handleSubmit` never calls fetch/RPC → mock data returned
- Both OAuth routes return 404 → missing route handlers
- DB insert with null hash throws constraint error
- `/auth/callback` renders 404

### Fix Checking

**Goal**: Verify Property 1 — all buggy inputs produce correct behavior after the fix.

**Pseudocode:**
```
FOR ALL input WHERE isBugCondition(input) DO
  result := fixedSystem(input)
  ASSERT expectedBehavior(result)
END FOR
```

**Test Cases:**

1. `GET /api/auth/google` returns HTTP 302 with `Location` pointing to `accounts.google.com` and includes a `state` param; KV contains that state key.
2. `GET /api/auth/google/callback?code=<valid>&state=<valid>` (with Google token exchange mocked) returns HTTP 302 to `{FRONTEND_URL}/auth/callback?token=<jwt>`.
3. Invalid `state` in callback returns HTTP 400.
4. Expired `state` (KV entry gone) returns HTTP 400.
5. New user created via OAuth has `passwordHash = null` in D1 without constraint error.
6. Existing user found by email — no duplicate row created; JWT issued for existing `id`.
7. `login.vue` Google button click triggers `navigateTo('/api/auth/google', { external: true })`.
8. `login.vue` form submit calls RPC client with correct credentials; on 200, `handleLoginResponse` is called and browser navigates to `/`.
9. `login.vue` form submit on 401 sets `errorMessage` ref to the error from the API.
10. `/auth/callback?token=<jwt>` page fetches `/api/me` with `Authorization: Bearer <jwt>`, calls `handleLoginResponse`, navigates to `/`.

### Preservation Checking

**Goal**: Verify Property 2 — all non-buggy inputs behave identically before and after the fix.

**Pseudocode:**
```
FOR ALL input WHERE NOT isBugCondition(input) DO
  ASSERT originalSystem(input) = fixedSystem(input)
END FOR
```

**Testing Approach**: Property-based testing is recommended for preservation checking because:
- It generates many test cases automatically across the input domain
- It catches edge cases that manual unit tests might miss
- It provides strong guarantees that behavior is unchanged for all non-buggy inputs

**Test Cases:**

1. **Password register preservation**: Generate random valid `{ username, email, password }` inputs and assert `POST /api/auth/register` returns 200 with a user and JWT both before and after the fix.
2. **Password login preservation**: Generate random `{ email, password }` pairs — both valid credentials and invalid — and assert the same response codes and error messages before and after the fix.
3. **Suspended account preservation**: Assert that a suspended user attempting login gets the same "Account has been suspended" error.
4. **Admin secret guard preservation**: Assert that requests to register an ADMIN without the correct header return 403 unchanged.
5. **Rate limiter preservation**: Assert that the rate limiter still blocks excess registration requests (integration test with real KV state).
6. **JWT middleware preservation**: Assert that protected routes with valid/invalid tokens continue to return 200/401 unchanged.
7. **Null hash login guard**: After the schema change, assert that a user whose `passwordHash` is `null` attempting email/password login receives "Invalid email or password" (not a crash).

### Unit Tests

- `GET /google` route: state is stored in KV, redirect URL contains all required query params (`client_id`, `redirect_uri`, `response_type=code`, `scope`, `state`).
- `GET /google/callback` route: state validation (valid, invalid, missing), token exchange (success, Google error), user find vs create logic, JWT generation.
- `AuthService.login()`: null `passwordHash` guard throws the correct error message.
- Drizzle schema: `NewUser` type allows `passwordHash: null | undefined`.
- `/auth/callback` Nuxt page: missing token redirects to `/login`; valid token flow calls API and store.

### Property-Based Tests

- Generate random valid registration payloads; assert register endpoint always returns 201 with a non-empty token.
- Generate random email/password pairs; assert login endpoint returns either a valid JWT (for matching credentials) or a 401 with the correct error message — never a 500.
- Generate random `state` strings; assert that a callback with a state not in KV always returns 400, regardless of other query params.
- Generate random users with `passwordHash = null`; assert they can be inserted and that attempting email login for them returns 401 (not a 500 crash).

### Integration Tests

- Full happy-path OAuth flow (Google endpoints mocked with `msw` or Miniflare fetch mock): click → `/api/auth/google` → Google consent (mock) → `/api/auth/google/callback` → `/auth/callback` → dashboard.
- New OAuth user: assert user row exists in D1 with `passwordHash = null` and `status = ACTIVE`.
- Returning OAuth user: assert no duplicate row created; same `id` used in JWT.
- Login form real API: submit valid credentials in `login.vue` → real `POST /api/auth/login` is called → JWT stored in Pinia → redirected to `/`.
- Login form error: submit invalid credentials → API returns 401 → error message displayed in UI → user not redirected.

### Google Cloud Console Setup Guide

To obtain `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`:

1. Go to [https://console.cloud.google.com](https://console.cloud.google.com).
2. Create a new project or select an existing one.
3. Navigate to **APIs & Services → Library**, search for "Google Identity" or "Google+ API" and enable it.
4. Navigate to **APIs & Services → Credentials → Create Credentials → OAuth 2.0 Client ID**.
5. Set **Application type** to **Web application**.
6. Under **Authorized redirect URIs**, add:
   - `http://localhost:8787/api/auth/google/callback` (local development)
   - `https://<your-worker>.workers.dev/api/auth/google/callback` (production)
7. Click **Create**. Copy the **Client ID** and **Client Secret**.
8. Add them to `apps/backend/.dev.vars`:
   ```
   GOOGLE_CLIENT_ID=<paste-client-id>
   GOOGLE_CLIENT_SECRET=<paste-client-secret>
   FRONTEND_URL=http://localhost:3000
   ```
9. For production, add the same variables in the Cloudflare dashboard under **Workers → Settings → Variables**.
