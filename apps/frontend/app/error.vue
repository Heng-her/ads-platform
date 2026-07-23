<script setup lang="ts">
import type { NuxtError } from '#app'
definePageMeta({
  layout: 'auth'
})
const props = defineProps<{
  error: NuxtError
}>()

const handleError = () => clearError({ redirect: '/' })
</script>

<template>
  <UApp>
    <div class="min-h-screen flex flex-col items-center justify-center bg-gray-950 text-gray-100 p-6 text-center">
      <div
        class="max-w-md w-full space-y-6 bg-gray-900/80 border border-gray-800 p-8 rounded-2xl shadow-2xl backdrop-blur-md">
        <div class="inline-flex items-center justify-center p-4 bg-primary/10 rounded-full mb-2">
          <UIcon name="i-heroicons-exclamation-triangle" class="w-16 h-16 text-primary" />
        </div>

        <h1 class="text-6xl font-extrabold text-primary tracking-wider">
          {{ error.statusCode || 404 }}
        </h1>

        <h2 class="text-2xl font-bold tracking-tight text-white">
          {{ error.statusCode === 404 ? 'Page Not Found' : 'An Error Occurred' }}
        </h2>

        <p class="text-gray-400 text-sm leading-relaxed">
          {{ error.message || "Sorry, the page you are looking for doesn't exist or has been moved." }}
        </p>

        <div class="pt-4 flex justify-center">
          <UButton color="primary" icon="i-heroicons-home" size="lg"
            class="font-semibold px-6 py-2.5 rounded-xl transition-transform active:scale-95" @click="handleError">
            Back to Home
          </UButton>
        </div>
      </div>
    </div>
  </UApp>
</template>
