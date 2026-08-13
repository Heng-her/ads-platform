<script setup lang="ts">
import { ref } from 'vue'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'

export interface UploadConfig {
  uploadApiBaseUrl: string
  uploadApiKey: string
  uploadApiBypassSecret: string
}

const config = defineModel<UploadConfig>({ required: true })
const api = useApi()
const toast = useAppToast()

const showApiKey = ref(false)
const showBypassSecret = ref(false)
const isTesting = ref(false)
const testResult = ref<{ success: boolean; message: string } | null>(null)

async function testConnection() {
  isTesting.value = true
  testResult.value = null
  try {
    const res = await api.action.$post({
      json: {
        action: 'settings/test-upload',
        data: { upload: config.value }
      }
    })
    const data: any = await res.json()
    if (res.ok && data.code === 1) {
      testResult.value = {
        success: true,
        message: data.msg || 'Image Upload API Server Connection Verified Successfully!'
      }
      toast.success('Connection Verified', data.msg)
    } else {
      testResult.value = {
        success: false,
        message: data.msg || 'Failed to connect to Image Upload API Server.'
      }
      toast.error('Connection Failed', data.msg)
    }
  } catch (err: any) {
    testResult.value = {
      success: false,
      message: err.message || 'Network error while testing connection.'
    }
    toast.error('Connection Error', err.message)
  } finally {
    isTesting.value = false
  }
}
</script>

<template>
  <div class="space-y-6">
    <!-- Main Upload API Settings Card -->
    <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-6">
      <div class="flex items-center justify-between border-b border-gray-800 pb-4">
        <div class="flex items-center gap-3">
          <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-emerald-500/10 text-emerald-400">
            <UIcon name="i-heroicons-cloud-arrow-up" class="h-6 w-6" />
          </div>
          <div>
            <div class="flex items-center gap-2">
              <h2 class="text-lg font-semibold text-white">Image Upload API Microservice</h2>
              <UBadge color="error" variant="soft" size="xs" class="font-mono uppercase font-bold">Image Server Proxy
              </UBadge>
            </div>
            <p class="text-xs text-gray-400">
              Configure external Render/Node.js image upload proxy server endpoint, API Key, and Bypass Secret.
            </p>
          </div>
        </div>

        <button type="button" :disabled="isTesting"
          class="inline-flex items-center gap-1.5 rounded-lg border border-emerald-500/30 bg-emerald-500/10 px-3.5 py-2 text-xs font-semibold text-emerald-400 transition hover:bg-emerald-500/20 disabled:opacity-50"
          @click="testConnection">
          <UIcon v-if="isTesting" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
          <UIcon v-else name="i-heroicons-bolt" class="h-4 w-4" />
          <span>{{ isTesting ? 'Testing Connection...' : 'Test Connection' }}</span>
        </button>
      </div>

      <!-- Test Status Alert -->
      <div v-if="testResult" :class="[
        testResult.success
          ? 'border-emerald-500/30 bg-emerald-500/10 text-emerald-300'
          : 'border-red-500/30 bg-red-500/10 text-red-300',
        'flex items-center gap-3 rounded-lg border p-3.5 text-xs font-medium'
      ]">
        <UIcon :name="testResult.success ? 'i-heroicons-check-circle' : 'i-heroicons-exclamation-triangle'"
          class="h-5 w-5 shrink-0" />
        <span>{{ testResult.message }}</span>
      </div>

      <div class="grid gap-6 md:grid-cols-2">
        <!-- Base URL -->
        <div class="space-y-1.5 md:col-span-2">
          <label class="block text-xs font-semibold text-gray-300">Upload API Base URL (UPLOAD_API_BASE_URL)</label>
          <input v-model="config.uploadApiBaseUrl" type="url" placeholder="https://api-upload-image-8ym9.onrender.com"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2.5 text-sm text-white focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/20 font-mono" />
          <p class="text-[11px] text-gray-400">
            The base URL of your deployed image upload microservice (e.g. Render / Express app).
          </p>
        </div>

        <!-- API Key -->
        <div class="space-y-1.5">
          <label class="block text-xs font-semibold text-gray-300">Upload API Key (UPLOAD_API_KEY)</label>
          <div class="relative">
            <input v-model="config.uploadApiKey" :type="showApiKey ? 'text' : 'password'" placeholder="crypten-api-key"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 py-2.5 pl-3.5 pr-10 text-sm text-white focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/20 font-mono" />
            <button type="button" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-white"
              @click="showApiKey = !showApiKey">
              <UIcon :name="showApiKey ? 'i-heroicons-eye-slash' : 'i-heroicons-eye'" class="h-4 w-4" />
            </button>
          </div>
          <p class="text-[11px] text-gray-400">
            Passed as <code>x-api-key</code> HTTP header during image upload requests.
          </p>
        </div>

        <!-- Bypass Secret -->
        <div class="space-y-1.5">
          <label class="block text-xs font-semibold text-gray-300">Upload API Bypass Secret
            (UPLOAD_API_BYPASS_SECRET)</label>
          <div class="relative">
            <input v-model="config.uploadApiBypassSecret" :type="showBypassSecret ? 'text' : 'password'"
              placeholder="crypten-bypass-secret"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 py-2.5 pl-3.5 pr-10 text-sm text-white focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/20 font-mono" />
            <button type="button" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-white"
              @click="showBypassSecret = !showBypassSecret">
              <UIcon :name="showBypassSecret ? 'i-heroicons-eye-slash' : 'i-heroicons-eye'" class="h-4 w-4" />
            </button>
          </div>
          <p class="text-[11px] text-gray-400">
            Passed as <code>x-api-bypass</code> HTTP header to bypass rate limits / auth checks.
          </p>
        </div>
      </div>

      <!-- Quick Info Box -->
      <div class="rounded-xl border border-gray-800 bg-gray-950/70 p-4 space-y-3">
        <h3 class="text-xs font-bold text-white flex items-center gap-1.5">
          <UIcon name="i-heroicons-information-circle" class="h-4 w-4 text-emerald-400" />
          Image Upload Architecture &amp; Proxy Flow
        </h3>
        <ul class="text-xs text-gray-400 space-y-1.5 list-disc pl-4 leading-relaxed">
          <li>Campaign banner images, covers, and video uploads are proxied through
            <code>/api/media/upload?folder=...</code>.
          </li>
          <li>The backend Cloudflare Worker attaches <code>x-api-key</code> and <code>x-api-bypass</code> headers
            automatically.</li>
          <li>Updating these values here takes effect immediately without re-deploying backend environment variables.
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>
