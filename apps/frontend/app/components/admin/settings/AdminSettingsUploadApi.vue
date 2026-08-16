<script setup lang="ts">
import { ref } from 'vue'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'
import AdminSettingInput from './AdminSettingInput.vue'

export interface UploadConfig {
  uploadApiBaseUrl: string
  uploadApiKey: string
  uploadApiBypassSecret: string
}

const config = defineModel<UploadConfig>({ required: true })
const api = useApi()
const toast = useAppToast()

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
        <div class="md:col-span-2">
          <AdminSettingInput
            v-model="config.uploadApiBaseUrl"
            label="Upload API Base URL (UPLOAD_API_BASE_URL)"
            type="url"
            icon="i-heroicons-link"
            placeholder="https://api-upload-image-8ym9.onrender.com"
            hint="The base URL of your deployed image upload microservice (e.g. Render / Express app)."
          />
        </div>

        <!-- API Key -->
        <div>
          <AdminSettingInput
            v-model="config.uploadApiKey"
            label="Upload API Key (UPLOAD_API_KEY)"
            type="password"
            icon="i-heroicons-key"
            placeholder="crypten-api-key"
            hint="Passed as x-api-key HTTP header during image upload requests."
          />
        </div>

        <!-- Bypass Secret -->
        <div>
          <AdminSettingInput
            v-model="config.uploadApiBypassSecret"
            label="Upload API Bypass Secret (UPLOAD_API_BYPASS_SECRET)"
            type="password"
            icon="i-heroicons-shield-exclamation"
            placeholder="crypten-bypass-secret"
            hint="Passed as x-api-bypass HTTP header to bypass rate limits / auth checks."
          />
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
