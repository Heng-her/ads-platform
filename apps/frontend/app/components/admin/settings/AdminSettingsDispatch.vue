<script setup lang="ts">
import { ref } from 'vue'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'

export interface ChannelConfig {
  telegramBotToken: string
  telegramPublicChannelId: string
  enablePublicChannel: boolean
  telegramAdminGroupId: string
  enableAdminGroupAlerts: boolean
  mailSenderEmail: string
  mailSmtpHost: string
  mailSmtpPort: number
  mailSmtpUser?: string
  mailSmtpPassword?: string
  enableMail: boolean
  onUserSubmitMail: boolean
  onUserSubmitAdminGroup: boolean
  onPostPublishMail: boolean
  onPostPublishPublicChannel: boolean
  onPostPublishAdminGroup: boolean
}

const config = defineModel<ChannelConfig>({ required: true })
const api = useApi()
const toast = useAppToast()

const isTestingPublicChannel = ref(false)
const isTestingAdminGroup = ref(false)
const isTestingMail = ref(false)
const testRecipientEmail = ref('')

const isResendActive = computed(() => {
  return config.value.mailSmtpPassword?.trim().startsWith('re_')
})

const isSendGridActive = computed(() => {
  return config.value.mailSmtpPassword?.trim().startsWith('SG.')
})

function applyResendPreset() {
  config.value.mailSmtpHost = 'api.resend.com'
  config.value.mailSmtpPort = 465
  config.value.mailSmtpUser = 'resend'
  if (!config.value.mailSenderEmail || config.value.mailSenderEmail === 'notifications@adsplatform.com') {
    config.value.mailSenderEmail = 'onboarding@resend.dev'
  }
  toast.success('Resend Preset Applied', 'Enter your Resend API key (re_...) in the API Key field.')
}

async function testPublicChannel() {
  if (!config.value.telegramBotToken || !config.value.telegramPublicChannelId) {
    toast.error('Missing Config', 'Please enter a Telegram Bot Token and Public Channel ID / Username first.')
    return
  }
  isTestingPublicChannel.value = true
  try {
    const res = await api.action.$post({
      json: {
        action: 'settings/test-dispatch',
        data: {
          channelType: 'public_channel',
          config: config.value
        }
      }
    })
    const result: any = await res.json()
    if (res.ok && result.code === 1) {
      toast.success('Public Channel Test Passed', result.msg)
    } else {
      toast.error('Test Failed', result.msg || 'Could not send test message')
    }
  } catch (err: any) {
    toast.error('Test Error', err.message || 'Could not send test message')
  } finally {
    isTestingPublicChannel.value = false
  }
}

async function testAdminGroupAlert() {
  if (!config.value.telegramBotToken || !config.value.telegramAdminGroupId) {
    toast.error('Missing Config', 'Please enter a Telegram Bot Token and Admin Group Chat ID first.')
    return
  }
  isTestingAdminGroup.value = true
  try {
    const res = await api.action.$post({
      json: {
        action: 'settings/test-dispatch',
        data: {
          channelType: 'admin_group',
          config: config.value
        }
      }
    })
    const result: any = await res.json()
    if (res.ok && result.code === 1) {
      toast.success('Admin Group Test Passed', result.msg)
    } else {
      toast.error('Test Failed', result.msg || 'Could not send test message')
    }
  } catch (err: any) {
    toast.error('Test Error', err.message || 'Could not send test message')
  } finally {
    isTestingAdminGroup.value = false
  }
}

async function testMailSend() {
  if (!config.value.mailSenderEmail) {
    toast.error('Mail Missing', 'Please enter a Sender Email Address first.')
    return
  }
  isTestingMail.value = true
  try {
    const res = await api.action.$post({
      json: {
        action: 'settings/test-dispatch',
        data: {
          channelType: 'mail',
          config: config.value,
          recipientEmail: testRecipientEmail.value.trim() || undefined
        }
      }
    })
    const result: any = await res.json()
    if (res.ok && result.code === 1) {
      toast.success('Mail Test Passed', result.msg)
    } else {
      toast.error('Test Failed', result.msg || 'Could not send test email')
    }
  } catch (err: any) {
    toast.error('Test Error', err.message || 'Could not send test email')
  } finally {
    isTestingMail.value = false
  }
}
</script>

<template>
  <div class="space-y-6">
    <!-- Global Telegram Bot Credentials -->
    <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
      <div class="flex items-center justify-between">
        <div class="flex items-center gap-3">
          <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-sky-500/10 text-sky-400">
            <UIcon name="i-heroicons-key" class="h-6 w-6" />
          </div>
          <div>
            <h2 class="text-lg font-semibold text-white">Telegram Bot API Credentials</h2>
            <p class="text-xs text-gray-400">
              Primary bot token generated via @BotFather used to dispatch Telegram messages.
            </p>
          </div>
        </div>
      </div>

      <div class="mt-4 space-y-1 max-w-xl">
        <label class="block text-xs font-semibold text-gray-300">Telegram Bot Token</label>
        <input v-model="config.telegramBotToken" type="password" placeholder="123456789:ABCdefGhIJKlmNoPQRsTUVwxyZ"
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
            <p class="text-xs text-gray-400">
              Broadcasts all public campaigns live to your public Telegram Channel feed.
            </p>
          </div>
        </div>
        <div class="flex items-center gap-2">
          <span class="text-xs text-gray-400 font-medium">Enable Channel Feed</span>
          <input v-model="config.enablePublicChannel" type="checkbox"
            class="h-5 w-5 rounded border-gray-700 bg-gray-800 text-emerald-500 focus:ring-emerald-500 cursor-pointer" />
        </div>
      </div>

      <div class="grid gap-6 md:grid-cols-2">
        <div class="space-y-1 md:col-span-2">
          <label class="block text-xs font-semibold text-gray-300">Public Telegram Channel Username / ID</label>
          <input v-model="config.telegramPublicChannelId" type="text"
            placeholder="@my_public_campaigns or -100123456789"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20" />
          <p class="text-[11px] text-gray-400 pt-0.5">
            Note: Ensure your Telegram Bot is added as an Administrator to this channel.
          </p>
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
            <p class="text-xs text-gray-400">
              Dispatches private system alert notifications to your Admin Telegram Group when users register or create
              campaigns.
            </p>
          </div>
        </div>
        <div class="flex items-center gap-2">
          <span class="text-xs text-gray-400 font-medium">Enable Group Alerts</span>
          <input v-model="config.enableAdminGroupAlerts" type="checkbox"
            class="h-5 w-5 rounded border-gray-700 bg-gray-800 text-indigo-500 focus:ring-indigo-500 cursor-pointer" />
        </div>
      </div>

      <div class="grid gap-6 md:grid-cols-2">
        <div class="space-y-1 md:col-span-2">
          <label class="block text-xs font-semibold text-gray-300">Admin Telegram Group Chat ID</label>
          <input v-model="config.telegramAdminGroupId" type="text" placeholder="-100123456789 or @my_admin_group"
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
      <div class="flex items-center justify-between border-b border-gray-800 pb-4">
        <div class="flex items-center gap-3">
          <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-emerald-500/10 text-emerald-400">
            <UIcon name="i-heroicons-envelope" class="h-6 w-6" />
          </div>
          <div>
            <div class="flex items-center gap-2">
              <h2 class="text-lg font-semibold text-white">Mail Send Message Configuration</h2>
              <UBadge v-if="isResendActive" color="warning" variant="soft" size="xs" class="font-semibold uppercase">
                Resend API Active</UBadge>
              <UBadge v-else-if="isSendGridActive" color="info" variant="soft" size="xs"
                class="font-semibold uppercase">SendGrid API Active</UBadge>
            </div>
            <p class="text-xs text-gray-400">
              Configure outbound email credentials for user & campaign notification emails via HTTPS Mail APIs or SMTP.
            </p>
          </div>
        </div>
        <div class="flex items-center gap-4">
          <button type="button"
            class="rounded-lg border border-gray-700 bg-gray-800 px-3 py-1.5 text-xs font-medium text-gray-300 hover:bg-gray-700 transition"
            @click="applyResendPreset">
            ⚡ Auto-Fill Resend Preset
          </button>
          <div class="flex items-center gap-2">
            <span class="text-xs text-gray-400">Enable Dispatch</span>
            <input v-model="config.enableMail" type="checkbox"
              class="h-5 w-5 rounded border-gray-700 bg-gray-800 text-primary-600 focus:ring-primary-500 cursor-pointer" />
          </div>
        </div>
      </div>

      <div class="mt-6 grid gap-6 md:grid-cols-3">
        <div class="space-y-1 md:col-span-1">
          <label class="block text-xs font-semibold text-gray-300">Sender Email Address</label>
          <input v-model="config.mailSenderEmail" type="email"
            placeholder="onboarding@resend.dev or notifications@nealika.com"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20" />
          <p class="text-[11px] text-gray-400 pt-0.5">Use verified domain email or <code>onboarding@resend.dev</code>
            for testing.</p>
        </div>

        <div class="space-y-1 md:col-span-1">
          <label class="block text-xs font-semibold text-gray-300">SMTP Host / API Server</label>
          <input v-model="config.mailSmtpHost" type="text" placeholder="api.resend.com or smtp.gmail.com"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20" />
        </div>

        <div class="space-y-1 md:col-span-1">
          <label class="block text-xs font-semibold text-gray-300">SMTP Port</label>
          <input v-model.number="config.mailSmtpPort" type="number" placeholder="465"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20" />
        </div>

        <div class="space-y-1 md:col-span-1">
          <label class="block text-xs font-semibold text-gray-300">SMTP Username / API User</label>
          <input v-model="config.mailSmtpUser" type="text" placeholder="resend or apikey"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20" />
        </div>

        <div class="space-y-1 md:col-span-2">
          <label class="block text-xs font-semibold text-gray-300">SMTP Password / Resend API Key</label>
          <input v-model="config.mailSmtpPassword" type="password" placeholder="re_123456789... (Resend API key)"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3.5 py-2 text-sm text-white focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20 font-mono" />
          <p v-if="isResendActive" class="text-[11px] text-emerald-400 font-medium pt-0.5 flex items-center gap-1">
            <UIcon name="i-heroicons-check-circle" class="h-3.5 w-3.5" />
            Resend API key detected (starts with re_). Messages will be sent live via Resend HTTPS API.
          </p>
        </div>
      </div>

      <div
        class="mt-4 flex flex-col sm:flex-row items-end sm:items-center justify-between gap-4 border-t border-gray-800 pt-4">
        <div class="w-full sm:w-80 space-y-1">
          <label class="block text-xs font-semibold text-gray-300">Test Recipient Email (To:)</label>
          <input v-model="testRecipientEmail" type="email" placeholder="your-personal@email.com"
            class="w-full rounded-lg border border-gray-700 bg-gray-800 px-3 py-1.5 text-xs text-white focus:border-primary-500 focus:outline-none" />
        </div>
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
            <p class="text-xs text-gray-400 mt-0.5">
              Dispatches notification alert when a user registers on your platform.
            </p>
          </div>

          <div class="flex flex-wrap items-center gap-6 border-t border-gray-800/60 pt-3 text-xs">
            <label class="flex items-center gap-2 cursor-pointer text-gray-300">
              <input v-model="config.onUserSubmitMail" type="checkbox"
                class="h-4 w-4 rounded border-gray-700 bg-gray-800 text-emerald-500 focus:ring-emerald-500" />
              <span>Send to Mail</span>
            </label>
            <label class="flex items-center gap-2 cursor-pointer text-gray-300">
              <input v-model="config.onUserSubmitAdminGroup" type="checkbox"
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
            <p class="text-xs text-gray-400 mt-0.5">
              Dispatches notification when a user creates or publishes a campaign.
            </p>
          </div>

          <div class="flex flex-wrap items-center gap-6 border-t border-gray-800/60 pt-3 text-xs">
            <label class="flex items-center gap-2 cursor-pointer text-gray-300">
              <input v-model="config.onPostPublishMail" type="checkbox"
                class="h-4 w-4 rounded border-gray-700 bg-gray-800 text-emerald-500 focus:ring-emerald-500" />
              <span>Send to Mail</span>
            </label>
            <label class="flex items-center gap-2 cursor-pointer text-gray-300">
              <input v-model="config.onPostPublishPublicChannel" type="checkbox"
                class="h-4 w-4 rounded border-gray-700 bg-gray-800 text-emerald-500 focus:ring-emerald-500" />
              <span>Send Public Campaigns to Telegram Channel (Option 1)</span>
            </label>
            <label class="flex items-center gap-2 cursor-pointer text-gray-300">
              <input v-model="config.onPostPublishAdminGroup" type="checkbox"
                class="h-4 w-4 rounded border-gray-700 bg-gray-800 text-indigo-500 focus:ring-indigo-500" />
              <span>Alert to Admin Telegram Group (Option 2)</span>
            </label>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
