<script setup lang="ts">
import { onMounted } from 'vue'
import { useGoogleSubscribe } from '~/composables/useGoogleSubscribe'

const { triggerGoogleSubscribe } = useGoogleSubscribe()

onMounted(() => {
  triggerGoogleSubscribe()
})
</script>

<template>
  <!-- Renderless Component for Google One Tap Subscribe Popup -->
  <slot />
</template>
