<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const zoneKey = '20ecae93ef2233796f8c362e36dabba5'
const scriptSrc = 'https://bauval.org/22/20ecae93ef2233796f8c362e36dabba5'

// Using an isolated iframe srcdoc ensures synchronous script execution,
// prevents Adsterra document.write / document.currentScript collision,
// and auto-reloads safely on route navigation in Nuxt / Vue.
const iframeSrcdoc = computed(() => {
  return `<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
      body {
        margin: 0;
        padding: 0;
        overflow: hidden;
        display: flex;
        justify-content: center;
        align-items: center;
        background: transparent;
      }
    </style>
  </head>
  <body>
    <script type="text/javascript">
      atOptions = {
        'key' : '${zoneKey}',
        'format' : 'iframe',
        'height' : 90,
        'width' : 728,
        'params' : {}
      };
    <\/script>
    <script type="text/javascript" src="${scriptSrc}"><\/script>
  </body>
</html>`
})
</script>

<template>
  <ClientOnly>
    <iframe :key="`${route.params.slug || 'slug'}-${zoneKey}`" :srcdoc="iframeSrcdoc" width="728" height="90"
      frameborder="0" scrolling="no" class="w-[728px] h-[90px] max-w-full border-0 overflow-hidden"
      title="Sponsored Advertisement"></iframe>
  </ClientOnly>
</template>
