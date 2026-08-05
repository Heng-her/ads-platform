import { useAuthStore } from "~/stores/auth";

export default defineNuxtPlugin(async () => {
  const runtimeConfig = useRuntimeConfig();
  const authStore = useAuthStore();

  authStore.initAuth();
  if (import.meta.client && authStore.token) {
    await authStore.fetchUserMe();
  }

  console.log("DEBUG: Nuxt Config Loaded:", {
    apiBase: runtimeConfig.public.apiBase,
    hasClientId: !!runtimeConfig.public.googleClientId,
  });
});
