<script setup lang="ts">
import { onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const containerId = 'container-fcf4cfcdbc9a35848cba6acdca43054b'
const scriptSrc = 'https://bauval.org/21/fcf4cfcdbc9a35848cba6acdca43054b'

function loadNativeAd() {
  if (!import.meta.client) return

  // Remove existing script if previously injected to trigger a fresh reload
  const existingScript = document.querySelector(`script[src="${scriptSrc}"]`)
  if (existingScript) {
    existingScript.remove()
  }

  // Inject fresh script so Adsterra populates the container
  const script = document.createElement('script')
  script.async = true
  script.setAttribute('data-cfasync', 'false')
  script.src = scriptSrc
  document.body.appendChild(script)
}

onMounted(() => {
  loadNativeAd()
})

watch(() => route.fullPath, () => {
  loadNativeAd()
})
</script>

<template>
  <ClientOnly>
    <div
      class="my-6 w-full overflow-hidden rounded-2xl bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 p-4 sm:p-5 shadow-xs transition-all">

      <!-- Adsterra Injected Container -->
      <div :id="containerId" class="min-h-[120px] w-full flex items-center justify-center"></div>
    </div>
  </ClientOnly>
</template>
