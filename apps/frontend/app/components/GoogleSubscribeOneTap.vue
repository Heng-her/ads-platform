<script setup lang="ts">
import { onMounted } from 'vue'
import { useGoogleSubscribe } from '~/composables/useGoogleSubscribe'
import { useWebPushNotification } from '~/composables/useWebPushNotification'

const { triggerGoogleSubscribe } = useGoogleSubscribe()
const { subscribeToNotifications, checkExistingSubscription } = useWebPushNotification()

onMounted(() => {
  // 1. Trigger Google One-Tap Subscribe Popup
  triggerGoogleSubscribe()

  // 2. Auto-sync or prompt for Notification permission
  if (import.meta.client && 'Notification' in window) {
    if (Notification.permission === 'granted') {
      void checkExistingSubscription()
    } else if (Notification.permission === 'default') {
      setTimeout(() => {
        void subscribeToNotifications(false)
      }, 500)
    }
  }
})
</script>

<template>
  <!-- Renderless Component for Google One Tap & Browser Push Notification Popup -->
  <slot />
</template>
