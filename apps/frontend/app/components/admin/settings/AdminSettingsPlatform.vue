<script setup lang="ts">
import { ref } from 'vue'

export interface PlatformConfig {
  siteName: string
  siteDescription: string
  siteUrl: string
  defaultLanguage: string
  allowRegistrations: boolean
}

export interface SecurityConfig {
  creatorDeletionPassword: string
}

const config = defineModel<PlatformConfig>({ required: true })
const securityConfig = defineModel<SecurityConfig>('security', { required: true })

const showPassword = ref(false)
</script>

<template>
  <div class="space-y-6">
    <!-- General Site Settings Card -->
    <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
      <h2 class="text-lg font-semibold text-white">General Site Settings</h2>
      <p class="mt-1 text-sm text-gray-400">Manage site metadata, domain URL, and creator registration permissions.</p>

      <div class="mt-6 grid gap-6 md:grid-cols-2">
        <div class="space-y-1">
          <label class="block text-xs font-semibold text-gray-300">Site Title / Brand Name</label>
          <input
            v-model="config.siteName"
            type="text"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20"
          />
        </div>

        <div class="space-y-1">
          <label class="block text-xs font-semibold text-gray-300">Website Base URL / Domain</label>
          <input
            v-model="config.siteUrl"
            type="text"
            placeholder="http://localhost:3000"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20"
          />
          <p class="text-[11px] text-gray-400">Used for generating full article notification links (e.g. Telegram & Email dispatches).</p>
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

    <!-- Security & Protection Card -->
    <div class="rounded-xl border border-red-900/40 bg-gray-900 p-6 shadow-sm">
      <div class="flex items-center gap-3">
        <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-red-500/10 text-red-400">
          <UIcon name="i-heroicons-shield-check" class="h-6 w-6" />
        </div>
        <div>
          <h2 class="text-lg font-semibold text-white">Creator Account Deletion Security</h2>
          <p class="text-xs text-gray-400">Set the master security password required by administrators to permanently delete creator accounts on the Approvals page.</p>
        </div>
      </div>

      <div class="mt-6 max-w-md space-y-2">
        <label class="block text-xs font-semibold text-gray-300">Creator Deletion Security Password</label>
        <div class="relative">
          <input
            v-model="securityConfig.creatorDeletionPassword"
            :type="showPassword ? 'text' : 'password'"
            placeholder="Enter deletion security password"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 py-2.5 pl-3.5 pr-10 text-sm text-white focus:border-red-500 focus:outline-none focus:ring-2 focus:ring-red-500/20 font-mono"
          />
          <button
            type="button"
            class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-white"
            @click="showPassword = !showPassword"
          >
            <UIcon :name="showPassword ? 'i-heroicons-eye-slash' : 'i-heroicons-eye'" class="h-4 w-4" />
          </button>
        </div>
        <p class="text-[11px] text-amber-400/90 flex items-center gap-1.5">
          <UIcon name="i-heroicons-exclamation-triangle" class="h-3.5 w-3.5 shrink-0 text-amber-400" />
          <span>Administrators must enter this exact password on <code>/admin/approvals</code> to delete any creator account.</span>
        </p>
      </div>
    </div>
  </div>
</template>

