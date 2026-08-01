# Bugfix Requirements Document

## Introduction

The application's "Sign in with Google" and "Sign up with Google" buttons on `login.vue` and `register.vue` are non-functional UI placeholders. Clicking them does nothing. Additionally, the email/password login form uses a mock `setTimeout` with hardcoded fake user data instead of calling the real backend API. The `users` table schema enforces `passwordHash NOT NULL`, making it impossible to store OAuth-only users who have no password. This bugfix implements the full Google OAuth 2.0 Authorization Code Flow, wires up the real login API, and migrates the schema to support OAuth accounts.

## Bug Analysis

### Current Behavior (Defect)

1.1 WHEN a user clicks "Sign in with Google" on the login page THEN the system does nothing — no navigation, no redirect, no error message

1.2 WHEN a user clicks "Sign up with Google" on the register page THEN the system does nothing — no navigation, no redirect, no error message

1.3 WHEN a user submits the email/password login form THEN the system waits one second and logs the user in with hardcoded fake data instead of calling the real backend `/api/auth/login` endpoint

1.4 WHEN the backend receives a callback with a valid Google authorization code THEN the system returns a 404 because no `/api/auth/google/callback` route exists

1.5 WHEN the backend receives a request to initiate Google OAuth THEN the system returns a 404 because no `/api/auth/google` redirect route exists

1.6 WHEN attempting to create a new user account for a Google OAuth user who has no password THEN the system throws a database constraint violation because `password_hash` is `NOT NULL`

1.7 WHEN the OAuth flow completes and the backend issues a JWT in the redirect URL THEN the frontend has no page to receive and store it because no `/auth/callback` route exists

### Expected Behavior (Correct)

2.1 WHEN a user clicks "Sign in with Google" on the login page THEN the system SHALL navigate the browser to the backend `/api/auth/google` endpoint, which redirects to Google's OAuth authorization page

2.2 WHEN a user clicks "Sign up with Google" on the register page THEN the system SHALL navigate the browser to the backend `/api/auth/google` endpoint, which redirects to Google's OAuth authorization page

2.3 WHEN a user submits the email/password login form THEN the system SHALL call the real backend `/api/auth/login` endpoint, handle success by storing the JWT in the Pinia auth store, and handle errors by displaying a user-visible error message

2.4 WHEN the backend `/api/auth/google/callback` endpoint receives a valid authorization code from Google THEN the system SHALL exchange the code for tokens using the Fetch API (no OAuth library), retrieve the user's Google profile, find or create the local user record, issue a signed JWT, and redirect the browser to the frontend `/auth/callback` page with the token as a query parameter

2.5 WHEN the backend receives a request to `/api/auth/google` THEN the system SHALL build the Google OAuth authorization URL using `GOOGLE_CLIENT_ID` and `FRONTEND_URL` env vars and redirect the browser to it with a `state` parameter for CSRF protection

2.6 WHEN a Google OAuth user is created for the first time THEN the system SHALL store the user with `passwordHash` as `NULL` (column made nullable) so no placeholder hash is needed

2.7 WHEN the frontend `/auth/callback` page loads with a `token` query parameter THEN the system SHALL read the token, call the backend to fetch the authenticated user's profile, store the result in the Pinia auth store using `handleLoginResponse`, and redirect to the dashboard

### Unchanged Behavior (Regression Prevention)

3.1 WHEN a user registers with email and password via `/api/auth/register` THEN the system SHALL CONTINUE TO hash the password, create the user record, and return a JWT as before

3.2 WHEN a user logs in with a valid email and password via `/api/auth/login` THEN the system SHALL CONTINUE TO validate credentials against the stored `passwordHash` and return a JWT as before

3.3 WHEN a user logs in with an invalid email or password THEN the system SHALL CONTINUE TO return an "Invalid email or password" error without revealing which field is wrong

3.4 WHEN a suspended user attempts to log in THEN the system SHALL CONTINUE TO return an "Account has been suspended" error

3.5 WHEN the register endpoint receives a request to create an ADMIN user without the correct `x-admin-secret` header THEN the system SHALL CONTINUE TO return a 403 Forbidden error

3.6 WHEN the rate limiter detects too many registration attempts from the same IP THEN the system SHALL CONTINUE TO block the request as before

3.7 WHEN a user's JWT is included in a protected API request THEN the system SHALL CONTINUE TO authenticate the request using the existing JWT middleware without any changes to token validation logic
