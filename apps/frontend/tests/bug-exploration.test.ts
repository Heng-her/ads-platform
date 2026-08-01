/**
 * Bug Condition Exploration Tests — Frontend
 * ============================================
 * Task 1 — Bugfix workflow exploration phase
 *
 * These tests are EXPECTED TO FAIL on the UNFIXED codebase.
 * Each failure documents a specific defect.
 * DO NOT fix the code — the failures ARE the success condition for this task.
 *
 * Validates: Requirements 1.1, 1.2, 1.3, 1.7
 */

import { describe, it, expect, vi, beforeEach } from "vitest";
import { mount } from "@vue/test-utils";
import { defineComponent, ref } from "vue";

// ─────────────────────────────────────────────────────────────────────────────
// Shared navigateTo spy — global stub for the Nuxt composable used by the pages
// ─────────────────────────────────────────────────────────────────────────────
const navigateToSpy = vi.fn();

// Provide a global stub for every Nuxt auto-import the components use
vi.stubGlobal("navigateTo", navigateToSpy);
vi.stubGlobal("definePageMeta", vi.fn());
vi.stubGlobal("useSeoMeta", vi.fn());
vi.stubGlobal("useRuntimeConfig", vi.fn(() => ({ public: { apiBase: "http://localhost:8787" } })));
vi.stubGlobal("useRoute", vi.fn(() => ({ query: { token: "test-token" } })));

// ─────────────────────────────────────────────────────────────────────────────
// Stub for useAuthStore — prevents Pinia import issues in this test environment
// ─────────────────────────────────────────────────────────────────────────────
const mockAuthStore = {
  handleLoginResponse: vi.fn(),
  user: null,
  token: null,
  isAuthenticated: false,
};

vi.mock("~/stores/auth", () => ({
  useAuthStore: () => mockAuthStore,
}));

// ─────────────────────────────────────────────────────────────────────────────
// Stub for useApi — intercepts the Hono RPC client call (used in Bug 1.3 test)
// ─────────────────────────────────────────────────────────────────────────────
const apiLoginSpy = vi.fn().mockResolvedValue({
  ok: true,
  json: async () => ({
    data: {
      user: { id: "1", username: "test", email: "test@test.com", role: "CREATOR" },
      token: "jwt_real_token",
      expiresAt: new Date(Date.now() + 86400000).toISOString(),
    },
  }),
});

vi.mock("~/composables/useApi", () => ({
  useApi: () => ({
    api: {
      auth: {
        login: {
          $post: apiLoginSpy,
        },
      },
    },
  }),
}));

// ─────────────────────────────────────────────────────────────────────────────
// Stub for ~/lib/crypto — needed by auth store
// ─────────────────────────────────────────────────────────────────────────────
vi.mock("~/lib/crypto", () => ({
  encryptData: (data: any) => JSON.stringify(data),
  decryptData: (str: string) => JSON.parse(str),
}));

// ─────────────────────────────────────────────────────────────────────────────
// Helpers to locate the Google button in the component HTML
// ─────────────────────────────────────────────────────────────────────────────
function findGoogleButton(wrapper: ReturnType<typeof mount>) {
  // The Google button is a <button type="button"> that contains an SVG with Google's
  // brand colors. We locate it by the text "Google" in the button.
  const buttons = wrapper.findAll("button");
  return buttons.find((b) =>
    b.text().toLowerCase().includes("google") ||
    b.html().includes("4285F4"), // Google blue — part of the Google logo SVG path fill
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Bug 1.1 — Google button in login.vue has no click handler
// ─────────────────────────────────────────────────────────────────────────────
describe("Bug 1.1 — login.vue Google button has no @click handler", () => {
  beforeEach(() => {
    navigateToSpy.mockClear();
  });

  it("clicking the Google button should call navigateTo('/api/auth/google') — FAILS because no handler exists", async () => {
    // Dynamically import the component to let stubs apply
    const LoginVue = await import("../app/pages/(auth)/login.vue");
    const wrapper = mount(LoginVue.default, {
      global: {
        stubs: {
          // Stub Nuxt/UI components that aren't available in vitest
          UIcon: true,
          NuxtLink: true,
        },
      },
    });

    const googleButton = findGoogleButton(wrapper);
    expect(googleButton).toBeDefined(); // Button must exist in the DOM

    // Click the Google button
    await googleButton!.trigger("click");

    // Expected after fix: navigateTo('/api/auth/google', { external: true }) is called
    // Actual (unfixed): navigateTo is never called — no @click handler on the button
    expect(navigateToSpy).toHaveBeenCalledWith("/api/auth/google", expect.objectContaining({ external: true }));

    if (!navigateToSpy.mock.calls.length) {
      console.log("[BUG 1.1 CONFIRMED] Google button click did not trigger navigateTo — no @click handler on login.vue Google button");
    }
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// Bug 1.2 — Google button in register.vue has no click handler
// ─────────────────────────────────────────────────────────────────────────────
describe("Bug 1.2 — register.vue Google button has no @click handler", () => {
  beforeEach(() => {
    navigateToSpy.mockClear();
  });

  it("clicking the Google button should call navigateTo('/api/auth/google') — FAILS because no handler exists", async () => {
    const RegisterVue = await import("../app/pages/(auth)/register.vue");
    const wrapper = mount(RegisterVue.default, {
      global: {
        stubs: {
          UIcon: true,
          NuxtLink: true,
        },
      },
    });

    const googleButton = findGoogleButton(wrapper);
    expect(googleButton).toBeDefined();

    await googleButton!.trigger("click");

    // Expected after fix: navigateTo('/api/auth/google', { external: true }) is called
    // Actual (unfixed): navigateTo is never called — no @click handler on the button
    expect(navigateToSpy).toHaveBeenCalledWith("/api/auth/google", expect.objectContaining({ external: true }));

    if (!navigateToSpy.mock.calls.length) {
      console.log("[BUG 1.2 CONFIRMED] Google button click did not trigger navigateTo — no @click handler on register.vue Google button");
    }
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// Bug 1.3 — login.vue handleSubmit uses setTimeout mock instead of real API
// ─────────────────────────────────────────────────────────────────────────────
describe("Bug 1.3 — login.vue handleSubmit uses setTimeout instead of real API call", () => {
  beforeEach(() => {
    vi.useFakeTimers();
    apiLoginSpy.mockClear();
    navigateToSpy.mockClear();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("submitting the login form should call the Hono RPC client — FAILS because only setTimeout runs", async () => {
    const LoginVue = await import("../app/pages/(auth)/login.vue");
    const wrapper = mount(LoginVue.default, {
      global: {
        stubs: {
          UIcon: true,
          NuxtLink: true,
        },
      },
    });

    // Fill in valid email and password
    const emailInput = wrapper.find("input[type='email']");
    const passwordInput = wrapper.find("input[type='password']");
    expect(emailInput.exists()).toBe(true);
    expect(passwordInput.exists()).toBe(true);

    await emailInput.setValue("user@example.com");
    await passwordInput.setValue("SecurePass123!");

    // Submit the form
    const form = wrapper.find("form");
    await form.trigger("submit");

    // Flush any microtasks (for async awaits in the handler)
    await vi.runAllTimersAsync();

    // Expected after fix: the Hono RPC client ($post) is called with the credentials
    // Actual (unfixed): apiLoginSpy is never called — handleSubmit only runs setTimeout
    expect(apiLoginSpy).toHaveBeenCalledWith({
      json: { email: "user@example.com", password: "SecurePass123!" },
    });

    if (!apiLoginSpy.mock.calls.length) {
      console.log("[BUG 1.3 CONFIRMED] Form submit did not call useApi().api.auth.login.$post — handleSubmit uses a setTimeout mock");
    }
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// Bug 1.7 — /auth/callback page does not exist
// ─────────────────────────────────────────────────────────────────────────────
describe("Bug 1.7 — /auth/callback Nuxt page does not exist", () => {
  it("the callback page file should exist at app/pages/auth/callback.vue — FAILS because file is absent", async () => {
    // We detect this by attempting to import the page module.
    // If it doesn't exist, the dynamic import will throw.
    let importSucceeded = false;
    let importError: unknown;

    try {
      // Try both possible locations mentioned in the design doc
      await import("../app/pages/auth/callback.vue");
      importSucceeded = true;
    } catch (e1) {
      try {
        await import("../app/pages/(auth)/callback.vue");
        importSucceeded = true;
      } catch (e2) {
        importError = e2;
      }
    }

    // Expected after fix: the page exists and can be imported
    // Actual (unfixed): import throws MODULE_NOT_FOUND — page does not exist
    expect(importSucceeded).toBe(true);

    if (!importSucceeded) {
      console.log("[BUG 1.7 CONFIRMED] /auth/callback page does not exist:", String(importError));
    }
  });
});
