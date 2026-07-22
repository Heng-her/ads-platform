<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'

const publicNavLinks = [
  { label: 'Home', to: '/' },
  { label: 'News', to: '/news' },
  { label: 'Finance', to: '/finance' },
  { label: 'AI', to: '/ai' }
]

const mobileNavItems = [
  { label: 'Home', icon: 'i-heroicons-home', to: '/' },
  { label: 'News', icon: 'i-heroicons-newspaper', to: '/news' },
  { label: 'Finance', icon: 'i-heroicons-banknotes', to: '/finance' },
  { label: 'AI', icon: 'i-heroicons-sparkles', to: '/ai' }
]

const publicDrawerLinks = [
  { label: 'Explore Campaigns', icon: 'i-heroicons-magnifying-glass', to: '/' },
  { label: 'Pricing Calculator', icon: 'i-heroicons-calculator', to: '/' },
  { label: 'Documentation & API', icon: 'i-heroicons-document-text', to: '/' },
  { label: 'Help & FAQs', icon: 'i-heroicons-question-mark-circle', to: '/' },
  { label: 'Contact Sales', icon: 'i-heroicons-chat-bubble-left-right', to: '/' }
]

const mobileMenuOpen = ref(false)
const searchQuery = ref('')
const showMobileSearch = ref(false)
const isPopoverOpen = ref(false)

const searchItems = [
  { label: 'Home Page Dashboard', icon: 'i-heroicons-home', desc: 'Platform landing page and simulates auth.' },
  { label: 'News & Announcements', icon: 'i-heroicons-newspaper', desc: 'Latest ad updates, releases, and guides.' },
  { label: 'Finance & Payout History', icon: 'i-heroicons-banknotes', desc: 'View billing transaction stats and deposits.' },
  { label: 'AI Optimization Recommendations', icon: 'i-heroicons-sparkles', desc: 'Active targeting suggestions and bid optimization score.' },
  { label: 'Creator & Publisher Studio', icon: 'i-heroicons-squares-2x2', desc: 'Publisher workspace settings and analytics.' },
  { label: 'Admin Management Panel', icon: 'i-heroicons-shield-check', desc: 'System management control, users and roles.' }
]

const filteredResults = computed(() => {
  const query = searchQuery.value.toLowerCase().trim()
  if (!query) return []
  return searchItems.filter(item =>
    item.label.toLowerCase().includes(query) ||
    item.desc.toLowerCase().includes(query)
  )
})

const searchWrapper = ref<HTMLElement | null>(null)

const handleOutsideClick = (event: MouseEvent) => {
  if (searchWrapper.value && !searchWrapper.value.contains(event.target as Node)) {
    isPopoverOpen.value = false
  }
}

onMounted(() => {
  document.addEventListener('click', handleOutsideClick)
})

onUnmounted(() => {
  document.removeEventListener('click', handleOutsideClick)
})
</script>

<template>
  <div class="min-h-screen flex flex-col bg-background text-foreground relative">
    <!-- Header -->
    <AppHeader>
      <template #left>
        <NuxtLink
          to="/"
          class="flex items-center gap-2 text-xl font-bold text-primary"
        >
          <UIcon
            name="i-heroicons-globe-alt"
            class="w-6 h-6"
          />
          <span>AdsPlatform</span>
        </NuxtLink>
      </template>

      <!-- Desktop Navigation (Center) -->
      <template #center>
        <nav class="hidden md:flex items-center gap-6">
          <NuxtLink
            v-for="link in publicNavLinks"
            :key="link.to"
            :to="link.to"
            class="text-sm font-medium hover:text-primary transition-colors"
            active-class="text-primary font-semibold"
          >
            {{ link.label }}
          </NuxtLink>
        </nav>
      </template>

      <template #right>
        <!-- Desktop Actions -->
        <div class="hidden md:flex items-center gap-3">
          <!-- Desktop Search Wrapper -->
          <div ref="searchWrapper" class="relative hidden md:block">
            <UInput
              v-model="searchQuery"
              icon="i-heroicons-magnifying-glass"
              placeholder="Search platform..."
              class="w-64 lg:w-72 transition-all duration-300 focus-within:w-72 lg:focus-within:w-80"
              @focus="isPopoverOpen = true"
            />

            <!-- Suggestions Dropdown -->
            <div
              v-if="isPopoverOpen"
              class="absolute right-0 top-full mt-2 p-4 w-80 lg:w-96 space-y-4 bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-xl shadow-xl z-50"
            >
              <!-- If search is empty, show quick navigation suggestions -->
              <div
                v-if="searchQuery.trim().length === 0"
                class="space-y-3"
              >
                <span class="text-[10px] font-bold text-gray-400 dark:text-gray-500 uppercase tracking-wider">Try searching for...</span>
                <div class="flex flex-wrap gap-1.5">
                  <UButton
                    v-for="sug in ['AI', 'Finance', 'News', 'Creator', 'Admin']"
                    :key="sug"
                    size="xs"
                    color="neutral"
                    variant="subtle"
                    @click="searchQuery = sug"
                  >
                    {{ sug }}
                  </UButton>
                </div>
              </div>

              <!-- If search has input, show filtered matches -->
              <div
                v-else
                class="space-y-3"
              >
                <span class="text-[10px] font-bold text-gray-400 dark:text-gray-500 uppercase tracking-wider">Search Results</span>
                
                <div
                  v-if="filteredResults.length === 0"
                  class="text-xs text-gray-500 dark:text-gray-400"
                >
                  No matches found for "{{ searchQuery }}"
                </div>
                
                <div
                  v-else
                  class="space-y-1 max-h-60 overflow-y-auto"
                >
                  <div
                    v-for="res in filteredResults"
                    :key="res.label"
                    class="flex items-center gap-3 p-2 rounded-lg bg-gray-50/50 dark:bg-gray-800/40 border border-gray-100 dark:border-gray-800/50 text-sm font-medium"
                  >
                    <UIcon
                      :name="res.icon"
                      class="w-5 h-5 text-primary shrink-0"
                    />
                    <div class="flex-1 min-w-0">
                      <div class="text-gray-900 dark:text-gray-100 text-xs font-semibold truncate">{{ res.label }}</div>
                      <div class="text-[10px] text-gray-400 dark:text-gray-500 font-normal truncate mt-0.5">{{ res.desc }}</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <UColorModeButton />

          <UButton
            to="/creator"
            color="neutral"
            variant="ghost"
          >
            Creator Portal
          </UButton>

          <UButton
            to="/admin"
            color="primary"
          >
            Admin Portal
          </UButton>
        </div>

        <!-- Mobile Actions -->
        <div class="flex md:hidden items-center gap-2">
          <UButton
            icon="i-heroicons-magnifying-glass"
            color="neutral"
            variant="ghost"
            aria-label="Search"
            @click="showMobileSearch = true"
          />

          <UColorModeButton />

          <UButton
            icon="i-heroicons-bars-3"
            color="neutral"
            variant="ghost"
            aria-label="Open menu"
            @click="mobileMenuOpen = true"
          />
        </div>
      </template>
    </AppHeader>

    <!-- Mobile Search Overlay -->
    <div
      v-if="showMobileSearch"
      class="absolute inset-x-0 top-0 h-16 bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-800 flex items-center px-4 gap-2 z-50"
    >
      <UInput
        v-model="searchQuery"
        icon="i-heroicons-magnifying-glass"
        placeholder="Search..."
        class="flex-1 animate-[fade-in_150ms_ease-out]"
        autofocus
      />
      <UButton
        label="Cancel"
        color="neutral"
        variant="ghost"
        @click="showMobileSearch = false"
      />
    </div>

    <!-- Mobile Menu Drawer -->
    <MobileDrawer
      v-model:open="mobileMenuOpen"
      side="right"
      title="AdsPlatform"
      icon="i-heroicons-globe-alt"
      :links="publicDrawerLinks"
      role="public"
    />

    <!-- Main Content -->
    <main class="flex-1 container mx-auto px-4 py-8 pb-24 md:pb-8">
      <slot />
    </main>

    <!-- Desktop Footer -->
    <footer
      class="border-t border-gray-200 dark:border-gray-800 py-6 bg-gray-50/50 dark:bg-gray-900/50 hidden md:block"
    >
      <div class="container mx-auto px-4 text-center text-sm text-gray-500">
        © {{ new Date().getFullYear() }} AdsPlatform. Public Portal Layout.
      </div>
    </footer>

    <!-- Mobile Bottom Navigation Bar -->
    <nav
      class="fixed bottom-0 inset-x-0 h-16 bg-white/90 dark:bg-gray-900/90 backdrop-blur border-t border-gray-200 dark:border-gray-800 flex items-center justify-around z-40 md:hidden pb-safe shadow-lg"
    >
      <NuxtLink
        v-for="item in mobileNavItems"
        :key="item.to"
        :to="item.to"
        class="flex flex-col items-center justify-center flex-1 h-full text-gray-500 dark:text-gray-400 hover:text-primary transition-colors py-1"
        active-class="text-primary font-semibold"
      >
        <UIcon
          :name="item.icon"
          class="w-5 h-5 mb-0.5"
        />
        <span class="text-[10px] tracking-wide">{{ item.label }}</span>
      </NuxtLink>
    </nav>
  </div>
</template>
