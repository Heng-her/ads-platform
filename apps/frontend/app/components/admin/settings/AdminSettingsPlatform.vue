<script setup lang="ts">
export interface PlatformConfig {
  siteName: string
  siteDescription: string
  defaultLanguage: string
  allowRegistrations: boolean
}

const config = defineModel<PlatformConfig>({ required: true })
</script>

<template>
  <div class="space-y-6">
    <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
      <h2 class="text-lg font-semibold text-white">General Site Settings</h2>
      <p class="mt-1 text-sm text-gray-400">Manage site metadata and creator registration permissions.</p>

      <div class="mt-6 grid gap-6 md:grid-cols-2">
        <div class="space-y-1">
          <label class="block text-xs font-semibold text-gray-300">Site Title / Brand Name</label>
          <input
            v-model="config.siteName"
            type="text"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20"
          />
        </div>

        <div class="col-span-2 space-y-1">
          <label class="block text-xs font-semibold text-gray-300">Global SEO Description</label>
          <textarea
            v-model="config.siteDescription"
            rows="2"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20"
          />
        </div>
      </div>
    </div>
  </div>
</template>
