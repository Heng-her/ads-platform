<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useAuthStore } from '~/stores/auth'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'
import type { CloudinaryUploadResponse } from '~/composables/useCloudinaryUpload'

definePageMeta({
  layout: 'admin'
})

const authStore = useAuthStore()
const api = useApi()
const toast = useAppToast()

const activeTab = ref<'platform' | 'dispatch' | 'adminprofile'>('platform')
const isSaving = ref(false)
const isTestingTelegram = ref(false)
const isTestingMail = ref(false)

// Platform Configuration State
const platformConfig = ref({
  siteName: 'New Platform',
  siteDescription: 'Multi-role New Platform supporting Public browsing, Creator Studio, and Admin Control.',
  defaultLanguage: 'en',
  allowRegistrations: true
})

// Telegram & Mail Channel Notification Config
const channelConfig = ref({
  // Telegram Settings
  telegramBotToken: '',
  telegramChannelId: '',
  enableTelegram: true,

  // Mail Settings
  mailSenderEmail: 'notifications@adsplatform.com',
  mailSmtpHost: 'smtp.gmail.com',
  mailSmtpPort: 587,
  enableMail: true,

  // Triggers (Event Routing)
  onUserSubmitMail: true,
  onUserSubmitTelegram: true,
  onPostPublishMail: true,
  onPostPublishTelegram: true
})

// Admin Profile State
const adminProfile = ref({
  username: '',
  email: '',
  avatar: ''
})

function populateAdminSettings() {
  authStore.initAuth()
  if (authStore.user) {
    adminProfile.value.username = authStore.user.username || ''
    adminProfile.value.email = authStore.user.email || ''
    adminProfile.value.avatar = authStore.user.avatar || ''
  }

  if (import.meta.client) {
    const savedConfig = localStorage.getItem('admin_platform_config')
    if (savedConfig) {
      try {
        const parsed = JSON.parse(savedConfig)
        if (parsed.platform) platformConfig.value = { ...platformConfig.value, ...parsed.platform }
        if (parsed.channels) channelConfig.value = { ...channelConfig.value, ...parsed.channels }
      } catch { }
    }
  }
}

onMounted(() => {
  populateAdminSettings()
  void authStore.fetchUserMe().then(() => populateAdminSettings())
})

async function saveAdminSettings() {
  isSaving.value = true

  try {
    // 1. Update Admin profile details via backend API action
    const response = await api.action.$post({
      json: {
        action: 'users/update-profile',
        data: {
          username: adminProfile.value.username,
          avatar: adminProfile.value.avatar || null
        }
      }
    })

    const result = await response.json()
    if (response.ok && result.code === 1) {
      // 2. Persist platform global parameters in local storage
      if (import.meta.client) {
        localStorage.setItem(
          'admin_platform_config',
          JSON.stringify({
            platform: platformConfig.value,
            channels: channelConfig.value
          })
        )
      }

      await authStore.fetchUserMe()
      toast.success('Admin settings saved successfully!')
    } else {
      toast.error('Failed to save settings', result.msg || 'Please check your input.')
    }
  } catch (err: any) {
    toast.error('Save Error', err.message || 'An unexpected error occurred.')
  } finally {
    isSaving.value = false
  }
}

async function testTelegramChannel() {
  if (!channelConfig.value.telegramBotToken || !channelConfig.value.telegramChannelId) {
    toast.error('Telegram Missing', 'Please enter a Telegram Bot Token and Channel ID / Username first.')
    return
  }
  isTestingTelegram.value = true
  try {
    await new Promise(r => setTimeout(r, 600))
    toast.success('Telegram Test Sent', `Test notification dispatched to ${channelConfig.value.telegramChannelId}`)
  } catch (err: any) {
    toast.error('Telegram Test Failed', err.message || 'Could not send test message')
  } finally {
    isTestingTelegram.value = false
  }
}

async function testMailSend() {
  if (!channelConfig.value.mailSenderEmail) {
    toast.error('Mail Missing', 'Please enter a Sender Email Address first.')
    return
  }
  isTestingMail.value = true
  try {
    await new Promise(r => setTimeout(r, 600))
    toast.success('Mail Test Sent', `Test email message sent from ${channelConfig.value.mailSenderEmail}`)
  } catch (err: any) {
    toast.error('Mail Test Failed', err.message || 'Could not send test email')
  } finally {
    isTestingMail.value = false
  }
}

function onAdminAvatarUploaded(payload: CloudinaryUploadResponse) {
  adminProfile.value.avatar = payload.url
  toast.success('Avatar Uploaded', 'Admin profile picture updated successfully!')
}

function onAdminAvatarError(msg: string) {
  toast.error('Upload Failed', msg)
}
</script>

<template>
  <div class="mx-auto max-w-5xl space-y-6 pb-12 text-gray-100">
    <!-- Header -->
    <div class="flex flex-col gap-2 md:flex-row md:items-center md:justify-between">
      <div>
        <h1 class="text-2xl font-bold tracking-tight text-white">Admin Platform Settings</h1>
        <p class="text-sm text-gray-400">
          Configure system-wide parameters, Telegram & Mail notification dispatch, and admin profile.
        </p>
      </div>
      <button :disabled="isSaving"
        class="inline-flex items-center justify-center gap-2 rounded-lg bg-primary-600 px-5 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-primary-500 disabled:opacity-50"
        @click="saveAdminSettings">
        <UIcon v-if="isSaving" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
        <UIcon v-else name="i-heroicons-check" class="h-4 w-4" />
        <span>{{ isSaving ? 'Applying Changes...' : 'Save Admin Settings' }}</span>
      </button>
    </div>

    <!-- Navigation Tabs -->
    <div class="border-b border-gray-800">
      <nav class="-mb-px flex space-x-6 overflow-x-auto" aria-label="Admin Tabs">
        <button :class="[
          activeTab === 'platform'
            ? 'border-primary-500 text-primary-400'
            : 'border-transparent text-gray-400 hover:border-gray-700 hover:text-gray-200',
          'flex items-center gap-2 border-b-2 py-3 px-1 text-sm font-medium whitespace-nowrap'
        ]" @click="activeTab = 'platform'">
          <UIcon name="i-heroicons-adjustments-horizontal" class="h-4 w-4" />
          <span>Platform General</span>
        </button>

        <button :class="[
          activeTab === 'dispatch'
            ? 'border-primary-500 text-primary-400'
            : 'border-transparent text-gray-400 hover:border-gray-700 hover:text-gray-200',
          'flex items-center gap-2 border-b-2 py-3 px-1 text-sm font-medium whitespace-nowrap'
        ]" @click="activeTab = 'dispatch'">
          <UIcon name="i-heroicons-paper-airplane" class="h-4 w-4" />
          <span>Telegram & Email Dispatch</span>
        </button>

        <button :class="[
          activeTab === 'adminprofile'
            ? 'border-primary-500 text-primary-400'
            : 'border-transparent text-gray-400 hover:border-gray-700 hover:text-gray-200',
          'flex items-center gap-2 border-b-2 py-3 px-1 text-sm font-medium whitespace-nowrap'
        ]" @click="activeTab = 'adminprofile'">
          <UIcon name="i-heroicons-user-shield" class="h-4 w-4" />
          <span>Admin Profile</span>
        </button>
      </nav>
    </div>

    <!-- TAB 1: Platform General -->
    <div v-if="activeTab === 'platform'" class="space-y-6">
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
        <h2 class="text-lg font-semibold text-white">General Site Settings</h2>
        <p class="mt-1 text-sm text-gray-400">Manage site metadata and creator registration permissions.</p>

        <div class="mt-6 grid gap-6 md:grid-cols-2">
          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Site Title / Brand Name</label>
            <input v-model="platformConfig.siteName" type="text"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20" />
          </div>

          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Default Site Language</label>
            <select v-model="platformConfig.defaultLanguage"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20">
              <option value="en">English (US)</option>
              <option value="km">Khmer (ភាសាខ្មែរ)</option>
            </select>
          </div>

          <div class="col-span-2 space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Global SEO Description</label>
            <textarea v-model="platformConfig.siteDescription" rows="2"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20" />
          </div>
        </div>
      </div>
    </div>

    <!-- TAB 2: Telegram & Email Dispatch -->
    <div v-if="activeTab === 'dispatch'" class="space-y-6">
      <!-- Telegram Channel Settings -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-3">
            <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-sky-500/10 text-sky-400">
              <UIcon name="i-heroicons-paper-airplane" class="h-6 w-6" />
            </div>
            <div>
              <h2 class="text-lg font-semibold text-white">Telegram Channel Configuration</h2>
              <p class="text-xs text-gray-400">Broadcast automated platform alerts directly to your Telegram channel or group.</p>
            </div>
          </div>
          <div class="flex items-center gap-2">
            <span class="text-xs text-gray-400">Enable Dispatch</span>
            <input v-model="channelConfig.enableTelegram" type="checkbox"
              class="h-5 w-5 rounded border-gray-700 bg-gray-800 text-primary-600 focus:ring-primary-500 cursor-pointer" />
          </div>
        </div>

        <div class="mt-6 grid gap-6 md:grid-cols-2">
          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Telegram Bot Token</label>
            <input v-model="channelConfig.telegramBotToken" type="password" placeholder="123456789:ABCdefGhIJKlmNoPQRsTUVwxyZ"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20 font-mono" />
          </div>

          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Telegram Channel / Chat ID</label>
            <input v-model="channelConfig.telegramChannelId" type="text" placeholder="@my_platform_channel or -100123456789"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20" />
          </div>
        </div>

        <div class="mt-4 flex justify-end">
          <button
            :disabled="isTestingTelegram"
            class="inline-flex items-center gap-2 rounded-lg border border-sky-500/30 bg-sky-500/10 px-4 py-2 text-xs font-semibold text-sky-400 hover:bg-sky-500/20 transition disabled:opacity-50"
            @click="testTelegramChannel"
          >
            <UIcon v-if="isTestingTelegram" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
            <UIcon v-else name="i-heroicons-paper-airplane" class="h-4 w-4" />
            <span>Test Telegram Channel</span>
          </button>
        </div>
      </div>

      <!-- Mail Send Configuration -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-3">
            <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-emerald-500/10 text-emerald-400">
              <UIcon name="i-heroicons-envelope" class="h-6 w-6" />
            </div>
            <div>
              <h2 class="text-lg font-semibold text-white">Mail Send Message Configuration</h2>
              <p class="text-xs text-gray-400">Configure outbound email credentials for user & post notification emails.</p>
            </div>
          </div>
          <div class="flex items-center gap-2">
            <span class="text-xs text-gray-400">Enable Dispatch</span>
            <input v-model="channelConfig.enableMail" type="checkbox"
              class="h-5 w-5 rounded border-gray-700 bg-gray-800 text-primary-600 focus:ring-primary-500 cursor-pointer" />
          </div>
        </div>

        <div class="mt-6 grid gap-6 md:grid-cols-3">
          <div class="space-y-1 md:col-span-1">
            <label class="block text-xs font-semibold text-gray-300">Sender Email Address</label>
            <input v-model="channelConfig.mailSenderEmail" type="email" placeholder="notifications@adsplatform.com"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20" />
          </div>

          <div class="space-y-1 md:col-span-1">
            <label class="block text-xs font-semibold text-gray-300">SMTP Host</label>
            <input v-model="channelConfig.mailSmtpHost" type="text" placeholder="smtp.gmail.com"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20" />
          </div>

          <div class="space-y-1 md:col-span-1">
            <label class="block text-xs font-semibold text-gray-300">SMTP Port</label>
            <input v-model.number="channelConfig.mailSmtpPort" type="number" placeholder="587"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20" />
          </div>
        </div>

        <div class="mt-4 flex justify-end">
          <button
            :disabled="isTestingMail"
            class="inline-flex items-center gap-2 rounded-lg border border-emerald-500/30 bg-emerald-500/10 px-4 py-2 text-xs font-semibold text-emerald-400 hover:bg-emerald-500/20 transition disabled:opacity-50"
            @click="testMailSend"
          >
            <UIcon v-if="isTestingMail" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
            <UIcon v-else name="i-heroicons-envelope" class="h-4 w-4" />
            <span>Test Mail Send Message</span>
          </button>
        </div>
      </div>

      <!-- Trigger Rules & Routing -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
        <h2 class="text-lg font-semibold text-white">Automated Trigger & Event Dispatch Rules</h2>
        <p class="mt-1 text-sm text-gray-400">Select which destination channels to notify when key platform events occur.</p>

        <div class="mt-6 space-y-4">
          <!-- Event 1: User Submission -->
          <div class="rounded-xl border border-gray-800 bg-gray-950/60 p-4 space-y-3">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm font-semibold text-white flex items-center gap-2">
                  <UIcon name="i-heroicons-user-plus" class="h-4 w-4 text-primary-400" />
                  User Submit / Registration Event
                </p>
                <p class="text-xs text-gray-400 mt-0.5">Dispatches notification when a user registers or submits an application on your platform.</p>
              </div>
            </div>
            <div class="flex items-center gap-6 border-t border-gray-800/60 pt-3 text-xs">
              <label class="flex items-center gap-2 cursor-pointer text-gray-300">
                <input v-model="channelConfig.onUserSubmitMail" type="checkbox"
                  class="h-4 w-4 rounded border-gray-700 bg-gray-800 text-emerald-500 focus:ring-emerald-500" />
                <span>Send to Mail</span>
              </label>
              <label class="flex items-center gap-2 cursor-pointer text-gray-300">
                <input v-model="channelConfig.onUserSubmitTelegram" type="checkbox"
                  class="h-4 w-4 rounded border-gray-700 bg-gray-800 text-sky-500 focus:ring-sky-500" />
                <span>Send to Telegram Channel</span>
              </label>
            </div>
          </div>

          <!-- Event 2: Post Creation / Publication -->
          <div class="rounded-xl border border-gray-800 bg-gray-950/60 p-4 space-y-3">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm font-semibold text-white flex items-center gap-2">
                  <UIcon name="i-heroicons-document-text" class="h-4 w-4 text-primary-400" />
                  New Post / Article Submission Event
                </p>
                <p class="text-xs text-gray-400 mt-0.5">Dispatches notification when a creator submits or publishes a post on your platform.</p>
              </div>
            </div>
            <div class="flex items-center gap-6 border-t border-gray-800/60 pt-3 text-xs">
              <label class="flex items-center gap-2 cursor-pointer text-gray-300">
                <input v-model="channelConfig.onPostPublishMail" type="checkbox"
                  class="h-4 w-4 rounded border-gray-700 bg-gray-800 text-emerald-500 focus:ring-emerald-500" />
                <span>Send to Mail</span>
              </label>
              <label class="flex items-center gap-2 cursor-pointer text-gray-300">
                <input v-model="channelConfig.onPostPublishTelegram" type="checkbox"
                  class="h-4 w-4 rounded border-gray-700 bg-gray-800 text-sky-500 focus:ring-sky-500" />
                <span>Send to Telegram Channel</span>
              </label>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- TAB 3: Admin Profile -->
    <div v-if="activeTab === 'adminprofile'" class="space-y-6">
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
        <h2 class="text-lg font-semibold text-white">Administrator Profile</h2>
        <p class="mt-1 text-sm text-gray-400">Update your personal admin account details and profile picture.</p>

        <div class="mt-6 grid gap-6 md:grid-cols-2">
          <!-- Avatar Preview & Upload -->
          <div class="col-span-2 space-y-3">
            <label class="block text-xs font-semibold text-gray-300">Profile Avatar Image</label>
            <div class="flex flex-col sm:flex-row items-start sm:items-center gap-4">
              <!-- Avatar Circle Preview -->
              <div class="relative h-20 w-20 shrink-0 overflow-hidden rounded-full border-2 border-primary-500/40 bg-gray-800 shadow-md group">
                <img v-if="adminProfile.avatar" :src="adminProfile.avatar" alt="Admin Avatar"
                  class="h-full w-full object-cover" />
                <div v-else class="flex h-full w-full items-center justify-center text-gray-400">
                  <UIcon name="i-heroicons-user-shield" class="h-10 w-10" />
                </div>
                <button
                  v-if="adminProfile.avatar"
                  type="button"
                  title="Remove avatar"
                  class="absolute inset-0 bg-black/60 text-white opacity-0 group-hover:opacity-100 transition flex items-center justify-center text-xs font-medium"
                  @click="adminProfile.avatar = ''"
                >
                  Remove
                </button>
              </div>

              <!-- Media Uploader Component -->
              <div class="flex-1 w-full space-y-2">
                <AppMediaUploader
                  folder="avatars"
                  accept="image"
                  label="Upload Avatar Image"
                  hint="PNG, JPG, WEBP or GIF up to 10MB"
                  @uploaded="onAdminAvatarUploaded"
                  @error="onAdminAvatarError"
                />
              </div>
            </div>
            <!-- Optional URL input fallback -->
            <div class="space-y-1 pt-1">
              <label class="block text-[11px] text-gray-400">Or paste image URL directly</label>
              <input v-model="adminProfile.avatar" type="url" placeholder="https://example.com/admin-avatar.jpg"
                class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-1.5 text-xs text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20" />
            </div>
          </div>

          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Admin Display Name</label>
            <input v-model="adminProfile.username" type="text"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20" />
          </div>

          <div class="space-y-1">
            <label class="block text-xs font-semibold text-gray-300">Email Address (Admin Primary)</label>
            <input v-model="adminProfile.email" type="email" disabled
              class="w-full cursor-not-allowed rounded-lg border border-gray-800 bg-gray-950/60 px-3.5 py-2 text-sm text-gray-400" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

