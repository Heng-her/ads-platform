import { useAuthStore } from "~/stores/auth";

export default defineNuxtPlugin(() => {
  const runtimeConfig = useRuntimeConfig();
  const authStore = useAuthStore();

  authStore.initAuth();

  console.log("DEBUG: Nuxt Config Loaded:", {
    apiBase: runtimeConfig.public.apiBase,
    hasClientId: !!runtimeConfig.public.googleClientId,
  });
});
