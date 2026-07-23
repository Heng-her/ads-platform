<script setup lang="ts">
// Set HTTP response code 404 for SSR / SEO
if (import.meta.server) {
  setResponseStatus(404, 'Page Not Found')
}
definePageMeta({
  layout: 'auth'
})
useSeoMeta({
  title: '404 - Page Not Found',
  description: 'The page you are looking for does not exist.'
})
</script>

<template>
  <div class="min-h-screen flex flex-col items-center justify-center bg-gray-950 text-gray-100 p-6 text-center">
    <div
      class="max-w-md w-full space-y-6 bg-gray-900/80 border border-gray-800 p-8 rounded-2xl shadow-2xl backdrop-blur-md">
      <div class="inline-flex items-center justify-center p-4 bg-primary/10 rounded-full mb-2">
        <UIcon name="i-heroicons-exclamation-triangle" class="w-16 h-16 text-primary" />
      </div>

      <h1 class="text-6xl font-extrabold text-primary tracking-wider">
        404
      </h1>

      <h2 class="text-2xl font-bold tracking-tight text-white">
        Page Not Found
      </h2>

      <p class="text-gray-400 text-sm leading-relaxed">
        Sorry, the page you are looking for doesn't exist or has been moved.
      </p>

      <div class="pt-4 flex justify-center">
        <UButton to="/" color="primary" icon="i-heroicons-home" size="lg"
          class="font-semibold px-6 py-2.5 rounded-xl transition-transform active:scale-95">
          Back to Home
        </UButton>
      </div>
    </div>
  </div>
</template>
