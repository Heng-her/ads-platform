<script setup lang="ts">
import { computed, watch } from 'vue'
import { useRoute, navigateTo } from '#app'
import { useAuthStore } from '~/stores/auth'

export interface NavLink {
  label: string
  icon?: string
  to: string
}

interface Props {
  title?: string
  icon?: string
  iconClass?: string
  role?: 'admin' | 'creator' | 'public'
  side?: 'left' | 'right'
  links?: NavLink[]
}

const props = withDefaults(defineProps<Props>(), {
  side: 'left',
  links: () => []
})

const open = defineModel<boolean>('open', { default: false })
const authStore = useAuthStore()
const route = useRoute()

// Predefined role navs fallback
const adminNavLinks: NavLink[] = [
  { label: 'Overview', icon: 'i-heroicons-chart-pie', to: '/admin' },
  { label: 'Users & Roles', icon: 'i-heroicons-users', to: '/admin/users' },
  { label: 'Approvals', icon: 'i-heroicons-check-badge', to: '/admin/approvals' },
  { label: 'System Logs', icon: 'i-heroicons-document-text', to: '/admin/logs' },
  { label: 'Settings', icon: 'i-heroicons-adjustments-horizontal', to: '/admin/settings' }
]

const creatorNavLinks: NavLink[] = [
  { label: 'Dashboard', icon: 'i-heroicons-squares-2x2', to: '/creator' },
  { label: 'Campaigns', icon: 'i-heroicons-megaphone', to: '/creator/campaigns' },
  { label: 'Analytics', icon: 'i-heroicons-chart-bar', to: '/creator/analytics' },
  { label: 'Earnings', icon: 'i-heroicons-banknotes', to: '/creator/earnings' },
  { label: 'Settings', icon: 'i-heroicons-cog-6-tooth', to: '/creator/settings' }
]

// Determine target dashboard path based on role
const dashboardPath = computed(() => {
  if (!authStore.isAuthenticated) return '/'
  return authStore.getDashboardPath()
})

// Active portal view check
const isCurrentAdmin = computed(() => route.path.startsWith('/admin'))
const isCurrentCreator = computed(() => route.path.startsWith('/creator'))

// Compute final nav links to render
const displayLinks = computed(() => {
  if (authStore.isAuthenticated) {
    if (authStore.user?.role === 'admin' && isCurrentAdmin.value) {
      return adminNavLinks
    }
    return creatorNavLinks
  }
  if (props.links && props.links.length > 0) {
    return props.links
  }
  return []
})

// Header details
const displayTitle = computed(() => {
  if (authStore.isAuthenticated) {
    return authStore.user?.role === 'admin' && isCurrentAdmin.value ? 'Admin Control' : 'Creator Studio'
  }
  if (props.title) return props.title
  return 'NewPlatform'
})

const displayIcon = computed(() => {
  if (authStore.isAuthenticated) {
    return authStore.user?.role === 'admin' && isCurrentAdmin.value ? 'i-heroicons-shield-check' : 'i-heroicons-sparkles'
  }
  if (props.icon) return props.icon
  return 'i-heroicons-globe-alt'
})

const displayIconClass = computed(() => {
  if (authStore.isAuthenticated) {
    return authStore.user?.role === 'admin' && isCurrentAdmin.value ? 'text-red-500' : 'text-amber-500'
  }
  if (props.iconClass) return props.iconClass
  return 'text-primary'
})

function handleLogout() {
  authStore.logout()
  open.value = false
  navigateTo('/login')
}

function handleGoDashboard() {
  open.value = false
  navigateTo(dashboardPath.value)
}

// Automatically close the drawer on route change
watch(() => route.fullPath, () => {
  open.value = false
})
</script>

<template>
  <USlideover v-model:open="open" :side="side" :ui="{ content: 'w-[80%] max-w-xs' }" class="z-50">
    <template #content>
      <div class="p-5 flex flex-col h-full bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100">
        <!-- Drawer Header (Clickable to Dashboard) -->
        <div class="flex items-center justify-between mb-6 shrink-0 pb-4 border-b border-gray-100 dark:border-gray-800">
          <NuxtLink :to="dashboardPath" class="flex items-center gap-2 hover:opacity-85 transition-opacity"
            @click="open = false">
            <UIcon :name="displayIcon" class="w-6 h-6 shrink-0" :class="displayIconClass" />
            <span class="font-bold text-base truncate">{{ displayTitle }}</span>
          </NuxtLink>

          <UButton icon="i-heroicons-x-mark" color="neutral" variant="ghost" aria-label="Close menu"
            @click="open = false" />
        </div>

        <!-- Drawer Content Body -->
        <div class="flex-1 overflow-y-auto space-y-5 min-h-0 pr-1">
          <!-- Logged In Profile Card (Clickable to Dashboard) -->
          <div v-if="authStore.isAuthenticated && authStore.user"
            class="p-3.5 rounded-xl bg-gradient-to-r from-gray-50 to-gray-100/60 dark:from-gray-800/80 dark:to-gray-800/40 border border-gray-200/80 dark:border-gray-700/60 shadow-sm space-y-3 cursor-pointer hover:border-primary/50 transition-all"
            @click="handleGoDashboard">
            <div class="flex items-center gap-3">
              <UAvatar :src="authStore.user.avatar" :alt="authStore.user.name" size="md"
                class="ring-2 ring-primary/30" />
              <div class="flex-1 min-w-0">
                <div class="font-bold text-xs text-gray-900 dark:text-gray-100 truncate">
                  {{ authStore.user.name }}
                </div>
                <div class="text-[10px] text-gray-500 dark:text-gray-400 truncate">
                  {{ authStore.user.email }}
                </div>
              </div>
            </div>

            <div
              class="flex items-center justify-between pt-2 border-t border-gray-200/60 dark:border-gray-700/50 text-xs">
              <UBadge color="primary" variant="subtle" size="xs" class="capitalize font-bold text-[10px]">
                {{ authStore.user.role }}
              </UBadge>
              <div class="flex items-center gap-1 font-semibold text-emerald-600 dark:text-emerald-400 text-[11px]">
                <UIcon name="i-heroicons-banknotes" class="w-3.5 h-3.5" />
                <span>${{ authStore.user.balance?.toLocaleString('en-US', { minimumFractionDigits: 2 }) || '0.00'
                }}</span>
              </div>
            </div>
          </div>

          <!-- Admin Portal Switch UI (Only if user has Admin role) -->
          <div v-if="authStore.isAuthenticated && authStore.user?.role === 'admin'"
            class="p-2.5 rounded-xl bg-gray-100/70 dark:bg-gray-800/60 border border-gray-200/60 dark:border-gray-700/50 space-y-2">
            <div class="text-[10px] font-bold text-gray-400 dark:text-gray-500 uppercase tracking-wider px-1">
              Switch Workspace
            </div>
            <div class="grid grid-cols-2 gap-1.5">
              <NuxtLink to="/admin"
                class="flex items-center justify-center gap-1.5 py-1.5 px-2 rounded-lg text-xs font-semibold transition-all"
                :class="isCurrentAdmin
                  ? 'bg-red-500 text-white shadow-sm'
                  : 'bg-white dark:bg-gray-900 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800'"
                @click="open = false">
                <UIcon name="i-heroicons-shield-check" class="w-3.5 h-3.5" />
                <span>Admin</span>
              </NuxtLink>

              <NuxtLink to="/creator"
                class="flex items-center justify-center gap-1.5 py-1.5 px-2 rounded-lg text-xs font-semibold transition-all"
                :class="isCurrentCreator
                  ? 'bg-amber-500 text-white shadow-sm'
                  : 'bg-white dark:bg-gray-900 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800'"
                @click="open = false">
                <UIcon name="i-heroicons-sparkles" class="w-3.5 h-3.5" />
                <span>Creator</span>
              </NuxtLink>
            </div>
          </div>

          <!-- Public Guest CTA Block (Only if not logged in) -->
          <div v-if="!authStore.isAuthenticated"
            class="bg-gray-50 dark:bg-gray-800/40 p-4 rounded-xl border border-gray-100 dark:border-gray-800/80 space-y-3">
            <div class="space-y-1">
              <h4 class="font-bold text-sm text-gray-900 dark:text-gray-100">Welcome to NewPlatform</h4>
              <p class="text-[11px] leading-relaxed text-gray-500 dark:text-gray-400">
                Launch premium advertising campaigns or monetize your channel traffic today.
              </p>
            </div>
            <div class="flex gap-2 pt-1">
              <UButton to="/login" size="sm" color="neutral" variant="soft" class="flex-1">
                Login
              </UButton>
              <UButton to="/register" size="sm" color="primary" class="flex-1">
                Register
              </UButton>
            </div>
          </div>

          <!-- Navigation Links -->
          <nav v-if="displayLinks && displayLinks.length" class="flex flex-col gap-1">
            <NuxtLink v-for="link in displayLinks" :key="link.to" :to="link.to"
              class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors text-gray-700 dark:text-gray-200"
              active-class="bg-gray-100 dark:bg-gray-800 text-primary dark:text-primary font-bold"
              @click="open = false">
              <UIcon v-if="link.icon" :name="link.icon" class="w-5 h-5 shrink-0 text-primary" />
              <span>{{ link.label }}</span>
            </NuxtLink>
          </nav>
        </div>

        <!-- Drawer Footer -->
        <div class="pt-4 border-t border-gray-200 dark:border-gray-800 flex items-center justify-between shrink-0">
          <button v-if="authStore.isAuthenticated"
            class="flex items-center gap-2 text-xs font-semibold text-red-500 hover:text-red-600 transition-colors py-2"
            @click="handleLogout">
            <UIcon name="i-heroicons-arrow-right-start-on-rectangle" class="w-4 h-4" />
            <span>Logout</span>
          </button>
          <NuxtLink v-else to="/"
            class="flex items-center gap-2 text-xs font-medium text-gray-500 hover:text-gray-700 dark:hover:text-gray-300 transition-colors py-2"
            @click="open = false">
            <UIcon name="i-heroicons-home" class="w-4 h-4" />
            <span>Home</span>
          </NuxtLink>

          <div class="flex items-center gap-2">
            <LanguageSwitcher />
            <UColorModeButton />
          </div>
        </div>
      </div>
    </template>
  </USlideover>
</template>
