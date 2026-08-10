<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'
import { useGoogleIdentity } from '~/composables/useGoogleIdentity'
import { useAuthStore, type ApiResponseEnvelope, type AuthSessionPayload } from '~/stores/auth'

definePageMeta({
  layout: 'auth'
})

useSeoMeta({
  title: 'Log In - New Platform',
  robots: 'noindex, nofollow'
})

const authStore = useAuthStore()

const email = ref('')
const password = ref('')
const rememberMe = ref(false)
const showPassword = ref(false)
const googleButton = ref<HTMLElement | null>(null)

const loading = ref(false)
const googleLoading = ref(false)
const success = ref(false)
const showToast = ref(false)
const focusedField = ref<string | null>(null)
const errorMessage = ref('')
const googleError = ref('')

const api = useApi()
const { isConfigured: googleEnabled, renderButton, cancelPrompt } = useGoogleIdentity()

function getErrorMessage(error: unknown, fallback: string) {
  return error instanceof Error ? error.message : fallback
}

function resetFeedback() {
  errorMessage.value = ''
  googleError.value = ''
  success.value = false
  showToast.value = false
}

async function finishLogin(data: AuthSessionPayload) {
  authStore.handleLoginResponse(data)
  success.value = true
  showToast.value = true

  await new Promise(resolve => setTimeout(resolve, 900))
  await navigateTo(authStore.getDashboardPath(authStore.user?.role))
}

const handleSubmit = async () => {
  resetFeedback()
  loading.value = true

  try {
    const response = await api.action.$post({
      json: {
        action: 'auth/login',
        data: {
          email: email.value.trim(),
          password: password.value
        }
      }
    })

    const body = await response.json() as ApiResponseEnvelope<AuthSessionPayload>
    if (!response.ok || body.code !== 1) {
      throw new Error(body.msg || 'Unable to sign in.')
    }

    await finishLogin(body.data)
  } catch (error) {
    errorMessage.value = getErrorMessage(error, 'Unable to sign in.')
  } finally {
    loading.value = false
  }
}

async function handleGoogleCredential(idToken: string) {
  resetFeedback()
  googleLoading.value = true

  try {
    const response = await api.action.$post({
      json: {
        action: 'auth/google',
        data: { idToken }
      }
    })

    const body = await response.json() as ApiResponseEnvelope<AuthSessionPayload>
    if (!response.ok || body.code !== 1) {
      throw new Error(body.msg || 'Google sign-in failed.')
    }

    await finishLogin(body.data)
  } catch (error) {
    googleError.value = getErrorMessage(error, 'Google sign-in failed.')
  } finally {
    googleLoading.value = false
  }
}

onMounted(async () => {
  if (!googleEnabled.value || !googleButton.value) return

  try {
    await renderButton(googleButton.value, handleGoogleCredential, {
      text: 'signin_with',
      width: 360
    })
  } catch (error) {
    googleError.value = getErrorMessage(error, 'Google sign-in is unavailable.')
  }
})

onUnmounted(() => {
  cancelPrompt()
})
</script>

<template>
  <div class="flex-grow flex flex-col md:flex-row min-h-screen h-screen overflow-hidden">
    <!-- Left Side: Brand Imagery & Testimonial -->
    <section
      class="hidden md:flex md:w-1/2 lg:w-3/5 relative overflow-hidden bg-slate-950 p-8 lg:p-12 flex-col justify-between h-full">
      <!-- Animated Background Glows -->
      <div
        class="absolute top-[-10%] right-[-10%] w-96 h-96 bg-blue-700 opacity-20 blur-[120px] rounded-full pointer-events-none" />
      <div
        class="absolute bottom-[-5%] left-[-5%] w-80 h-80 bg-teal-500 opacity-15 blur-[100px] rounded-full pointer-events-none" />

      <div class="relative z-10">
        <div class="flex items-center gap-3">
          <UIcon name="i-lucide-sparkles" class="text-blue-400 h-8 w-8 fill-blue-400 shrink-0" />
          <NuxtLink to="/" class="text-2xl font-bold tracking-wide text-white">
            NEW PLATFORM
          </NuxtLink>
        </div>
      </div>

      <div class="relative z-10 max-w-xl my-auto">
        <!-- High Quality Image -->
        <div class="relative rounded-2xl overflow-hidden shadow-2xl mb-6 border border-white/10 aspect-video group">
          <img class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
            alt="Real-time analytics and targeting visualization"
            src="https://lh3.googleusercontent.com/aida-public/AB6AXuClupUv4GIyzVG2hZnmF02LLfgGUBJS7uf0geW9dnb6xR_85uRKWI68_DYsNx7lB8bh5Yxl4-IiqV90t5EL9ly317b8yLv10SVhhfcJLwbBlkOqjt9vDS7OaHtjQV9Yc3G6hDxfZ8vAD7p5q-fCgCYYhbLZ-MPU-IuxniWXliaxeJTeg9EpsAiPzxmYpOY92HHSVSd0cVgZA6czmLClIEFTnyy290_aTPK7tJy-irw8SOZw9hx8XX1O">
          <div class="absolute inset-0 bg-gradient-to-t from-slate-950/80 via-transparent to-transparent" />
        </div>

        <!-- Quote -->
        <div class="space-y-4">
          <p class="text-2xl text-slate-100 italic font-medium leading-tight">
            &ldquo;Managing multi-channel advertising campaigns has never been easier. The real-time insights are
            game-changing.&rdquo;
          </p>
          <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-full overflow-hidden border-2 border-blue-400">
              <img class="w-full h-full object-cover" alt="Marcus Vance"
                src="https://lh3.googleusercontent.com/aida-public/AB6AXuDo5jxlNDrb0fz7m2cDvDCMMfNHFLcernHtFn3kblYJEMeCBWIpMQu4sYcThVLbYyCQcb2kzqnj6pD210Ae82hDNgr2OnDtQStTCWGNCmsOqGOxiuGcd8fbD7bgKbw_CJfYVWnYPoyPJg7LNYMABKkQmd8-MLMALcBVsD7qxoM9vwjutaBSX9ywktahNefso_w2WWbaLIwajxIlCabUAUQqwWKSzXceFv9u0juw2FuUdiU3H_8PA3B8">
            </div>
            <div>
              <p class="font-semibold text-white">
                Marcus Vance
              </p>
              <p class="text-sm text-slate-400">
                Head of Global Growth
              </p>
            </div>
          </div>
        </div>
      </div>

      <div class="relative z-10">
        <p class="text-xs text-slate-500">
          &copy; 2026 New Platform Network. All rights reserved.
        </p>
      </div>
    </section>

    <!-- Right Side: Login Form -->
    <section
      class="w-full md:w-1/2 lg:w-2/5 flex items-center justify-center p-6 md:p-8 lg:p-10 bg-slate-50 dark:bg-slate-900 h-full overflow-y-auto [scrollbar-width:none] [-ms-overflow-style:none] [&::-webkit-scrollbar]:hidden">
      <div class="w-full max-w-md my-auto py-4">
        <!-- Mobile Branding -->
        <div class="md:hidden flex items-center gap-2 mb-6">
          <UIcon name="i-lucide-sparkles" class="text-blue-600 h-6 w-6 fill-blue-600 shrink-0" />
          <h1 class="text-xl font-bold tracking-tighter text-slate-900 dark:text-white">
            NEW PLATFORM
          </h1>
        </div>

        <header class="mb-6">
          <h2 class="text-3xl font-bold text-slate-900 dark:text-white mb-2">
            Welcome back
          </h2>
          <p class="text-slate-600 dark:text-slate-400">
            Log in to manage your ad campaigns and analytics.
          </p>
        </header>

        <form class="space-y-4" @submit.prevent="handleSubmit">
          <!-- Google Sign In -->
          <div class="space-y-4 mb-4">
            <div v-if="googleEnabled" class="flex justify-center rounded-xl px-4 py-3">
              <div ref="googleButton" class="min-h-[44px]" />
            </div>
            <div v-else
              class="rounded-xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-800 dark:border-amber-900/40 dark:bg-amber-950/30 dark:text-amber-200">
              Google sign-in is not configured. Set `NUXT_PUBLIC_GOOGLE_CLIENT_ID` for the frontend and
              `GOOGLE_CLIENT_ID` for the backend.
            </div>
            <p v-if="googleLoading" class="text-sm text-slate-500 dark:text-slate-400">
              Waiting for Google sign-in...
            </p>
            <p v-if="googleError" class="text-sm text-rose-600 dark:text-rose-400">
              {{ googleError }}
            </p>

            <div class="relative flex items-center">
              <div class="flex-grow border-t border-slate-200 dark:border-slate-800" />
              <span class="flex-shrink mx-4 text-slate-400 text-sm">
                or
              </span>
              <div class="flex-grow border-t border-slate-200 dark:border-slate-800" />
            </div>
          </div>

          <!-- Email -->
          <div class="relative">
            <label class="block text-sm font-medium mb-1.5 ml-1 transition-colors duration-200"
              :class="[focusedField === 'email' ? 'text-blue-600 dark:text-blue-400' : 'text-slate-600 dark:text-slate-400']"
              for="email">
              Email Address
            </label>
            <input id="email" v-model="email" name="email" type="email" placeholder="name@organization.com" required
              class="w-full px-4 py-3.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-slate-900 dark:text-white placeholder-slate-400 focus:ring-2 focus:ring-blue-600 focus:border-blue-600 outline-none transition-all shadow-sm"
              @focus="focusedField = 'email'" @blur="focusedField = null">
          </div>

          <!-- Password -->
          <div class="relative">
            <div class="flex items-center justify-between mb-1.5 ml-1">
              <label class="block text-sm font-medium transition-colors duration-200"
                :class="[focusedField === 'password' ? 'text-blue-600 dark:text-blue-400' : 'text-slate-600 dark:text-slate-400']"
                for="password">
                Password
              </label>
              <a href="#" class="text-xs text-blue-600 dark:text-blue-400 hover:underline">
                Forgot password?
              </a>
            </div>
            <div class="relative flex items-center">
              <input id="password" v-model="password" name="password" :type="showPassword ? 'text' : 'password'"
                placeholder="••••••••" required
                class="w-full px-4 py-3.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-slate-900 dark:text-white placeholder-slate-400 focus:ring-2 focus:ring-blue-600 focus:border-blue-600 outline-none transition-all shadow-sm pr-12"
                @focus="focusedField = 'password'" @blur="focusedField = null">
              <button type="button"
                class="absolute right-4 text-slate-400 hover:text-slate-600 dark:hover:text-slate-300 cursor-pointer"
                @click="showPassword = !showPassword">
                <UIcon :name="showPassword ? 'i-lucide-eye-off' : 'i-lucide-eye'" class="h-5 w-5" />
              </button>
            </div>
          </div>

          <!-- Remember me -->
          <div class="flex items-center justify-between pt-1">
            <label class="flex items-center gap-2 cursor-pointer text-sm text-slate-600 dark:text-slate-400">
              <input v-model="rememberMe" type="checkbox"
                class="w-4 h-4 rounded text-blue-600 focus:ring-blue-500 border-slate-300 dark:border-slate-700 dark:bg-slate-800">
              Remember me for 30 days
            </label>
          </div>

          <p v-if="errorMessage"
            class="rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-700 dark:border-rose-900/40 dark:bg-rose-950/30 dark:text-rose-300">
            {{ errorMessage }}
          </p>

          <!-- Submit Button -->
          <div class="pt-4">
            <button type="submit" :disabled="loading"
              class="w-full py-4 px-6 font-semibold rounded-xl shadow-lg transition-all duration-200 flex items-center justify-center gap-2 cursor-pointer text-white"
              :class="[
                success
                  ? 'bg-teal-600 hover:bg-teal-700'
                  : 'bg-blue-600 hover:bg-blue-700 hover:scale-[1.01] active:scale-95',
                loading ? 'opacity-70 cursor-not-allowed' : ''
              ]">
              <template v-if="loading">
                <UIcon name="i-lucide-refresh-cw" class="h-5 w-5 animate-spin" />
                Signing in...
              </template>
              <template v-else-if="success">
                <UIcon name="i-lucide-check-circle" class="h-5 w-5" />
                Success! Redirecting...
              </template>
              <template v-else>
                Sign In
                <UIcon name="i-lucide-arrow-right" class="h-5 w-5" />
              </template>
            </button>
          </div>
        </form>

        <div class="mt-12 pt-8 border-t border-slate-200 dark:border-slate-800 text-center">
          <p class="text-sm text-slate-600 dark:text-slate-400">
            Don't have an account?
            <NuxtLink class="font-semibold text-blue-600 dark:text-blue-400 ml-1 hover:underline" to="/register">
              Create account
            </NuxtLink>
          </p>
        </div>
      </div>
    </section>

    <!-- Floating Success Toast -->
    <Transition name="fade">
      <div v-if="showToast"
        class="fixed top-6 right-6 z-50 flex items-center gap-3 px-4 py-2.5 bg-white/90 dark:bg-slate-900/90 backdrop-blur-md border border-slate-200/80 dark:border-slate-800/80 rounded-full shadow-lg shadow-slate-900/5 dark:shadow-black/20 ring-1 ring-black/5 dark:ring-white/10">
        <div
          class="flex items-center justify-center h-6 w-6 rounded-full bg-blue-600/10 dark:bg-blue-500/20 text-blue-600 dark:text-blue-400 shrink-0">
          <UIcon name="i-lucide-check" class="h-3.5 w-3.5 stroke-[2.5]" />
        </div>
        <div class="flex items-center gap-2 text-sm pr-1">
          <span class="font-semibold text-slate-900 dark:text-white">Authenticated</span>
          <span class="text-slate-300 dark:text-slate-600">•</span>
          <span class="text-xs text-slate-500 dark:text-slate-400">Welcome back to New Platform.</span>
        </div>
      </div>
    </Transition>
  </div>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(-12px) scale(0.95);
}
</style>
