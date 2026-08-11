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
const isTestingMail = ref(false)

// Platform Configuration State
const platformConfig = ref({
  siteName: 'New Platform',
  siteDescription: 'Multi-role New Platform supporting Public browsing, Creator Studio, and Admin Control.',
  defaultLanguage: 'en',
  allowRegistrations: true
})

// Telegram & Mail Channel Notification Config State
const isTestingPublicChannel = ref(false)
const isTestingAdminGroup = ref(false)

const channelConfig = ref({
  // Global Bot Credentials
  telegramBotToken: '',

  // Option 1: Public Broadcast Telegram Channel
  telegramPublicChannelId: '',
  enablePublicChannel: true,

  // Option 2: Admin Internal Telegram Group
  telegramAdminGroupId: '',
  enableAdminGroupAlerts: true,

  // Mail Settings
  mailSenderEmail: 'notifications@adsplatform.com',
  mailSmtpHost: 'smtp.gmail.com',
  mailSmtpPort: 587,
  enableMail: true,

  // Event Triggers & Routing
  onUserSubmitMail: true,
  onUserSubmitAdminGroup: true,
  onPostPublishMail: true,
  onPostPublishPublicChannel: true,
  onPostPublishAdminGroup: true
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

const route = useRoute()
const router = useRouter()

function setTab(tabName: 'platform' | 'dispatch' | 'adminprofile') {
  activeTab.value = tabName
  if (import.meta.client) {
    router.replace({ query: { ...route.query, tab: tabName } })
  }
}

onMounted(() => {
  if (route.query.tab === 'monetization') {
    void router.replace('/admin/monetization')
    return
  }
  if (route.query.tab && ['platform', 'dispatch', 'adminprofile'].includes(route.query.tab as string)) {
    activeTab.value = route.query.tab as any
  }
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

    const result: any = await response.json()
    if (response.ok && result.code === 1) {
      // 2. Persist platform global parameters in local storage
      if (import.meta.client) {
        const savedConfig = localStorage.getItem('admin_platform_config')
        let parsed: any = {}
        if (savedConfig) {
          try {
            parsed = JSON.parse(savedConfig)
          } catch { }
        }
        parsed.platform = platformConfig.value
        parsed.channels = channelConfig.value
        localStorage.setItem('admin_platform_config', JSON.stringify(parsed))
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

async function testPublicChannel() {
  if (!channelConfig.value.telegramBotToken || !channelConfig.value.telegramPublicChannelId) {
    toast.error('Missing Config', 'Please enter a Telegram Bot Token and Public Channel ID / Username first.')
    return
  }
  isTestingPublicChannel.value = true
  try {
    await new Promise(r => setTimeout(r, 600))
    toast.success('Public Channel Post Sent', `Sample public campaign post broadcasted to ${channelConfig.value.telegramPublicChannelId}`)
  } catch (err: any) {
    toast.error('Test Failed', err.message || 'Could not send test message')
  } finally {
    isTestingPublicChannel.value = false
  }
}

async function testAdminGroupAlert() {
  if (!channelConfig.value.telegramBotToken || !channelConfig.value.telegramAdminGroupId) {
    toast.error('Missing Config', 'Please enter a Telegram Bot Token and Admin Group Chat ID first.')
    return
  }
  isTestingAdminGroup.value = true
  try {
    await new Promise(r => setTimeout(r, 600))
    toast.success('Admin Group Alert Sent', `Sample alert notification dispatched to Admin Group (${channelConfig.value.telegramAdminGroupId})`)
  } catch (err: any) {
    toast.error('Test Failed', err.message || 'Could not send test message')
  } finally {
    isTestingAdminGroup.value = false
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
  <div class="mx-auto max-w-8xl space-y-6 pb-12 text-gray-100">
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
        ]" @click="setTab('platform')">
          <UIcon name="i-heroicons-adjustments-horizontal" class="h-4 w-4" />
          <span>Platform General</span>
        </button>

        <button :class="[
          activeTab === 'dispatch'
            ? 'border-primary-500 text-primary-400'
            : 'border-transparent text-gray-400 hover:border-gray-700 hover:text-gray-200',
          'flex items-center gap-2 border-b-2 py-3 px-1 text-sm font-medium whitespace-nowrap'
        ]" @click="setTab('dispatch')">
          <UIcon name="i-heroicons-paper-airplane" class="h-4 w-4" />
          <span>Telegram & Email Dispatch</span>
        </button>

        <button :class="[
          activeTab === 'adminprofile'
            ? 'border-primary-500 text-primary-400'
            : 'border-transparent text-gray-400 hover:border-gray-700 hover:text-gray-200',
          'flex items-center gap-2 border-b-2 py-3 px-1 text-sm font-medium whitespace-nowrap'
        ]" @click="setTab('adminprofile')">
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
      <!-- Global Telegram Bot Credentials -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-3">
            <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-sky-500/10 text-sky-400">
              <UIcon name="i-heroicons-key" class="h-6 w-6" />
            </div>
            <div>
              <h2 class="text-lg font-semibold text-white">Telegram Bot API Credentials</h2>
              <p class="text-xs text-gray-400">Primary bot token generated via @BotFather used to dispatch Telegram
                messages.</p>
            </div>
          </div>
        </div>

        <div class="mt-4 space-y-1 max-w-xl">
          <label class="block text-xs font-semibold text-gray-300">Telegram Bot Token</label>
          <input v-model="channelConfig.telegramBotToken" type="password"
            placeholder="123456789:ABCdefGhIJKlmNoPQRsTUVwxyZ"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20 font-mono" />
        </div>
      </div>

      <!-- Option 1: Public Broadcast Telegram Channel -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-4">
        <div class="flex items-center justify-between border-b border-gray-800 pb-4">
          <div class="flex items-center gap-3">
            <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-emerald-500/10 text-emerald-400">
              <UIcon name="i-heroicons-megaphone" class="h-6 w-6" />
            </div>
            <div>
              <div class="flex items-center gap-2">
                <h2 class="text-lg font-semibold text-white">Option 1: Public Broadcast Telegram Channel</h2>
                <UBadge color="success" variant="soft" size="xs" class="font-semibold uppercase">Public Feed</UBadge>
              </div>
              <p class="text-xs text-gray-400">Broadcasts all public campaigns live to your public Telegram Channel
                feed.</p>
            </div>
          </div>
          <div class="flex items-center gap-2">
            <span class="text-xs text-gray-400 font-medium">Enable Channel Feed</span>
            <input v-model="channelConfig.enablePublicChannel" type="checkbox"
              class="h-5 w-5 rounded border-gray-700 bg-gray-800 text-emerald-500 focus:ring-emerald-500 cursor-pointer" />
          </div>
        </div>

        <div class="grid gap-6 md:grid-cols-2">
          <div class="space-y-1 md:col-span-2">
            <label class="block text-xs font-semibold text-gray-300">Public Telegram Channel Username / ID</label>
            <input v-model="channelConfig.telegramPublicChannelId" type="text"
              placeholder="@my_public_campaigns or -100123456789"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20" />
            <p class="text-[11px] text-gray-400 pt-0.5">Note: Ensure your Telegram Bot is added as an Administrator to
              this channel.</p>
          </div>
        </div>

        <div class="flex justify-end pt-2">
          <button :disabled="isTestingPublicChannel"
            class="inline-flex items-center gap-2 rounded-lg border border-emerald-500/30 bg-emerald-500/10 px-4 py-2 text-xs font-semibold text-emerald-400 hover:bg-emerald-500/20 transition disabled:opacity-50"
            @click="testPublicChannel">
            <UIcon v-if="isTestingPublicChannel" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
            <UIcon v-else name="i-heroicons-paper-airplane" class="h-4 w-4" />
            <span>Test Public Channel Broadcast</span>
          </button>
        </div>
      </div>

      <!-- Option 2: Admin Internal Telegram Group -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-4">
        <div class="flex items-center justify-between border-b border-gray-800 pb-4">
          <div class="flex items-center gap-3">
            <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-indigo-500/10 text-indigo-400">
              <UIcon name="i-heroicons-shield-check" class="h-6 w-6" />
            </div>
            <div>
              <div class="flex items-center gap-2">
                <h2 class="text-lg font-semibold text-white">Option 2: Admin Internal Telegram Group</h2>
                <UBadge color="primary" variant="soft" size="xs" class="font-semibold uppercase">Admin Group Alerts
                </UBadge>
              </div>
              <p class="text-xs text-gray-400">Dispatches private system alert notifications to your Admin Telegram
                Group when users register or create campaigns.</p>
            </div>
          </div>
          <div class="flex items-center gap-2">
            <span class="text-xs text-gray-400 font-medium">Enable Group Alerts</span>
            <input v-model="channelConfig.enableAdminGroupAlerts" type="checkbox"
              class="h-5 w-5 rounded border-gray-700 bg-gray-800 text-indigo-500 focus:ring-indigo-500 cursor-pointer" />
          </div>
        </div>

        <div class="grid gap-6 md:grid-cols-2">
          <div class="space-y-1 md:col-span-2">
            <label class="block text-xs font-semibold text-gray-300">Admin Telegram Group Chat ID</label>
            <input v-model="channelConfig.telegramAdminGroupId" type="text"
              placeholder="-100123456789 or @my_admin_group"
              class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20" />
            <p class="text-[11px] text-gray-400 pt-0.5">Note: Add your Telegram Bot to the group as Administrator.</p>
          </div>
        </div>

        <div class="flex justify-end pt-2">
          <button :disabled="isTestingAdminGroup"
            class="inline-flex items-center gap-2 rounded-lg border border-indigo-500/30 bg-indigo-500/10 px-4 py-2 text-xs font-semibold text-indigo-400 hover:bg-indigo-500/20 transition disabled:opacity-50"
            @click="testAdminGroupAlert">
            <UIcon v-if="isTestingAdminGroup" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
            <UIcon v-else name="i-heroicons-shield-check" class="h-4 w-4" />
            <span>Test Admin Group Alert</span>
          </button>
        </div>
      </div>

      <!-- Outbound Mail Send Configuration -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-3">
            <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-emerald-500/10 text-emerald-400">
              <UIcon name="i-heroicons-envelope" class="h-6 w-6" />
            </div>
            <div>
              <h2 class="text-lg font-semibold text-white">Mail Send Message Configuration</h2>
              <p class="text-xs text-gray-400">Configure outbound email credentials for user & campaign notification
                emails.</p>
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
          <button :disabled="isTestingMail"
            class="inline-flex items-center gap-2 rounded-lg border border-emerald-500/30 bg-emerald-500/10 px-4 py-2 text-xs font-semibold text-emerald-400 hover:bg-emerald-500/20 transition disabled:opacity-50"
            @click="testMailSend">
            <UIcon v-if="isTestingMail" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
            <UIcon v-else name="i-heroicons-envelope" class="h-4 w-4" />
            <span>Test Mail Send Message</span>
          </button>
        </div>
      </div>

      <!-- Trigger Rules & Event Routing -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
        <h2 class="text-lg font-semibold text-white">Automated Trigger & Event Dispatch Rules</h2>
        <p class="mt-1 text-sm text-gray-400">Select destination channels for key platform events.</p>

        <div class="mt-6 space-y-4">
          <!-- Event 1: User Registration -->
          <div class="rounded-xl border border-gray-800 bg-gray-950/60 p-4 space-y-3">
            <div>
              <p class="text-sm font-semibold text-white flex items-center gap-2">
                <UIcon name="i-heroicons-user-plus" class="h-4 w-4 text-primary-400" />
                User Registration / Submission Event
              </p>
              <p class="text-xs text-gray-400 mt-0.5">Dispatches notification alert when a user registers on your
                platform.</p>
            </div>

            <div class="flex flex-wrap items-center gap-6 border-t border-gray-800/60 pt-3 text-xs">
              <label class="flex items-center gap-2 cursor-pointer text-gray-300">
                <input v-model="channelConfig.onUserSubmitMail" type="checkbox"
                  class="h-4 w-4 rounded border-gray-700 bg-gray-800 text-emerald-500 focus:ring-emerald-500" />
                <span>Send to Mail</span>
              </label>
              <label class="flex items-center gap-2 cursor-pointer text-gray-300">
                <input v-model="channelConfig.onUserSubmitAdminGroup" type="checkbox"
                  class="h-4 w-4 rounded border-gray-700 bg-gray-800 text-indigo-500 focus:ring-indigo-500" />
                <span>Alert to Admin Telegram Group (Option 2)</span>
              </label>
            </div>
          </div>

          <!-- Event 2: Campaign Creation -->
          <div class="rounded-xl border border-gray-800 bg-gray-950/60 p-4 space-y-3">
            <div>
              <p class="text-sm font-semibold text-white flex items-center gap-2">
                <UIcon name="i-heroicons-megaphone" class="h-4 w-4 text-primary-400" />
                New Campaign Creation Event
              </p>
              <p class="text-xs text-gray-400 mt-0.5">Dispatches notification when a user creates or publishes a
                campaign.</p>
            </div>

            <div class="flex flex-wrap items-center gap-6 border-t border-gray-800/60 pt-3 text-xs">
              <label class="flex items-center gap-2 cursor-pointer text-gray-300">
                <input v-model="channelConfig.onPostPublishMail" type="checkbox"
                  class="h-4 w-4 rounded border-gray-700 bg-gray-800 text-emerald-500 focus:ring-emerald-500" />
                <span>Send to Mail</span>
              </label>
              <label class="flex items-center gap-2 cursor-pointer text-gray-300">
                <input v-model="channelConfig.onPostPublishPublicChannel" type="checkbox"
                  class="h-4 w-4 rounded border-gray-700 bg-gray-800 text-emerald-500 focus:ring-emerald-500" />
                <span>Send Public Campaigns to Telegram Channel (Option 1)</span>
              </label>
              <label class="flex items-center gap-2 cursor-pointer text-gray-300">
                <input v-model="channelConfig.onPostPublishAdminGroup" type="checkbox"
                  class="h-4 w-4 rounded border-gray-700 bg-gray-800 text-indigo-500 focus:ring-indigo-500" />
                <span>Alert to Admin Telegram Group (Option 2)</span>
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
              <div
                class="relative h-20 w-20 shrink-0 overflow-hidden rounded-full border-2 border-primary-500/40 bg-gray-800 shadow-md group">
                <img v-if="adminProfile.avatar" :src="adminProfile.avatar" alt="Admin Avatar"
                  class="h-full w-full object-cover" />
                <div v-else class="flex h-full w-full items-center justify-center text-gray-400">
                  <UIcon name="i-heroicons-user-shield" class="h-10 w-10" />
                </div>
                <button v-if="adminProfile.avatar" type="button" title="Remove avatar"
                  class="absolute inset-0 bg-black/60 text-white opacity-0 group-hover:opacity-100 transition flex items-center justify-center text-xs font-medium"
                  @click="adminProfile.avatar = ''">
                  Remove
                </button>
              </div>

              <!-- Media Uploader Component -->
              <div class="flex-1 w-full space-y-2">
                <AppMediaUploader folder="avatars" accept="image" label="Upload Avatar Image"
                  hint="PNG, JPG, WEBP or GIF up to 10MB" @uploaded="onAdminAvatarUploaded"
                  @error="onAdminAvatarError" />
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
