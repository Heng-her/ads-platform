<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useAuthStore } from '~/stores/auth'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'
import AdminSettingsNavTabs from '~/components/admin/settings/AdminSettingsNavTabs.vue'
import AdminSettingsPlatform, { type PlatformConfig } from '~/components/admin/settings/AdminSettingsPlatform.vue'
import AdminSettingsDispatch, { type ChannelConfig } from '~/components/admin/settings/AdminSettingsDispatch.vue'
import AdminSettingsProfile, { type AdminProfile } from '~/components/admin/settings/AdminSettingsProfile.vue'

definePageMeta({
  layout: 'admin'
})

const authStore = useAuthStore()
const api = useApi()
const toast = useAppToast()
const route = useRoute()
const router = useRouter()

const activeTab = ref<'platform' | 'dispatch' | 'adminprofile'>('platform')
const isSaving = ref(false)

// Platform Configuration State
const platformConfig = ref<PlatformConfig>({
  siteName: 'New Platform',
  siteDescription: 'Multi-role New Platform supporting Public browsing, Creator Studio, and Admin Control.',
  defaultLanguage: 'en',
  allowRegistrations: true
})

// Telegram & Mail Channel Notification Config State
const channelConfig = ref<ChannelConfig>({
  telegramBotToken: '',
  telegramPublicChannelId: '',
  enablePublicChannel: true,
  telegramAdminGroupId: '',
  enableAdminGroupAlerts: true,
  mailSenderEmail: 'notifications@adsplatform.com',
  mailSmtpHost: 'smtp.gmail.com',
  mailSmtpPort: 587,
  enableMail: true,
  onUserSubmitMail: true,
  onUserSubmitAdminGroup: true,
  onPostPublishMail: true,
  onPostPublishPublicChannel: true,
  onPostPublishAdminGroup: true
})

// Admin Profile State
const adminProfile = ref<AdminProfile>({
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
      <button
        :disabled="isSaving"
        class="inline-flex items-center justify-center gap-2 rounded-lg bg-primary-600 px-5 py-2.5 text-sm font-semibold text-white shadow-sm transition hover:bg-primary-500 disabled:opacity-50"
        @click="saveAdminSettings"
      >
        <UIcon v-if="isSaving" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
        <UIcon v-else name="i-heroicons-check" class="h-4 w-4" />
        <span>{{ isSaving ? 'Applying Changes...' : 'Save Admin Settings' }}</span>
      </button>
    </div>

    <!-- Navigation Tabs -->
    <AdminSettingsNavTabs :active-tab="activeTab" @update:active-tab="setTab" />

    <!-- TAB 1: Platform General -->
    <AdminSettingsPlatform v-if="activeTab === 'platform'" v-model="platformConfig" />

    <!-- TAB 2: Telegram & Email Dispatch -->
    <AdminSettingsDispatch v-if="activeTab === 'dispatch'" v-model="channelConfig" />

    <!-- TAB 3: Admin Profile -->
    <AdminSettingsProfile v-if="activeTab === 'adminprofile'" v-model="adminProfile" />
  </div>
</template>
