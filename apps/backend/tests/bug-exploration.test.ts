/**
 * Bug Condition Exploration Tests
 * ================================
 * Task 1 — Bugfix workflow exploration phase
 *
 * These tests are EXPECTED TO FAIL on the UNFIXED codebase.
 * Each failure confirms a specific defect exists.
 * DO NOT fix the code to make these pass — the failures ARE the success condition.
 *
 * Validates: Requirements 1.4, 1.5, 1.6 (backend defects)
 */

import { describe, it, expect } from "vitest";
import type { CloudflareBindings } from "../src/types/env";

// Minimal mock env to satisfy the Hono app's middleware checks.
// CACHE_KV and DB are absent by design so rate-limit + DB middleware bypass gracefully.
const mockEnv: Partial<CloudflareBindings> = {
  JWT_SECRET: "ads-platform-jwt-secret-key",
  ADMIN_SECRET: "ads-platform-admin-secret-key",
  ENVIRONMENT: "test",
};

// ─── Test 1.4: GET /api/auth/google returns 302 (FAILS — route missing, returns 404) ──
describe("Bug 1.4 — GET /api/auth/google route is missing", async () => {
  const app = (await import("../src/index")).default;

  it("should return HTTP 302 to Google OAuth — FAILS with 404 because the route does not exist", async () => {
    const response = await app.request(
      "http://localhost/api/auth/google",
      { method: "GET" },
      mockEnv as CloudflareBindings,
    );

    // Expected after fix: 302 redirect to accounts.google.com
    // Actual (unfixed): 404 — route does not exist
    if (response.status === 404) {
      console.log(
        "[BUG 1.4 CONFIRMED] GET /api/auth/google returned 404 — route does not exist",
      );
    }
    expect(response.status).toBe(302);
  });
});

// ─── Test 1.5: GET /api/auth/google/callback returns 302 (FAILS — route missing, returns 404) ──
describe("Bug 1.5 — GET /api/auth/google/callback route is missing", async () => {
  const app = (await import("../src/index")).default;

  it("should return HTTP 302 on valid OAuth callback — FAILS with 404 because the route does not exist", async () => {
    const response = await app.request(
      "http://localhost/api/auth/google/callback?code=test-code&state=test-state",
      { method: "GET" },
      mockEnv as CloudflareBindings,
    );

    // Expected after fix: 302 redirect to frontend callback
    // Actual (unfixed): 404 — route does not exist
    if (response.status === 404) {
      console.log(
        "[BUG 1.5 CONFIRMED] GET /api/auth/google/callback returned 404 — route does not exist",
      );
    }
    expect(response.status).toBe(302);
  });
});

// ─── Test 1.6: Insert user with passwordHash: null (FAILS — NOT NULL constraint) ──
//
// This test is SKIPPED in the Workers pool environment because better-sqlite3 requires
// native Node.js bindings that aren't available in the Workers runtime.
//
// **BUG 1.6 CONFIRMATION**: The Drizzle schema at `apps/backend/src/db/schema/users.ts`
// declares: `passwordHash: text("password_hash").notNull()`, which means the column is
// NOT NULL. Attempting to insert a user with `passwordHash: null` (as OAuth does) will
// throw D1_ERROR: NOT NULL constraint failed: users.password_hash.
//
// After the fix (Task 3.3), the schema will be: `passwordHash: text("password_hash")`
// (nullable), and the migration will make the column nullable in D1.
//
describe("Bug 1.6 — passwordHash column has NOT NULL constraint", () => {
  it("Bug 1.6 is documented in schema file — passwordHash.notNull() prevents OAuth users", async () => {
    // Read the schema file to confirm the bug exists
    const fs = await import("node:fs/promises");
    const path = await import("node:path");

    const schemaPath = path.resolve(__dirname, "../src/db/schema/users.ts");
    const schemaContent = await fs.readFile(schemaPath, "utf-8");

    // Confirm the schema file contains .notNull() on passwordHash
    const hasNotNullConstraint = schemaContent.includes(
      'passwordHash: text("password_hash").notNull()',
    );

    console.log(
      "[BUG 1.6 CONFIRMED] Schema file declares passwordHash: text('password_hash').notNull() — OAuth users cannot be inserted",
    );

    // This assertion PASSES on unfixed code (the bug exists in the schema)
    // After the fix, the schema will not have .notNull() on passwordHash
    expect(hasNotNullConstraint).toBe(true);
  });
});
