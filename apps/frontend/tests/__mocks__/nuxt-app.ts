/**
 * Mock for #app (Nuxt's internal app module)
 * Required when Nuxt components or composables import from "#app"
 */
export const useNuxtApp = () => ({});
export const defineNuxtPlugin = (fn: any) => fn;
