<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'
import { useGoogleIdentity } from '~/composables/useGoogleIdentity'
import { useAuthStore, type ApiResponseEnvelope, type AuthSessionPayload } from '~/stores/auth'

definePageMeta({
  layout: 'auth'
})

useSeoMeta({
  title: 'Register - New Platform',
  robots: 'noindex, nofollow'
})

const authStore = useAuthStore()
const api = useApi()

const fullName = ref('')
const email = ref('')
const portfolio = ref('')
const country = ref('')
const password = ref('')
const googleButton = ref<HTMLElement | null>(null)

const loading = ref(false)
const googleLoading = ref(false)
const success = ref(false)
const showToast = ref(false)
const focusedField = ref<string | null>(null)
const errorMessage = ref('')
const googleError = ref('')

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

async function handleGoogleCredential(idToken: string) {
  resetFeedback()
  googleLoading.value = true

  try {
    const response = await api.auth.google.$post({
      json: { idToken }
    })

    const body = await response.json() as ApiResponseEnvelope<AuthSessionPayload>
    if (!response.ok || body.code !== 1) {
      throw new Error(body.msg || 'Google sign-up failed.')
    }

    await finishLogin(body.data)
  } catch (error) {
    googleError.value = getErrorMessage(error, 'Google sign-up failed.')
  } finally {
    googleLoading.value = false
  }
}

onMounted(async () => {
  if (!googleEnabled.value || !googleButton.value) return

  try {
    await renderButton(googleButton.value, handleGoogleCredential, {
      text: 'signup_with'
    })
  } catch (error) {
    googleError.value = getErrorMessage(error, 'Failed to load Google sign-up.')
  }
})

onUnmounted(() => {
  cancelPrompt()
})

const handleSubmit = () => {
  loading.value = true

  setTimeout(() => {
    loading.value = false
    success.value = true
    showToast.value = true

    setTimeout(() => {
      showToast.value = false
    }, 4000)
  }, 1500)
}
</script>

<template>
  <div class="flex-grow flex flex-col md:flex-row min-h-screen md:h-screen overflow-hidden">
    <!-- Left Side: Brand Imagery & Testimonial -->
    <section
      class="hidden md:flex md:w-1/2 lg:w-3/5 relative overflow-hidden bg-slate-950 p-6 lg:p-10 flex-col justify-between h-full">
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

      <div class="relative z-10 max-w-xl my-auto py-4">
        <!-- High Quality AI Image -->
        <div class="relative rounded-2xl overflow-hidden shadow-2xl mb-4 border border-white/10 aspect-video group">
          <img class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
            alt="Neural network visualization representing synthetic intelligence"
            src="https://lh3.googleusercontent.com/aida-public/AB6AXuClupUv4GIyzVG2hZnmF02LLfgGUBJS7uf0geW9dnb6xR_85uRKWI68_DYsNx7lB8bh5Yxl4-IiqV90t5EL9ly317b8yLv10SVhhfcJLwbBlkOqjt9vDS7OaHtjQV9Yc3G6hDxfZ8vAD7p5q-fCgCYYhbLZ-MPU-IuxniWXliaxeJTeg9EpsAiPzxmYpOY92HHSVSd0cVgZA6czmLClIEFTnyy290_aTPK7tJy-irw8SOZw9hx8XX1O">
          <div class="absolute inset-0 bg-gradient-to-t from-slate-950/80 via-transparent to-transparent" />
        </div>

        <!-- Testimonial Section -->
        <div class="space-y-3">
          <p class="text-xl lg:text-2xl text-slate-100 italic font-medium leading-tight">
            &ldquo;Joining New Platform was the catalyst for our campaign growth. The community of advertisers and
            publishers here is unmatched in the digital space.&rdquo;
          </p>
          <div class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-full overflow-hidden border-2 border-blue-400">
              <img class="w-full h-full object-cover" alt="Dr. Elena Vance"
                src="https://lh3.googleusercontent.com/aida-public/AB6AXuDo5jxlNDrb0fz7m2cDvDCMMfNHFLcernHtFn3kblYJEMeCBWIpMQu4sYcThVLbYyCQcb2kzqnj6pD210Ae82hDNgr2OnDtQStTCWGNCmsOqGOxiuGcd8fbD7bgKbw_CJfYVWnYPoyPJg7LNYMABKkQmd8-MLMALcBVsD7qxoM9vwjutaBSX9ywktahNefso_w2WWbaLIwajxIlCabUAUQqwWKSzXceFv9u0juw2FuUdiU3H_8PA3B8">
            </div>
            <div>
              <p class="font-semibold text-white text-sm">
                Dr. Elena Vance
              </p>
              <p class="text-xs text-slate-400">
                Lead Advertising Strategist &amp; Publisher
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

    <!-- Right Side: Registration Form -->
    <section
      class="w-full md:w-1/2 lg:w-2/5 flex items-center justify-center p-6 md:p-8 lg:p-10 bg-slate-50 dark:bg-slate-900 h-full overflow-y-auto [scrollbar-width:none] [-ms-overflow-style:none] [&::-webkit-scrollbar]:hidden">
      <div class="w-full max-w-md my-auto py-4">
        <!-- Mobile Branding -->
        <div class="md:hidden flex items-center gap-2 mb-4">
          <UIcon name="i-lucide-sparkles" class="text-blue-600 h-6 w-6 fill-blue-600 shrink-0" />
          <h1 class="text-xl font-bold tracking-tighter text-slate-900 dark:text-white">
            NEW PLATFORM
          </h1>
        </div>

        <header class="mb-4">
          <h2 class="text-2xl lg:text-3xl font-bold text-slate-900 dark:text-white mb-1">
            Create your account
          </h2>
          <p class="text-xs lg:text-sm text-slate-600 dark:text-slate-400">
            Join the forefront of advertising and real-time analytics.
          </p>
        </header>

        <form class="space-y-3" @submit.prevent="handleSubmit">
          <!-- Google Sign In -->
          <div class="space-y-3 mb-3">
            <div v-if="googleEnabled"
              class="flex justify-center rounded-xl border border-slate-200 bg-white px-4 py-3 shadow-sm dark:border-slate-700 dark:bg-slate-800">
              <div ref="googleButton" class="min-h-[44px]" />
            </div>
            <div v-else
              class="rounded-xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-800 dark:border-amber-900/40 dark:bg-amber-950/30 dark:text-amber-200">
              Google sign-in is not configured. Set `NUXT_PUBLIC_GOOGLE_CLIENT_ID` for the frontend and `GOOGLE_CLIENT_ID` for the backend.
            </div>
            <p v-if="googleLoading" class="text-sm text-slate-500 dark:text-slate-400">
              Waiting for Google sign-in...
            </p>
            <p v-if="googleError" class="text-sm text-rose-600 dark:text-rose-400">
              {{ googleError }}
            </p>

            <div class="relative flex items-center">
              <div class="flex-grow border-t border-slate-200 dark:border-slate-800" />
              <span class="flex-shrink mx-4 text-slate-400 text-xs">
                or
              </span>
              <div class="flex-grow border-t border-slate-200 dark:border-slate-800" />
            </div>
          </div>


          <!-- Full Name -->
          <div class="relative">
            <label class="block text-xs font-medium mb-1 ml-1 transition-colors duration-200"
              :class="[focusedField === 'fullName' ? 'text-blue-600 dark:text-blue-400' : 'text-slate-600 dark:text-slate-400']"
              for="fullName">
              Full Name
            </label>
            <input id="fullName" v-model="fullName" name="fullName" type="text" placeholder="Enter your full name"
              required
              class="w-full px-3.5 py-2.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs lg:text-sm text-slate-900 dark:text-white placeholder-slate-400 focus:ring-2 focus:ring-blue-600 focus:border-blue-600 outline-none transition-all shadow-sm"
              @focus="focusedField = 'fullName'" @blur="focusedField = null">
          </div>

          <!-- Professional Email -->
          <div class="relative">
            <label class="block text-xs font-medium mb-1 ml-1 transition-colors duration-200"
              :class="[focusedField === 'email' ? 'text-blue-600 dark:text-blue-400' : 'text-slate-600 dark:text-slate-400']"
              for="email">
              Professional Email
            </label>
            <input id="email" v-model="email" name="email" type="email" placeholder="name@organization.com" required
              class="w-full px-3.5 py-2.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs lg:text-sm text-slate-900 dark:text-white placeholder-slate-400 focus:ring-2 focus:ring-blue-600 focus:border-blue-600 outline-none transition-all shadow-sm"
              @focus="focusedField = 'email'" @blur="focusedField = null">
          </div>

          <!-- Portfolio Link -->
          <div class="relative">
            <label class="block text-xs font-medium mb-1 ml-1 transition-colors duration-200"
              :class="[focusedField === 'portfolio' ? 'text-blue-600 dark:text-blue-400' : 'text-slate-600 dark:text-slate-400']"
              for="portfolio">
              Portfolio Link
            </label>
            <div class="relative flex items-center">
              <UIcon name="i-lucide-link" class="absolute left-3.5 text-slate-400 h-4 w-4 pointer-events-none" />
              <input id="portfolio" v-model="portfolio" name="portfolio" type="url" placeholder="https://yourwork.com"
                class="w-full pl-10 pr-3.5 py-2.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs lg:text-sm text-slate-900 dark:text-white placeholder-slate-400 focus:ring-2 focus:ring-blue-600 focus:border-blue-600 outline-none transition-all shadow-sm"
                @focus="focusedField = 'portfolio'" @blur="focusedField = null">
            </div>
          </div>

          <!-- Country Dropdown -->
          <div class="relative">
            <label class="block text-xs font-medium mb-1 ml-1 transition-colors duration-200"
              :class="[focusedField === 'country' ? 'text-blue-600 dark:text-blue-400' : 'text-slate-600 dark:text-slate-400']"
              for="country">
              Country
            </label>
            <div class="relative flex items-center">
              <select id="country" v-model="country" name="country" required
                class="w-full px-3.5 py-2.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs lg:text-sm text-slate-900 dark:text-white placeholder-slate-400 focus:ring-2 focus:ring-blue-600 focus:border-blue-600 outline-none transition-all shadow-sm appearance-none cursor-pointer"
                @focus="focusedField = 'country'" @blur="focusedField = null">
                <option value="" disabled>
                  Select your country
                </option>
                <option value="us">
                  United States
                </option>
                <option value="uk">
                  United Kingdom
                </option>
                <option value="ca">
                  Canada
                </option>
                <option value="au">
                  Australia
                </option>
                <option value="de">
                  Germany
                </option>
                <option value="fr">
                  France
                </option>
              </select>
              <UIcon name="i-lucide-chevron-down" class="absolute right-3.5 text-slate-400 h-4 w-4 pointer-events-none" />
            </div>
          </div>

          <!-- Submit Button -->
          <div class="pt-2">
            <button type="submit" :disabled="loading"
              class="w-full py-3 px-5 font-semibold text-sm rounded-xl shadow-lg transition-all duration-200 flex items-center justify-center gap-2 cursor-pointer text-white"
              :class="[
                success
                  ? 'bg-teal-600 hover:bg-teal-700'
                  : 'bg-blue-600 hover:bg-blue-700 hover:scale-[1.01] active:scale-95',
                loading ? 'opacity-70 cursor-not-allowed' : ''
              ]">
              <template v-if="loading">
                <UIcon name="i-lucide-refresh-cw" class="h-4 w-4 animate-spin" />
                Processing...
              </template>
              <template v-else-if="success">
                <UIcon name="i-lucide-check-circle" class="h-4 w-4" />
                Welcome Aboard!
              </template>
              <template v-else>
                Submit
                <UIcon name="i-lucide-arrow-right" class="h-4 w-4" />
              </template>
            </button>
          </div>

          <p class="text-center text-[11px] text-slate-500 dark:text-slate-400 pt-1">
            By signing up, you agree to our
            <a class="text-blue-600 dark:text-blue-400 hover:underline" href="#">
              Terms of Service
            </a>.
          </p>
        </form>

        <div class="mt-6 pt-4 border-t border-slate-200 dark:border-slate-800 text-center">
          <p class="text-xs text-slate-600 dark:text-slate-400">
            Already have a creator account?
            <NuxtLink class="font-semibold text-blue-600 dark:text-blue-400 ml-1 hover:underline" to="/login">
              Log in
            </NuxtLink>
          </p>
        </div>
      </div>
    </section>

    <!-- Floating Success Toast -->
    <Transition name="fade">
      <div v-if="showToast"
        class="fixed top-10 right-10 p-6 bg-white dark:bg-slate-800 border-l-4 border-blue-600 rounded-xl shadow-2xl z-50 transition-all duration-500">
        <div class="flex gap-4 items-start">
          <UIcon name="i-lucide-check-circle" class="text-blue-600 h-6 w-6 shrink-0 mt-0.5" />
          <div>
            <p class="font-semibold text-slate-900 dark:text-white">
              Application Received
            </p>
            <p class="text-sm text-slate-600 dark:text-slate-300">
              Check your email for the next steps.
            </p>
          </div>
        </div>
      </div>
    </Transition>
  </div>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>
