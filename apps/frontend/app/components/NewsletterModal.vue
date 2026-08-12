<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useApi } from '~/composables/useApi'
import { useAppToast } from '~/composables/useAppToast'

const api = useApi()
const toast = useAppToast()

const isOpen = ref(false)
const email = ref('')
const isSubmitting = ref(false)
const isSuccess = ref(false)

onMounted(() => {
  if (import.meta.client) {
    const isAlreadySubscribed = localStorage.getItem('platform_subscribed') === 'true'
    const isDismissed = sessionStorage.getItem('newsletter_dismissed') === 'true'
    
    if (!isAlreadySubscribed && !isDismissed) {
      setTimeout(() => {
        isOpen.value = true
      }, 3500)
    }
  }
})

function closeModal() {
  isOpen.value = false
  if (import.meta.client) {
    sessionStorage.setItem('newsletter_dismissed', 'true')
  }
}

async function handleSubscribe() {
  if (!email.value || !email.value.includes('@')) {
    toast.error('Invalid Email', 'Please enter a valid email address.')
    return
  }

  isSubmitting.value = true
  try {
    const res = await api.action.$post({
      json: {
        action: 'subscribers/subscribe',
        data: {
          email: email.value.trim(),
          source: 'PUBLIC_MODAL'
        }
      }
    })
    const result: any = await res.json()
    if (res.ok && result.code === 1) {
      isSuccess.value = true
      toast.success('Subscribed Successfully!', result.msg)
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
</script>

<template>
  <Teleport to="body">
    <Transition
      enter-active-class="transition duration-300 ease-out"
      enter-from-class="opacity-0 translate-y-4 scale-95"
      enter-to-class="opacity-100 translate-y-0 scale-100"
      leave-active-class="transition duration-200 ease-in"
      leave-from-class="opacity-100 translate-y-0 scale-100"
      leave-to-class="opacity-0 translate-y-4 scale-95"
    >
      <div
        v-if="isOpen"
        class="fixed bottom-6 right-6 z-50 w-full max-w-md p-4 sm:p-6 rounded-2xl border border-gray-800 bg-gray-900/95 backdrop-blur-xl shadow-2xl text-gray-100"
      >
        <button
          class="absolute top-3.5 right-3.5 flex h-7 w-7 items-center justify-center rounded-full text-gray-400 hover:bg-gray-800 hover:text-white transition"
          @click="closeModal"
        >
          <UIcon name="i-heroicons-x-mark" class="h-5 w-5" />
        </button>

        <div v-if="!isSuccess" class="space-y-4">
          <div class="flex items-center gap-3">
            <div class="flex h-11 w-11 shrink-0 items-center justify-center rounded-xl bg-primary-500/10 text-primary-400">
              <UIcon name="i-heroicons-envelope-open" class="h-6 w-6" />
            </div>
            <div>
              <h3 class="text-base font-bold text-white">Subscribe to Campaign Updates</h3>
              <p class="text-xs text-gray-400">
                Get live notifications whenever new campaigns or creator posts are published.
              </p>
            </div>
          </div>

          <form class="space-y-3" @submit.prevent="handleSubscribe">
            <div class="relative">
              <UIcon name="i-heroicons-envelope" class="absolute left-3.5 top-3 h-4 w-4 text-gray-400" />
              <input
                v-model="email"
                type="email"
                required
                placeholder="Enter your email (e.g. name@domain.com)"
                class="w-full rounded-xl border border-gray-700 bg-gray-800/90 pl-10 pr-4 py-2.5 text-sm text-white placeholder-gray-400 focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20"
              />
            </div>

            <button
              type="submit"
              :disabled="isSubmitting"
              class="w-full flex items-center justify-center gap-2 rounded-xl bg-primary-600 px-4 py-2.5 text-sm font-semibold text-white shadow-lg shadow-primary-600/25 transition hover:bg-primary-500 disabled:opacity-50"
            >
              <UIcon v-if="isSubmitting" name="i-heroicons-arrow-path" class="h-4 w-4 animate-spin" />
              <UIcon v-else name="i-heroicons-paper-airplane" class="h-4 w-4" />
              <span>{{ isSubmitting ? 'Subscribing...' : 'Subscribe Now' }}</span>
            </button>
          </form>

          <p class="text-[11px] text-gray-500 text-center">
            No spam. You can unsubscribe anytime at a single click.
          </p>
        </div>

        <div v-else class="flex flex-col items-center justify-center py-4 space-y-2 text-center">
          <div class="flex h-12 w-12 items-center justify-center rounded-full bg-emerald-500/20 text-emerald-400">
            <UIcon name="i-heroicons-check" class="h-7 w-7" />
          </div>
          <h3 class="text-base font-bold text-white">You're Subscribed!</h3>
          <p class="text-xs text-gray-400">
            Thank you for subscribing. You'll be the first to receive new campaign updates!
          </p>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>
