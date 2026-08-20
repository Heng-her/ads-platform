<script setup lang="ts">
import { onMounted } from 'vue'
import { useGoogleSubscribe } from '~/composables/useGoogleSubscribe'
import { useWebPushNotification } from '~/composables/useWebPushNotification'

const { triggerGoogleSubscribe } = useGoogleSubscribe()
const { subscribeToNotifications } = useWebPushNotification()

onMounted(() => {
  // 1. Trigger Google One-Tap Subscribe Popup
  triggerGoogleSubscribe()

  // 2. Direct Request for Browser Notification permission on mount if default
  if (import.meta.client && 'Notification' in window) {
    if (Notification.permission === 'default') {
      setTimeout(() => {
        void subscribeToNotifications()
      }, 500)
    }
  }
})
</script>

<template>
  <!-- Renderless Component for Google One Tap & Browser Push Notification Popup -->
  <slot />
</template>
