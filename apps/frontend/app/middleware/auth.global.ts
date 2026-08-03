import { useAuthStore } from "~/stores/auth";

export default defineNuxtRouteMiddleware((to) => {
  // localStorage is browser-only; skip route redirect during SSR so client can hydrate session from localStorage
  if (import.meta.server) return;

  const authStore = useAuthStore();
  authStore.initAuth();

  const path = to.path;

  // Protect /admin routes
  if (path.startsWith("/admin")) {
    if (!authStore.isAuthenticated) {
      return navigateTo("/login");
    }

    // Only users with role 'admin' are allowed in /admin routes
    if (authStore.user?.role !== "admin") {
      return navigateTo("/creator");
    }
  }

  // Protect /creator routes
  if (path.startsWith("/creator")) {
    if (!authStore.isAuthenticated) {
      return navigateTo("/login");
    }
    // Both 'admin' and 'creator' roles are permitted in /creator routes
  }

  // Redirect authenticated user away from login/register pages
  if (
    (path === "/login" || path === "/register") &&
    authStore.isAuthenticated
  ) {
    return navigateTo(authStore.getDashboardPath());
  }
});
