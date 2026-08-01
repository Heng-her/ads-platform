# Implementation Plan

- [ ] 1. Write bug condition exploration test
  - **Property 1: Bug Condition** - Google OAuth & Mock Login Defects
  - **CRITICAL**: This test MUST FAIL on unfixed code — failure confirms the bugs exist
  - **DO NOT attempt to fix the test or the code when it fails**
  - **NOTE**: This test encodes the expected behavior — it will validate the fix when it passes after implementation
  - **GOAL**: Surface counterexamples that demonstrate all seven defects exist
  - **Scoped PBT Approach**: For deterministic bugs (missing routes, null constraint, mock login), scope the property to the concrete failing cases
  - Test 1.1/1.2: Mount `login.vue` and `register.vue`, simulate a click on each Google button, assert `navigateTo` was called with `'/api/auth/google'` — FAILS (no click handler)
  - Test 1.3: Mount `login.vue`, fill in valid email + password, submit the form, assert that the Hono RPC client (`useApi().api.auth.login.$post`) was called — FAILS (only `setTimeout` runs)
  - Test 1.4/1.5: Send `GET /api/auth/google` and `GET /api/auth/google/callback` to the Hono app — assert both return HTTP 302 — FAILS (both return 404)
  - Test 1.6: Attempt `db.insert(users).values({ ..., passwordHash: null })` — assert no exception is thrown — FAILS (NOT NULL constraint violation)
  - Test 1.7: Navigate to `/auth/callback?token=test-token` in Nuxt — assert a 200 response — FAILS (page does not exist, 404)
  - Run all tests on UNFIXED code
  - **EXPECTED OUTCOME**: Tests FAIL (this is correct — it proves all seven defects exist)
  - Document counterexamples found:
    - Google button click — no navigation triggered
    - Login form submit — `fetch`/RPC never called, mock data returned
    - `GET /api/auth/google` — 404
    - `GET /api/auth/google/callback` — 404
    - DB insert with `passwordHash: null` — throws constraint error
    - `/auth/callback` — Nuxt 404
  - Mark task complete when tests are written, run, and failures are documented
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7_

- [ ] 2. Write preservation property tests (BEFORE implementing fix)
  - **Property 2: Preservation** - Existing Auth Behavior Is Unchanged
  - **IMPORTANT**: Follow observation-first methodology
  - Observe behavior on UNFIXED code for all non-OAuth inputs (inputs where `isBugCondition` returns false)
  - Observe: `POST /api/auth/register` with valid payload returns 201 + JWT on unfixed code
  - Observe: `POST /api/auth/login` with valid credentials returns 200 + JWT on unfixed code
  - Observe: `POST /api/auth/login` with invalid credentials returns 401 + "Invalid email or password" on unfixed code
  - Observe: `POST /api/auth/login` for a suspended account returns 403 + "Account has been suspended" on unfixed code
  - Observe: `POST /api/auth/register` for ADMIN role without `x-admin-secret` header returns 403 on unfixed code
  - Observe: protected route with valid JWT returns 200; with invalid/missing JWT returns 401 on unfixed code
  - Write property-based tests capturing observed behavior patterns from Preservation Requirements (3.1–3.7):
    - Generate random valid `{ username, email, password }` — assert `POST /api/auth/register` always returns 201 with a non-empty token
    - Generate random `{ email, password }` pairs (valid + invalid) — assert `POST /api/auth/login` returns either 200+JWT or 401 with correct error message, never a 500
    - Assert suspended user login always returns the same error string
    - Assert admin guard always returns 403 without the correct header
    - Assert JWT middleware returns 401 for any tampered or absent token
  - Write null-hash guard test: after schema change (task 5), a user with `passwordHash = null` attempting `POST /api/auth/login` should receive 401 "Invalid email or password" — not a crash
  - Run all preservation tests on UNFIXED code (except null-hash guard which is run after schema change)
  - **EXPECTED OUTCOME**: Tests PASS on unfixed code (this confirms the baseline behavior to preserve)
  - Mark task complete when tests are written, run, and passing on unfixed code
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7_

- [ ] 3. Backend infrastructure — env, schema, and null-hash guard

  - [ ] 3.1 Add new environment variable types to `CloudflareBindings`
    - Open `apps/backend/src/types/env.ts`
    - Add `GOOGLE_CLIENT_ID: string` to the `CloudflareBindings` interface
    - Add `GOOGLE_CLIENT_SECRET: string` to the `CloudflareBindings` interface
    - Add `FRONTEND_URL: string` to the `CloudflareBindings` interface
    - _Bug_Condition: isBugCondition covers all OAuth routes that reference these bindings (1.4, 1.5)_
    - _Expected_Behavior: OAuth route handlers can access `c.env.GOOGLE_CLIENT_ID`, `c.env.GOOGLE_CLIENT_SECRET`, `c.env.FRONTEND_URL` without TypeScript errors_
    - _Preservation: No existing binding removed or renamed — register/login routes unaffected (3.1–3.7)_
    - _Requirements: 2.4, 2.5_

  - [ ] 3.2 Add placeholder values to `.dev.vars`
    - Open `apps/backend/.dev.vars`
    - Add `GOOGLE_CLIENT_ID=your-google-client-id`
    - Add `GOOGLE_CLIENT_SECRET=your-google-client-secret`
    - Add `FRONTEND_URL=http://localhost:3000`
    - _Bug_Condition: OAuth routes will throw at runtime if these vars are absent_
    - _Expected_Behavior: Local development worker starts without binding errors_
    - _Preservation: Existing vars (`JWT_SECRET`, `DB`, `CACHE_KV`, etc.) are unchanged_
    - _Requirements: 2.4, 2.5_

  - [ ] 3.3 Make `passwordHash` nullable in the Drizzle schema
    - Open `apps/backend/src/db/schema/users.ts`
    - Remove `.notNull()` from the `passwordHash` field: change to `passwordHash: text("password_hash")`
    - Verify the inferred `NewUser` type now allows `passwordHash: null | undefined`
    - _Bug_Condition: `isBugCondition` — `input.action == "insertOAuthUser" AND input.passwordHash IS NULL AND dbConstraintViolationThrown()` (1.6)_
    - _Expected_Behavior: `db.insert(users).values({ ..., passwordHash: null })` succeeds without a constraint error_
    - _Preservation: `NewUser` with a non-null `passwordHash` (email/password register) continues to work identically (3.1)_
    - _Requirements: 2.6_

  - [ ] 3.4 Create D1 SQL migration for nullable `password_hash`
    - Create `apps/backend/migrations/0002_nullable_password_hash.sql`
    - SQLite does not support `ALTER COLUMN DROP NOT NULL` directly; use the standard SQLite table-rebuild pattern:
      1. `CREATE TABLE users_new (... password_hash TEXT, ...)` with all columns from the original but `password_hash` without `NOT NULL`
      2. `INSERT INTO users_new SELECT * FROM users`
      3. `DROP TABLE users`
      4. `ALTER TABLE users_new RENAME TO users`
    - _Bug_Condition: Without the migration the runtime D1 database still enforces NOT NULL even after the schema file change (1.6)_
    - _Expected_Behavior: After running the migration, existing rows are intact and new rows with `password_hash = NULL` are accepted_
    - _Preservation: All other column constraints (`PRIMARY KEY`, `UNIQUE`, `NOT NULL` on other columns) remain identical (3.1–3.7)_
    - _Requirements: 2.6_

  - [ ] 3.5 Add null-hash guard in `AuthService.login()`
    - Open `apps/backend/src/services/authService.ts`
    - After fetching the user record by email, add: `if (!user.passwordHash) { throw new Error("Invalid email or password") }`
    - This must be placed before the `bcrypt.compare` call to prevent a runtime crash when an OAuth-only account attempts password login
    - _Bug_Condition: After schema change, `bcrypt.compare(password, null)` would throw at runtime for OAuth users_
    - _Expected_Behavior: OAuth users attempting email/password login receive 401 "Invalid email or password" — not a 500 crash_
    - _Preservation: Users with a valid `passwordHash` continue through `bcrypt.compare` exactly as before (3.2, 3.3)_
    - _Requirements: 2.6, 3.2, 3.3_

- [ ] 4. Backend — new OAuth routes and `/api/me` endpoint

  - [ ] 4.1 Add `GET /google` OAuth initiation route
    - Open `apps/backend/src/routes/authRoutes.ts` (or create `apps/backend/src/routes/oauthRoutes.ts` and mount it at the same prefix)
    - Implement the handler:
      1. `const state = crypto.randomUUID()`
      2. `await c.env.CACHE_KV.put(\`oauth_state:${state}\`, "1", { expirationTtl: 600 })`
      3. Build `authUrl` using `https://accounts.google.com/o/oauth2/v2/auth` with params: `client_id`, `redirect_uri` (the backend callback URL), `response_type=code`, `scope=openid email profile`, `state`
      4. `return c.redirect(authUrl)`
    - _Bug_Condition: `isBugCondition` — `input.method == "GET" AND input.path == "/api/auth/google" AND routeDoesNotExist()` (1.5)_
    - _Expected_Behavior: `GET /api/auth/google` returns HTTP 302 with `Location` pointing to `accounts.google.com` and a `state` param; KV contains `oauth_state:<state>` key_
    - _Preservation: No existing route is modified; `/register` and `/login` are unchanged (3.1–3.7)_
    - _Requirements: 2.5_

  - [ ] 4.2 Add `GET /google/callback` OAuth callback route
    - Implement the handler (inline or in the same file as 4.1):
      1. Read `code` and `state` from query params
      2. `const storedState = await c.env.CACHE_KV.get(\`oauth_state:${state}\`)` — if null, return 400 "Invalid or expired state"
      3. `await c.env.CACHE_KV.delete(\`oauth_state:${state}\`)` (consume the state token)
      4. Exchange code: `POST https://oauth2.googleapis.com/token` with `{ code, client_id, client_secret, redirect_uri, grant_type: "authorization_code" }` using the Fetch API only (no OAuth library)
      5. If token exchange fails, return 400 "Token exchange failed"
      6. Extract `access_token`; call `GET https://www.googleapis.com/oauth2/v3/userinfo` with `Authorization: Bearer <access_token>`
      7. Extract `{ email, name, picture }` from profile
      8. `SELECT` from `users` WHERE `email = email`; if not found, insert new user with `passwordHash: null`, `role: "CREATOR"`, `status: "ACTIVE"`, unique username
      9. `const token = await generateToken({ id: userId, email, role }, c.env.JWT_SECRET)`
      10. `return c.redirect(\`${c.env.FRONTEND_URL}/auth/callback?token=${token}\`)`
    - _Bug_Condition: `isBugCondition` — `input.method == "GET" AND input.path == "/api/auth/google/callback" AND routeDoesNotExist()` (1.4)_
    - _Expected_Behavior: Valid code + state → HTTP 302 to `{FRONTEND_URL}/auth/callback?token=<jwt>`; invalid/expired state → HTTP 400; duplicate email → reuses existing user row_
    - _Preservation: No existing route modified; JWT format produced by `generateToken` is identical to what email/password login produces (3.7)_
    - _Requirements: 2.4, 2.6_

  - [ ] 4.3 Add `GET /me` authenticated endpoint
    - Add a new route `GET /me` (behind the existing JWT middleware) to `authRoutes.ts`
    - Handler: select the current user from D1 by `id` from the JWT payload; return the user record (excluding `passwordHash`)
    - This endpoint is used by the frontend `/auth/callback` page to hydrate the Pinia store
    - _Bug_Condition: Without `/api/me`, the frontend `/auth/callback` page has no way to fetch the user profile after receiving the token (1.7 dependency)_
    - _Expected_Behavior: `GET /api/me` with valid `Authorization: Bearer <jwt>` returns the user's profile; missing/invalid JWT returns 401_
    - _Preservation: Existing JWT middleware is reused without modification (3.7)_
    - _Requirements: 2.7_

- [ ] 5. Frontend — fix Google buttons, login form, and callback page

  - [ ] 5.1 Wire the Google button in `login.vue`
    - Open `apps/frontend/app/pages/(auth)/login.vue`
    - Find the "Sign in with Google" button element
    - Add `@click="navigateTo('/api/auth/google', { external: true })"` to the button
    - This triggers a full-page navigation (not a Nuxt client-side route) so the browser sends the request to the backend
    - _Bug_Condition: `isBugCondition` — `input.action == "clickGoogleButton" AND noNavigationOccurs()` (1.1)_
    - _Expected_Behavior: Clicking the button navigates the browser to `/api/auth/google`_
    - _Preservation: The email/password form inputs and submission are unaffected by this change_
    - _Requirements: 2.1_

  - [ ] 5.2 Replace the mock `handleSubmit` in `login.vue` with a real API call
    - In the same `login.vue` file, replace the entire `handleSubmit` function
    - New implementation:
      1. Set `loading.value = true`, clear `errorMessage.value`
      2. Call `const res = await useApi().api.auth.login.$post({ json: { email: email.value, password: password.value } })`
      3. If response is OK: call `authStore.handleLoginResponse(data.data)`, then `navigateTo('/')`
      4. If response is not OK: set `errorMessage.value` to the error message from the API response body
      5. Set `loading.value = false` in a `finally` block
    - Add a reactive `errorMessage` ref (if not already present) and render it in the template below the submit button
    - _Bug_Condition: `isBugCondition` — `input.action == "submitLoginForm" AND input.credentials are valid email+password AND realApiWasNotCalled()` (1.3)_
    - _Expected_Behavior: Form submit calls `POST /api/auth/login`; success stores JWT and redirects to `/`; failure shows error message_
    - _Preservation: Form validation, loading state, and button disabled state behavior are preserved; register form is not touched (3.1)_
    - _Requirements: 2.3_

  - [ ] 5.3 Wire the Google button in `register.vue`
    - Open `apps/frontend/app/pages/(auth)/register.vue`
    - Find the "Sign up with Google" button element
    - Add `@click="navigateTo('/api/auth/google', { external: true })"` to the button
    - _Bug_Condition: `isBugCondition` — `input.action == "clickGoogleButton" AND noNavigationOccurs()` (1.2)_
    - _Expected_Behavior: Clicking the button navigates the browser to `/api/auth/google`_
    - _Preservation: The email/password registration form and its submission logic are unaffected_
    - _Requirements: 2.2_

  - [ ] 5.4 Create the `/auth/callback` Nuxt page
    - Create new file `apps/frontend/app/pages/auth/callback.vue`
    - Page logic (run in `onMounted` or `setup`):
      1. `const token = useRoute().query.token`
      2. If no token: `navigateTo('/login')` immediately
      3. Call `GET /api/me` with `Authorization: Bearer <token>` to fetch the user profile
      4. If the call fails: `navigateTo('/login')`
      5. Call `authStore.handleLoginResponse({ user: profile, token, expiresAt: ... })`
      6. `navigateTo('/')`
    - Show a loading/spinner state while the API call is in progress
    - _Bug_Condition: `isBugCondition` — `input.path == "/auth/callback" AND input.queryParam.token IS NOT NULL AND pageDoesNotExist()` (1.7)_
    - _Expected_Behavior: Page reads token, fetches user profile, stores in Pinia, redirects to dashboard; missing token redirects to `/login`_
    - _Preservation: No existing Nuxt pages are modified; the router configuration is unchanged_
    - _Requirements: 2.7_

- [ ] 6. Fix verification — run all tests after implementation

  - [ ] 6.1 Verify bug condition exploration test now passes
    - **Property 1: Expected Behavior** - Google OAuth & Mock Login Defects
    - **IMPORTANT**: Re-run the SAME tests from task 1 — do NOT write new tests
    - The tests from task 1 encode the expected behavior
    - When these tests pass, it confirms all seven defects are resolved
    - Re-run the full Property 1 test suite from step 1
    - **EXPECTED OUTCOME**: All tests PASS (confirms all bugs are fixed)
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7_

  - [ ] 6.2 Verify preservation tests still pass
    - **Property 2: Preservation** - Existing Auth Behavior Is Unchanged
    - **IMPORTANT**: Re-run the SAME tests from task 2 — do NOT write new tests
    - Run all preservation property tests from step 2
    - Include the null-hash guard test (user with `passwordHash = null` gets 401, not 500)
    - **EXPECTED OUTCOME**: All tests PASS (confirms no regressions introduced)
    - Confirm all seven preservation requirements (3.1–3.7) still hold
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7_

- [ ] 7. Checkpoint — Ensure all tests pass
  - Run the full test suite (unit + property-based + integration) across both `apps/backend` and `apps/frontend`
  - Verify no TypeScript compilation errors (`tsc --noEmit`) in either app
  - Verify `GET /api/auth/google` → 302 to Google
  - Verify `GET /api/auth/google/callback` (with mocked Google responses) → 302 to frontend with JWT
  - Verify `GET /api/me` with valid token → 200 with user profile
  - Verify `login.vue` Google button click navigates externally
  - Verify `login.vue` form submit calls real API
  - Verify `register.vue` Google button click navigates externally
  - Verify `/auth/callback` page handles token correctly
  - Ensure all tests pass; ask the user if any questions arise
