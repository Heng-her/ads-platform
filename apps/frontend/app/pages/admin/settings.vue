<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useAuthStore } from '~/stores/auth'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'
import AdminSettingsNavTabs from '~/components/admin/settings/AdminSettingsNavTabs.vue'
import AdminSettingsPlatform, { type PlatformConfig, type SecurityConfig } from '~/components/admin/settings/AdminSettingsPlatform.vue'
import AdminSettingsDispatch, { type ChannelConfig } from '~/components/admin/settings/AdminSettingsDispatch.vue'
import AdminSettingsPost, { type PostConfig } from '~/components/admin/settings/AdminSettingsPost.vue'
import AdminSettingsGoogleAuth, { type GoogleAuthConfig } from '~/components/admin/settings/AdminSettingsGoogleAuth.vue'
import AdminSettingsUploadApi, { type UploadConfig } from '~/components/admin/settings/AdminSettingsUploadApi.vue'
import AdminSettingsProfile, { type AdminProfile } from '~/components/admin/settings/AdminSettingsProfile.vue'
import AdminActionButton from '~/components/admin/common/AdminActionButton.vue'
import { decryptData } from '~/lib/crypto'

definePageMeta({
  layout: 'admin'
})

const authStore = useAuthStore()
const api = useApi()
const toast = useAppToast()
const route = useRoute()
const router = useRouter()

const activeTab = ref<'platform' | 'dispatch' | 'post' | 'googleauth' | 'uploadapi' | 'adminprofile'>('platform')
const isSaving = ref(false)
const isLoading = ref(true)

// Platform Configuration State
const platformConfig = ref<PlatformConfig>({
  siteName: 'New Platform',
  siteDescription: 'Multi-role New Platform supporting Public browsing, Creator Studio, and Admin Control.',
  siteUrl: 'http://localhost:3000',
  defaultLanguage: 'en',
  allowRegistrations: true
})

// Creator Deletion Security Config State
const securityConfig = ref<SecurityConfig>({
  creatorDeletionPassword: 'admin'
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
  mailSmtpUser: '',
  mailSmtpPassword: '',
  enableMail: true,
  onUserSubmitMail: true,
  onUserSubmitAdminGroup: true,
  onPostPublishMail: true,
  onPostPublishPublicChannel: true,
  onPostPublishAdminGroup: true
})

// Post & Media Attachment Limit State
const postConfig = ref<PostConfig>({
  maxPostPerDay: 5,
  maxUploadImage: 10,
  maxUploadVideo: 2,
  maxRegisterPerDay: 5
})

// Google Auth OAuth Credentials State
const googleAuthConfig = ref<GoogleAuthConfig>({
  googleClientId: '',
  googleClientSecret: '',
  enableGoogleAuth: true
})

// Image Upload API Microservice Config State
const uploadConfig = ref<UploadConfig>({
  uploadApiBaseUrl: 'https://api-upload-image-8ym9.onrender.com',
  uploadApiKey: 'crypten-api-key',
  uploadApiBypassSecret: 'crypten-bypass-secret'
})

// Admin Profile State
const adminProfile = ref<AdminProfile>({
  username: '',
  email: '',
  avatar: ''
})

async function fetchSystemSettings() {
  isLoading.value = true
  try {
    const res = await api.action.$post({
      json: { action: 'settings/get-all' }
    })
    const result: any = await res.json()
    if (res.ok && result.code === 1 && result.data) {
      let dataPayload = result.data
      if (result.encrypted && typeof result.data === 'string') {
        dataPayload = decryptData(result.data) || {}
      }

      if (dataPayload.platform) {
        platformConfig.value = { ...platformConfig.value, ...dataPayload.platform }
      }
      if (dataPayload.security) {
        securityConfig.value = { ...securityConfig.value, ...dataPayload.security }
      }
      if (dataPayload.dispatch) {
        channelConfig.value = { ...channelConfig.value, ...dataPayload.dispatch }
      }
      if (dataPayload.post) {
        postConfig.value = { ...postConfig.value, ...dataPayload.post }
      }
      if (dataPayload.googleauth) {
        googleAuthConfig.value = { ...googleAuthConfig.value, ...dataPayload.googleauth }
      }
      if (dataPayload.upload) {
        uploadConfig.value = { ...uploadConfig.value, ...dataPayload.upload }
      }
    }
  } catch {

    // Fallback to local storage if offline or error occurs
    if (import.meta.client) {
      const savedConfig = localStorage.getItem('admin_platform_config')
      if (savedConfig) {
        try {
          const parsed = JSON.parse(savedConfig)
          if (parsed.platform) platformConfig.value = { ...platformConfig.value, ...parsed.platform }
          if (parsed.security) securityConfig.value = { ...securityConfig.value, ...parsed.security }
          if (parsed.channels) channelConfig.value = { ...channelConfig.value, ...parsed.channels }
          if (parsed.post) postConfig.value = { ...postConfig.value, ...parsed.post }
          if (parsed.googleauth) googleAuthConfig.value = { ...googleAuthConfig.value, ...parsed.googleauth }
          if (parsed.upload) uploadConfig.value = { ...uploadConfig.value, ...parsed.upload }
        } catch { }
      }
    }
  } finally {
    isLoading.value = false
  }
}

function populateAdminProfile() {
  authStore.initAuth()
  if (authStore.user) {
    adminProfile.value.username = authStore.user.username || ''
    adminProfile.value.email = authStore.user.email || ''
    adminProfile.value.avatar = authStore.user.avatar || ''
  }
}

function setTab(tabName: 'platform' | 'dispatch' | 'post' | 'googleauth' | 'uploadapi' | 'adminprofile') {
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
  if (route.query.tab && ['platform', 'dispatch', 'post', 'googleauth', 'uploadapi', 'adminprofile'].includes(route.query.tab as string)) {
    activeTab.value = route.query.tab as any
  }
  populateAdminProfile()
  void authStore.fetchUserMe().then(() => populateAdminProfile())
  void fetchSystemSettings()
})

async function saveAdminSettings() {
  isSaving.value = true

  try {
    // 1. Update Admin profile details via backend API action
    const profileRes = await api.action.$post({
      json: {
        action: 'users/update-profile',
        data: {
          username: adminProfile.value.username,
          avatar: adminProfile.value.avatar || null
        }
      }
    })
    const profileResult: any = await profileRes.json()

    // 2. Persist platform, dispatch, post, googleauth & upload configs via backend API action
    const settingRes = await api.action.$post({
      json: {
        action: 'settings/save-all',
        data: {
          platform: platformConfig.value,
          security: securityConfig.value,
          dispatch: channelConfig.value,
          post: postConfig.value,
          googleauth: googleAuthConfig.value,
          upload: uploadConfig.value
        }
      }
    })
    const settingResult: any = await settingRes.json()

    if (settingRes.ok && settingResult.code === 1 && profileRes.ok && profileResult.code === 1) {
      // 3. Persist local storage copy as offline cache
      if (import.meta.client) {
        const savedConfig = localStorage.getItem('admin_platform_config')
        let parsed: any = {}
        if (savedConfig) {
          try {
            parsed = JSON.parse(savedConfig)
          } catch { }
        }
        parsed.platform = platformConfig.value
        parsed.security = securityConfig.value
        parsed.channels = channelConfig.value
        parsed.post = postConfig.value
        parsed.googleauth = googleAuthConfig.value
        parsed.upload = uploadConfig.value
        localStorage.setItem('admin_platform_config', JSON.stringify(parsed))
      }

      await authStore.fetchUserMe()
      toast.success('Admin settings saved successfully!')
    } else {
      toast.error('Failed to save settings', settingResult.msg || profileResult.msg || 'Please check your input.')
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
          Configure system-wide parameters, Telegram & Mail notification dispatch, post campaign limits, Google OAuth, Image Upload API, and admin profile.
        </p>
      </div>
      <AdminActionButton
        :loading="isSaving"
        :disabled="isLoading"
        icon="i-heroicons-check"
        size="md"
        @click="saveAdminSettings"
      >
        {{ isSaving ? 'Applying Changes...' : 'Save Admin Settings' }}
      </AdminActionButton>
    </div>

    <!-- Navigation Tabs -->
    <AdminSettingsNavTabs :active-tab="activeTab" @update:active-tab="setTab" />

    <!-- Loading State -->
    <div v-if="isLoading" class="flex flex-col items-center justify-center py-16 space-y-3 rounded-xl border border-gray-800 bg-gray-900">
      <UIcon name="i-heroicons-arrow-path" class="h-8 w-8 animate-spin text-primary-500" />
      <p class="text-sm text-gray-400">Loading system configurations...</p>
    </div>

    <template v-else>
      <!-- TAB 1: Platform General & Security -->
      <AdminSettingsPlatform v-if="activeTab === 'platform'" v-model="platformConfig" v-model:security="securityConfig" />

      <!-- TAB 2: Telegram & Email Dispatch -->
      <AdminSettingsDispatch v-if="activeTab === 'dispatch'" v-model="channelConfig" />

      <!-- TAB 3: Post & Media Limits -->
      <AdminSettingsPost v-if="activeTab === 'post'" v-model="postConfig" />

      <!-- TAB 4: Google OAuth Config -->
      <AdminSettingsGoogleAuth v-if="activeTab === 'googleauth'" v-model="googleAuthConfig" />

      <!-- TAB 5: Image Upload API Config -->
      <AdminSettingsUploadApi v-if="activeTab === 'uploadapi'" v-model="uploadConfig" />

      <!-- TAB 6: Admin Profile -->
      <AdminSettingsProfile v-if="activeTab === 'adminprofile'" v-model="adminProfile" />
    </template>
  </div>
</template>

