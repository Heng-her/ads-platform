<script setup lang="ts">
import { ref } from 'vue'

const publicNavLinks = [
  { label: 'Home', to: '/' },
  { label: 'Explore', to: '/explore' },
  { label: 'Pricing', to: '/pricing' }
]
const mobileMenuOpen = ref(false)
</script>

<template>
  <div class="min-h-screen flex flex-col bg-background text-foreground">
    <!-- Header -->
    <AppHeader>
      <template #left>
        <NuxtLink
          to="/"
          class="flex items-center gap-2 text-xl font-bold text-primary mr-6"
        >
          <UIcon
            name="i-heroicons-globe-alt"
            class="w-6 h-6"
          />
          <span>AdsPlatform</span>
        </NuxtLink>

        <!-- Desktop Navigation -->
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

    <!-- Mobile Menu Drawer -->
    <MobileDrawer
      v-model:open="mobileMenuOpen"
      side="right"
      title="AdsPlatform"
      icon="i-heroicons-globe-alt"
      :links="publicNavLinks"
      role="public"
    />

    <!-- Main -->
    <main class="flex-1 container mx-auto px-4 py-8">
      <slot />
    </main>

    <!-- Footer -->
    <footer
      class="border-t border-gray-200 dark:border-gray-800 py-6 bg-gray-50/50 dark:bg-gray-900/50"
    >
      <div class="container mx-auto px-4 text-center text-sm text-gray-500">
        © {{ new Date().getFullYear() }} AdsPlatform. Public Portal Layout.
      </div>
    </footer>
  </div>
</template>
