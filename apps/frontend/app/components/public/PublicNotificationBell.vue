<script setup lang="ts">
import { useWebPushNotification } from '~/composables/useWebPushNotification'

const { permissionState, isSubscribed, isLoading, subscribeToNotifications } = useWebPushNotification()

async function handleBellClick() {
  await subscribeToNotifications(true)
}
</script>

<template>
  <div class="relative inline-flex items-center">
    <UButton
      icon="i-heroicons-bell"
      color="neutral"
      variant="ghost"
      size="sm"
      class="relative text-gray-700 dark:text-gray-300 hover:text-primary transition"
      :class="{ 'animate-pulse': isLoading }"
      :disabled="isLoading"
      aria-label="Subscribe to Chrome Push Notifications"
      @click="handleBellClick"
    >
      <span v-if="isSubscribed || permissionState === 'granted'" class="absolute top-1.5 right-1.5 flex h-2 w-2">
        <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
        <span class="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
      </span>
    </UButton>
  </div>
</template>
