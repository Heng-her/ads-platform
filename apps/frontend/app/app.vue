<script setup lang="ts">
import { computed } from 'vue'

const localeCookie = useCookie<string>('locale', { default: () => 'en' })

useHead({
  meta: [
    { name: 'viewport', content: 'width=device-width, initial-scale=1' }
  ],
  link: [
    { rel: 'icon', href: '/favicon.ico' }
  ],
  htmlAttrs: {
    lang: computed(() => localeCookie.value || 'en')
  }
})

const title = 'NewPlatform - Modern Ad Management'
const description = 'Multi-role New Platform supporting Public browsing, Creator Studio, and Admin Control.'

useSeoMeta({
  title,
  description,
  ogTitle: title,
  ogDescription: description
})
</script>

<template>
  <UApp>
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>
    <GoogleCloudTranslator />
    <AppToast />
  </UApp>
</template>
