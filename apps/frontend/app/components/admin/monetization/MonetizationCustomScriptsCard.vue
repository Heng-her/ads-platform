<script setup lang="ts">
import type { AdNetworkConfig } from './MonetizationAdsterraCard.vue'

const config = defineModel<AdNetworkConfig>({ required: true })
</script>

<template>
  <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-4">
    <h2 class="text-lg font-semibold text-white flex items-center gap-2">
      <UIcon name="i-heroicons-code-bracket" class="h-5 w-5 text-emerald-400" />
      Global Ad Script Tag & Header Embed Code
    </h2>
    <p class="text-xs text-gray-400">
      Inject custom JavaScript/HTML tags from Google AdSense, Adsterra, or third-party ad networks system-wide.
    </p>

    <div class="grid gap-6 md:grid-cols-2">
      <div class="space-y-1">
        <label class="block text-xs font-semibold text-gray-300">Header Script Code (&lt;head&gt; Injection)</label>
        <textarea
          v-model="config.customHeaderScript"
          rows="4"
          placeholder="<script ...></script>"
          class="w-full rounded-lg border border-gray-700 bg-gray-800 p-3 text-xs text-emerald-300 font-mono focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/20"
        />
      </div>

      <div class="space-y-1">
        <label class="block text-xs font-semibold text-gray-300">In-Article Ad Banner Script Code</label>
        <textarea
          v-model="config.customArticleAdScript"
          rows="4"
          placeholder="<script ...></script>"
          class="w-full rounded-lg border border-gray-700 bg-gray-800 p-3 text-xs text-emerald-300 font-mono focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/20"
        />
      </div>
    </div>
  </div>
</template>
