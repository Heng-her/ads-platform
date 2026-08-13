<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'
import { useGoogleIdentity } from '~/composables/useGoogleIdentity'

const api = useApi()
const toast = useAppToast()
const { isConfigured: googleEnabled, promptOneTap } = useGoogleIdentity()

const isOpen = ref(false)
const email = ref('')
const isSubmitting = ref(false)
const isSuccess = ref(false)

function parseEmailFromIdToken(idToken: string): string | null {
  try {
    const base64Url = idToken.split('.')[1]
    if (!base64Url) return null
    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/')
    const jsonPayload = decodeURIComponent(
      atob(base64)
        .split('')
        .map((c) => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
        .join('')
    )
    const parsed = JSON.parse(jsonPayload)
    return parsed.email || null
  } catch {
    return null
  }
}

function closeModal() {
  isOpen.value = false
  if (import.meta.client) {
    sessionStorage.setItem('newsletter_dismissed', 'true')
  }
}

async function subscribeWithEmail(targetEmail: string) {
  if (!targetEmail || !targetEmail.includes('@')) {
    toast.error('Invalid Email', 'Please enter a valid email address.')
    return
  }

  isSubmitting.value = true
  try {
    const res = await api.action.$post({
      json: {
        action: 'subscribers/subscribe',
        data: {
          email: targetEmail.trim(),
          source: 'PUBLIC_MODAL'
        }
      }
    })
    const result: any = await res.json()
    if (res.ok && result.code === 1) {
      isSuccess.value = true
      toast.success('Subscribed Successfully!', result.msg || 'Thank you for subscribing to updates.')
      if (import.meta.client) {
        localStorage.setItem('platform_subscribed', 'true')
      }
      setTimeout(() => {
        isOpen.value = false
      }, 2500)
    } else {
      toast.error('Subscription Failed', result.msg || 'Could not subscribe.')
    }
  } catch (err: any) {
    toast.error('Error', err.message || 'An unexpected error occurred.')
  } finally {
    isSubmitting.value = false
  }
}

async function handleGoogleCredential(idToken: string) {
  const extractedEmail = parseEmailFromIdToken(idToken)
  if (extractedEmail) {
    email.value = extractedEmail
    isOpen.value = true
    await subscribeWithEmail(extractedEmail)
  }
}

onMounted(() => {
  if (import.meta.client) {
    const isAlreadySubscribed = localStorage.getItem('platform_subscribed') === 'true'
    const isDismissed = sessionStorage.getItem('newsletter_dismissed') === 'true'

    if (!isAlreadySubscribed && !isDismissed) {
      // 1. Prompt Google One Tap / Gmail popup for subscription
      void promptOneTap(handleGoogleCredential)

      // 2. Open original bottom-right popup after short delay
      setTimeout(() => {
        isOpen.value = true
      }, 3500)
    }
  }
})
</script>

<template>
  <Teleport to="body">
    <Transition enter-active-class="transition duration-300 ease-out"
      enter-from-class="opacity-0 translate-y-4 scale-95" enter-to-class="opacity-100 translate-y-0 scale-100"
      leave-active-class="transition duration-200 ease-in" leave-from-class="opacity-100 translate-y-0 scale-100"
      leave-to-class="opacity-0 translate-y-4 scale-95">
      <div v-if="isOpen"
        class="fixed bottom-4 left-4 right-4 sm:left-auto sm:right-6 sm:bottom-6 z-50 w-auto sm:w-full sm:max-w-md p-4 sm:p-6 rounded-2xl sm:rounded-3xl border border-emerald-500/30 bg-gradient-to-br from-gray-900/98 via-gray-900/95 to-slate-900/98 backdrop-blur-2xl shadow-2xl shadow-black/80 text-gray-100 overflow-hidden">
        <!-- Background Ambient Glow -->
        <div class="absolute -top-12 -left-12 w-40 h-40 bg-emerald-500/10 rounded-full blur-2xl pointer-events-none" />

        <!-- Close Button -->
        <button
          type="button"
          class="absolute top-3 right-3 sm:top-4 sm:right-4 z-30 flex h-8 w-8 items-center justify-center rounded-full bg-gray-800/90 text-gray-300 hover:bg-gray-700 hover:text-white transition cursor-pointer focus:outline-none focus:ring-2 focus:ring-emerald-500/30"
          aria-label="Close subscription modal"
          @click="closeModal"
        >
          <UIcon name="i-heroicons-x-mark" class="h-5 w-5" />
        </button>

        <div v-if="!isSuccess" class="space-y-4 relative z-10">
          <div class="flex items-start gap-3.5 pr-6">
            <div
              class="flex h-11 w-11 shrink-0 items-center justify-center rounded-2xl bg-emerald-500/15 border border-emerald-500/30 text-emerald-400 shadow-md shadow-emerald-500/10">
              <UIcon name="i-heroicons-envelope-open" class="h-6 w-6" />
            </div>
            <div class="space-y-0.5">
              <h3 class="text-sm sm:text-base font-bold text-white tracking-tight">
                Subscribe to Campaign Updates
              </h3>
              <p class="text-xs text-gray-300 leading-relaxed">
                Get live notifications whenever new campaigns or creator posts are published.
              </p>
            </div>
          </div>

          <form class="space-y-3 pt-1" @submit.prevent="subscribeWithEmail(email)">
            <div class="relative">
              <UIcon name="i-heroicons-envelope"
                class="absolute left-3.5 top-3.5 h-4 w-4 text-gray-400 pointer-events-none" />
              <input v-model="email" type="email" required placeholder="Enter your email address (e.g. name@gmail.com)"
                class="w-full rounded-xl border border-gray-700 bg-gray-800/90 pl-10 pr-4 py-2.5 text-sm text-white placeholder-gray-400 focus:border-emerald-500 focus:outline-none focus:ring-2 focus:ring-emerald-500/20 transition" />
            </div>

            <button type="submit" :disabled="isSubmitting"
              class="w-full flex items-center justify-center gap-2 rounded-xl bg-gradient-to-r from-emerald-500 to-teal-500 px-4 py-3 sm:py-2.5 text-sm font-bold text-white shadow-lg shadow-emerald-500/25 transition hover:scale-[1.01] active:scale-95 disabled:opacity-50 cursor-pointer">
              <UIcon v-if="isSubmitting" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
              <UIcon v-else name="i-heroicons-paper-airplane" class="h-4 w-4" />
              <span>{{ isSubmitting ? 'Subscribing...' : 'Subscribe Now' }}</span>
            </button>
          </form>
        </div>

        <div v-else class="flex flex-col items-center justify-center py-4 space-y-2 text-center relative z-10">
          <div
            class="flex h-12 w-12 items-center justify-center rounded-full bg-emerald-500/20 border border-emerald-500/30 text-emerald-400 shadow-lg shadow-emerald-500/10">
            <UIcon name="i-heroicons-check" class="h-7 w-7" />
          </div>
          <h3 class="text-base font-bold text-white">You're Subscribed!</h3>
          <p class="text-xs text-gray-300">
            Thank you for subscribing. You'll be the first to receive new campaign updates!
          </p>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>
