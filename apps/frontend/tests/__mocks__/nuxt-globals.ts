/**
 * Nuxt global composable stubs for vitest
 *
 * Nuxt provides these as auto-imports in the real app.
 * In vitest we provide them as vi.fn() stubs so component tests can
 * assert whether they were called.
 */
import { vi } from "vitest";

// navigateTo is the key function we test (Bugs 1.1, 1.2)
export const navigateTo = vi.fn();

// These are called in <script setup> but don't affect behavior we test
export const definePageMeta = vi.fn();
export const useSeoMeta = vi.fn();
export const useRuntimeConfig = vi.fn(() => ({
  public: { apiBase: "http://localhost:8787" },
}));
export const useRoute = vi.fn(() => ({
  query: { token: "test-token" },
}));
