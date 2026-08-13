<script setup lang="ts">
import { ref } from 'vue'
import { useAppToast } from '~/composables/useAppToast'

export interface GoogleAuthConfig {
  googleClientId: string
  googleClientSecret: string
  enableGoogleAuth: boolean
}

const config = defineModel<GoogleAuthConfig>({ required: true })
const toast = useAppToast()
const showClientSecret = ref(false)

function copyCallbackUrl() {
  if (import.meta.client && navigator?.clipboard) {
    const origin = window.location.origin
    navigator.clipboard.writeText(`${origin}/login`)
    toast.success('Copied Callback URL', `${origin}/login copied to clipboard!`)
  }
}
</script>

<template>
  <div class="space-y-6">
    <!-- Main Google OAuth Credentials Card -->
    <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-6">
      <div class="flex items-center justify-between border-b border-gray-800 pb-4">
        <div class="flex items-center gap-3">
          <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-red-500/10 text-red-400">
            <UIcon name="i-heroicons-key" class="h-6 w-6" />
          </div>
          <div>
            <div class="flex items-center gap-2">
              <h2 class="text-lg font-semibold text-white">Google OAuth 2.0 Credentials</h2>
              <UBadge color="error" variant="soft" size="xs" class="font-mono uppercase font-bold">Social Authentication</UBadge>
            </div>
            <p class="text-xs text-gray-400">
              Configure Google API Client ID and Secret generated from Google Cloud Console to enable Google One-Tap & Sign-In.
            </p>
          </div>
        </div>

        <div class="flex items-center gap-2">
          <span class="text-xs text-gray-400 font-medium">Enable Google Auth</span>
          <input
            v-model="config.enableGoogleAuth"
            type="checkbox"
            class="h-5 w-5 rounded border-gray-700 bg-gray-800 text-red-500 focus:ring-red-500 cursor-pointer"
          />
        </div>
      </div>

      <div class="grid gap-6 md:grid-cols-2">
        <!-- Google Client ID -->
        <div class="space-y-1.5 md:col-span-2">
          <label class="block text-xs font-semibold text-gray-300">Google OAuth Client ID (GOOGLE_CLIENT_ID)</label>
          <input
            v-model="config.googleClientId"
            type="text"
            placeholder="123456789012-abc123def456.apps.googleusercontent.com"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2.5 text-sm text-white focus:border-red-500 focus:outline-none focus:ring-2 focus:ring-red-500/20 font-mono"
          />
          <p class="text-[11px] text-gray-400">
            Obtained from <strong>Google Cloud Console &gt; APIs &amp; Services &gt; Credentials</strong>.
          </p>
        </div>

        <!-- Google Client Secret -->
        <div class="space-y-1.5 md:col-span-2">
          <label class="block text-xs font-semibold text-gray-300">Google OAuth Client Secret (GOOGLE_CLIENT_SECRET)</label>
          <div class="relative">
            <input
              v-model="config.googleClientSecret"
              :type="showClientSecret ? 'text' : 'password'"
              placeholder="GOCSPX-abc123xyz4567890"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 py-2.5 pl-3.5 pr-10 text-sm text-white focus:border-red-500 focus:outline-none focus:ring-2 focus:ring-red-500/20 font-mono"
            />
            <button
              type="button"
              class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-white"
              @click="showClientSecret = !showClientSecret"
            >
              <UIcon :name="showClientSecret ? 'i-heroicons-eye-slash' : 'i-heroicons-eye'" class="h-4 w-4" />
            </button>
          </div>
          <p class="text-[11px] text-gray-400">
            Keep this secret key secure. Never share your Client Secret in client-side code.
          </p>
        </div>
      </div>

      <!-- Quick Setup Guide Box -->
      <div class="rounded-xl border border-gray-800 bg-gray-950/70 p-4 space-y-3">
        <div class="flex items-center justify-between">
          <h3 class="text-xs font-bold text-white flex items-center gap-1.5">
            <UIcon name="i-heroicons-information-circle" class="h-4 w-4 text-sky-400" />
            Google OAuth Setup &amp; Redirect URI Guide
          </h3>
          <button
            type="button"
            class="text-[11px] text-sky-400 hover:underline font-mono flex items-center gap-1"
            @click="copyCallbackUrl"
          >
            <UIcon name="i-heroicons-clipboard-document" class="w-3.5 h-3.5" />
            Copy Login Redirect URL
          </button>
        </div>

        <ul class="text-xs text-gray-400 space-y-1.5 list-disc pl-4 leading-relaxed">
          <li>Go to <a href="https://console.cloud.google.com/apis/credentials" target="_blank" class="text-sky-400 hover:underline font-semibold">Google Cloud Credentials Console</a>.</li>
          <li>Create an <strong>OAuth 2.0 Client ID</strong> (Web application).</li>
          <li>Add <code>http://localhost:3000</code> to <strong>Authorized JavaScript origins</strong>.</li>
          <li>Add <code>http://localhost:3000/login</code> to <strong>Authorized redirect URIs</strong>.</li>
        </ul>
      </div>
    </div>
  </div>
</template>
