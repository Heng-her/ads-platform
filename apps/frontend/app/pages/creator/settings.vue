<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useAuthStore } from '~/stores/auth'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'
import type { CloudinaryUploadResponse } from '~/composables/useCloudinaryUpload'

definePageMeta({
  layout: 'creator'
})

const authStore = useAuthStore()
const api = useApi()
const toast = useAppToast()

const isSaving = ref(false)

// Form state initialized from authStore
const profileForm = ref({
  username: '',
  email: '',
  avatar: '',
  portfolioLink: '',
  country: 'KH'
})

const countryOptions = [
  { code: 'KH', name: 'Cambodia (កម្ពុជា)' },
  { code: 'US', name: 'United States' },
  { code: 'SG', name: 'Singapore' },
  { code: 'TH', name: 'Thailand' },
  { code: 'VN', name: 'Vietnam' },
  { code: 'JP', name: 'Japan' }
]

function populateForm() {
  authStore.initAuth()
  if (authStore.user) {
    profileForm.value.username = authStore.user.username || ''
    profileForm.value.email = authStore.user.email || ''
    profileForm.value.avatar = authStore.user.avatar || ''
  }
}

onMounted(() => {
  populateForm()
  void authStore.fetchUserMe().then(() => populateForm())
})

async function saveProfileSettings() {
  isSaving.value = true

  try {
    const response = await api.action.$post({
      json: {
        action: 'users/update-profile',
        data: {
          username: profileForm.value.username,
          avatar: profileForm.value.avatar || null,
          portfolioLink: profileForm.value.portfolioLink || null,
          country: profileForm.value.country
        }
      }
    })

    const result = await response.json()
    if (response.ok && result.code === 1) {
      await authStore.fetchUserMe()
      toast.success('Workspace settings updated successfully!')
    } else {
      toast.error('Failed to update settings', result.msg || 'Please check your input.')
    }
  } catch (err: any) {
    toast.error('Save Error', err.message || 'An unexpected error occurred.')
  } finally {
    isSaving.value = false
  }
}

function onCreatorAvatarUploaded(payload: CloudinaryUploadResponse) {
  profileForm.value.avatar = payload.url
  toast.success('Avatar Uploaded', 'Creator profile picture updated successfully!')
}

function onCreatorAvatarError(msg: string) {
  toast.error('Upload Failed', msg)
}
</script>

<template>
  <div class="mx-auto max-w-5xl space-y-6 pb-12">
    <!-- Page Header -->
    <div class="flex flex-col gap-2 md:flex-row md:items-center md:justify-between">
      <div>
        <h1 class="text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
          Creator Workspace Settings
        </h1>
        <p class="text-sm text-gray-500 dark:text-gray-400">
          Manage your creator account profile and personal identity details.
        </p>
      </div>
      <button :disabled="isSaving"
        class="inline-flex items-center justify-center gap-2 rounded-lg bg-primary-600 px-5 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-primary-500 disabled:opacity-50"
        @click="saveProfileSettings">
        <UIcon v-if="isSaving" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
        <UIcon v-else name="i-heroicons-check" class="h-4 w-4" />
        <span>{{ isSaving ? 'Saving Changes...' : 'Save Settings' }}</span>
      </button>
    </div>

    <!-- Profile & Identity Section -->
    <div class="space-y-6">
      <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900">
        <div class="flex items-center gap-3 border-b border-gray-100 pb-4 dark:border-gray-800">
          <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-primary-500/10 text-primary-500">
            <UIcon name="i-heroicons-user-circle" class="h-6 w-6" />
          </div>
          <div>
            <h2 class="text-lg font-semibold text-gray-900 dark:text-white">Profile Details</h2>
            <p class="text-xs text-gray-500 dark:text-gray-400">
              This information will be displayed on your published articles and creator portfolio.
            </p>
          </div>
        </div>

        <div class="mt-6 grid gap-6 md:grid-cols-2">
          <!-- Avatar Preview & Upload -->
          <div class="col-span-2 space-y-3">
            <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300">Profile Avatar Image</label>
            <div class="flex flex-col sm:flex-row items-start sm:items-center gap-4">
              <!-- Avatar Circle Preview -->
              <div
                class="relative h-20 w-20 shrink-0 overflow-hidden rounded-full border-2 border-primary-500/40 bg-gray-100 dark:bg-gray-800 shadow-md group">
                <img v-if="profileForm.avatar" :src="profileForm.avatar" alt="Avatar Preview"
                  class="h-full w-full object-cover" />
                <div v-else class="flex h-full w-full items-center justify-center text-gray-400">
                  <UIcon name="i-heroicons-user" class="h-10 w-10" />
                </div>
                <button v-if="profileForm.avatar" type="button" title="Remove avatar"
                  class="absolute inset-0 bg-black/60 text-white opacity-0 group-hover:opacity-100 transition flex items-center justify-center text-xs font-medium"
                  @click="profileForm.avatar = ''">
                  Remove
                </button>
              </div>

              <!-- Media Uploader Component -->
              <div class="flex-1 w-full space-y-2">
                <AppMediaUploader folder="avatars" accept="image" label="Upload Avatar Image"
                  hint="PNG, JPG, WEBP or GIF up to 10MB" @uploaded="onCreatorAvatarUploaded"
                  @error="onCreatorAvatarError" />
              </div>
            </div>
            <!-- Optional URL input fallback -->
            <div class="space-y-1 pt-1">
              <label class="block text-[11px] text-gray-500 dark:text-gray-400">Or paste image URL directly</label>
              <input v-model="profileForm.avatar" type="url" placeholder="https://example.com/avatar.jpg"
                class="w-full rounded-lg border border-gray-300 bg-white px-3.5 py-1.5 text-xs text-gray-900 focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20 dark:border-gray-700 dark:bg-gray-800 dark:text-white" />
            </div>
          </div>

          <!-- Username -->
          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300">Username</label>
            <input v-model="profileForm.username" type="text"
              class="w-full rounded-lg border border-gray-300 bg-white px-3.5 py-2 text-sm text-gray-900 focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20 dark:border-gray-700 dark:bg-gray-800 dark:text-white" />
          </div>

          <!-- Email (Disabled) -->
          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300">Email Address (Primary)</label>
            <input v-model="profileForm.email" type="email" disabled
              class="w-full cursor-not-allowed rounded-lg border border-gray-200 bg-gray-50 px-3.5 py-2 text-sm text-gray-500 dark:border-gray-800 dark:bg-gray-950/60 dark:text-gray-400" />
          </div>

          <!-- Portfolio Link -->
          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300">Portfolio / Website Link</label>
            <input v-model="profileForm.portfolioLink" type="url" placeholder="https://mycreatorblog.com"
              class="w-full rounded-lg border border-gray-300 bg-white px-3.5 py-2 text-sm text-gray-900 focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20 dark:border-gray-700 dark:bg-gray-800 dark:text-white" />
          </div>

          <!-- Country -->
          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-700 dark:text-gray-300">Country / Region</label>
            <select v-model="profileForm.country"
              class="w-full rounded-lg border border-gray-300 bg-white px-3.5 py-2 text-sm text-gray-900 focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20 dark:border-gray-700 dark:bg-gray-800 dark:text-white">
              <option v-for="c in countryOptions" :key="c.code" :value="c.code">
                {{ c.name }}
              </option>
            </select>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
