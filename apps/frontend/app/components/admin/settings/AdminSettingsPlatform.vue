<script setup lang="ts">
import AdminSettingInput from './AdminSettingInput.vue'

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
</script>

<template>
  <div class="space-y-6">
    <!-- General Site Settings Card -->
    <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
      <h2 class="text-lg font-semibold text-white">General Site Settings</h2>
      <p class="mt-1 text-sm text-gray-400">Manage site metadata, domain URL, and creator registration permissions.</p>

      <div class="mt-6 grid gap-6 md:grid-cols-2">
        <AdminSettingInput
          v-model="config.siteName"
          label="Site Title / Brand Name"
          icon="i-heroicons-globe-alt"
          placeholder="New Platform"
        />

        <AdminSettingInput
          v-model="config.siteUrl"
          label="Website Base URL / Domain"
          icon="i-heroicons-link"
          placeholder="http://localhost:3000"
          hint="Used for generating full article notification links (e.g. Telegram & Email dispatches)."
        />

        <div class="col-span-2">
          <AdminSettingInput
            v-model="config.siteDescription"
            label="Global SEO Description"
            type="textarea"
            :rows="2"
            placeholder="Multi-role New Platform supporting Public browsing, Creator Studio, and Admin Control."
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
        <AdminSettingInput
          v-model="securityConfig.creatorDeletionPassword"
          label="Creator Deletion Security Password"
          type="password"
          icon="i-heroicons-key"
          placeholder="Enter deletion security password"
          hint="Administrators must enter this exact password on /admin/approvals to delete any creator account."
        />
      </div>
    </div>
  </div>
</template>
