<script setup lang="ts">
import { ref } from 'vue'
import { useAuthStore } from '~/stores/auth'

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

const loading = ref(false)
const success = ref(false)
const showToast = ref(false)
const focusedField = ref<string | null>(null)

const handleSubmit = () => {
  loading.value = true

  setTimeout(() => {
    loading.value = false
    success.value = true
    showToast.value = true

    authStore.handleLoginResponse({
      user: {
        id: 'usr_login_99',
        username: email.value.includes('@') ? (email.value.split('@')[0] || 'john_creator') : 'john_creator',
        name: email.value.includes('@') ? (email.value.split('@')[0] || 'John Creator') : 'John Creator',
        email: email.value || 'creator@newplatform.com',
        avatar: `https://api.dicebear.com/7.x/avataaars/svg?seed=${email.value || 'Creator'}`,
        role: 'creator',
        balance: 1450.75,
        status: 'active'
      },
      token: 'jwt_mock_token_login',
      expiresAt: new Date(Date.now() + 86400000).toISOString()
    })

    setTimeout(() => {
      showToast.value = false
      navigateTo('/')
    }, 1200)
  }, 1000)
}
</script>

<template>
  <div class="flex-grow flex flex-col md:flex-row min-h-screen h-screen overflow-hidden">
    <!-- Left Side: Brand Imagery & Testimonial -->
    <section class="hidden md:flex md:w-1/2 lg:w-3/5 relative overflow-hidden bg-slate-950 p-8 lg:p-12 flex-col justify-between h-full">
      <!-- Animated Background Glows -->
      <div class="absolute top-[-10%] right-[-10%] w-96 h-96 bg-blue-700 opacity-20 blur-[120px] rounded-full pointer-events-none" />
      <div class="absolute bottom-[-5%] left-[-5%] w-80 h-80 bg-teal-500 opacity-15 blur-[100px] rounded-full pointer-events-none" />

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
          <img
            class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
            alt="Real-time analytics and targeting visualization"
            src="https://lh3.googleusercontent.com/aida-public/AB6AXuClupUv4GIyzVG2hZnmF02LLfgGUBJS7uf0geW9dnb6xR_85uRKWI68_DYsNx7lB8bh5Yxl4-IiqV90t5EL9ly317b8yLv10SVhhfcJLwbBlkOqjt9vDS7OaHtjQV9Yc3G6hDxfZ8vAD7p5q-fCgCYYhbLZ-MPU-IuxniWXliaxeJTeg9EpsAiPzxmYpOY92HHSVSd0cVgZA6czmLClIEFTnyy290_aTPK7tJy-irw8SOZw9hx8XX1O"
          >
          <div class="absolute inset-0 bg-gradient-to-t from-slate-950/80 via-transparent to-transparent" />
        </div>

        <!-- Quote -->
        <div class="space-y-4">
          <p class="text-2xl text-slate-100 italic font-medium leading-tight">
            &ldquo;Managing multi-channel advertising campaigns has never been easier. The real-time insights are game-changing.&rdquo;
          </p>
          <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-full overflow-hidden border-2 border-blue-400">
              <img
                class="w-full h-full object-cover"
                alt="Marcus Vance"
                src="https://lh3.googleusercontent.com/aida-public/AB6AXuDo5jxlNDrb0fz7m2cDvDCMMfNHFLcernHtFn3kblYJEMeCBWIpMQu4sYcThVLbYyCQcb2kzqnj6pD210Ae82hDNgr2OnDtQStTCWGNCmsOqGOxiuGcd8fbD7bgKbw_CJfYVWnYPoyPJg7LNYMABKkQmd8-MLMALcBVsD7qxoM9vwjutaBSX9ywktahNefso_w2WWbaLIwajxIlCabUAUQqwWKSzXceFv9u0juw2FuUdiU3H_8PA3B8"
              >
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
            <button
              type="button"
              class="w-full py-3.5 px-6 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-slate-800 dark:text-slate-200 font-medium rounded-xl shadow-sm hover:bg-slate-100 dark:hover:bg-slate-700 transition-all duration-200 flex items-center justify-center gap-3 cursor-pointer"
            >
              <svg class="w-5 h-5" viewBox="0 0 24 24">
                <path
                  d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
                  fill="#4285F4"
                />
                <path
                  d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
                  fill="#34A853"
                />
                <path
                  d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
                  fill="#FBBC05"
                />
                <path
                  d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
                  fill="#EA4335"
                />
              </svg>
              Sign in with Google
            </button>

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
            <label
              class="block text-sm font-medium mb-1.5 ml-1 transition-colors duration-200"
              :class="[focusedField === 'email' ? 'text-blue-600 dark:text-blue-400' : 'text-slate-600 dark:text-slate-400']"
              for="email"
            >
              Email Address
            </label>
            <input
              id="email"
              v-model="email"
              name="email"
              type="email"
              placeholder="name@organization.com"
              required
              class="w-full px-4 py-3.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-slate-900 dark:text-white placeholder-slate-400 focus:ring-2 focus:ring-blue-600 focus:border-blue-600 outline-none transition-all shadow-sm"
              @focus="focusedField = 'email'"
              @blur="focusedField = null"
            >
          </div>

          <!-- Password -->
          <div class="relative">
            <div class="flex items-center justify-between mb-1.5 ml-1">
              <label
                class="block text-sm font-medium transition-colors duration-200"
                :class="[focusedField === 'password' ? 'text-blue-600 dark:text-blue-400' : 'text-slate-600 dark:text-slate-400']"
                for="password"
              >
                Password
              </label>
              <a href="#" class="text-xs text-blue-600 dark:text-blue-400 hover:underline">
                Forgot password?
              </a>
            </div>
            <div class="relative flex items-center">
              <input
                id="password"
                v-model="password"
                name="password"
                :type="showPassword ? 'text' : 'password'"
                placeholder="••••••••"
                required
                class="w-full px-4 py-3.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-slate-900 dark:text-white placeholder-slate-400 focus:ring-2 focus:ring-blue-600 focus:border-blue-600 outline-none transition-all shadow-sm pr-12"
                @focus="focusedField = 'password'"
                @blur="focusedField = null"
              >
              <button
                type="button"
                class="absolute right-4 text-slate-400 hover:text-slate-600 dark:hover:text-slate-300 cursor-pointer"
                @click="showPassword = !showPassword"
              >
                <UIcon :name="showPassword ? 'i-lucide-eye-off' : 'i-lucide-eye'" class="h-5 w-5" />
              </button>
            </div>
          </div>

          <!-- Remember me -->
          <div class="flex items-center justify-between pt-1">
            <label class="flex items-center gap-2 cursor-pointer text-sm text-slate-600 dark:text-slate-400">
              <input
                v-model="rememberMe"
                type="checkbox"
                class="w-4 h-4 rounded text-blue-600 focus:ring-blue-500 border-slate-300 dark:border-slate-700 dark:bg-slate-800"
              >
              Remember me for 30 days
            </label>
          </div>

          <!-- Submit Button -->
          <div class="pt-4">
            <button
              type="submit"
              :disabled="loading"
              class="w-full py-4 px-6 font-semibold rounded-xl shadow-lg transition-all duration-200 flex items-center justify-center gap-2 cursor-pointer text-white"
              :class="[
                success
                  ? 'bg-teal-600 hover:bg-teal-700'
                  : 'bg-blue-600 hover:bg-blue-700 hover:scale-[1.01] active:scale-95',
                loading ? 'opacity-70 cursor-not-allowed' : ''
              ]"
            >
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
            <NuxtLink
              class="font-semibold text-blue-600 dark:text-blue-400 ml-1 hover:underline"
              to="/register"
            >
              Create account
            </NuxtLink>
          </p>
        </div>
      </div>
    </section>

    <!-- Floating Success Toast -->
    <Transition name="fade">
      <div
        v-if="showToast"
        class="fixed top-10 right-10 p-6 bg-white dark:bg-slate-800 border-l-4 border-blue-600 rounded-xl shadow-2xl z-50 transition-all duration-500"
      >
        <div class="flex gap-4 items-start">
          <UIcon name="i-lucide-check-circle" class="text-blue-600 h-6 w-6 shrink-0 mt-0.5" />
          <div>
            <p class="font-semibold text-slate-900 dark:text-white">
              Authenticated
            </p>
            <p class="text-sm text-slate-600 dark:text-slate-300">
              Welcome back to New Platform.
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
