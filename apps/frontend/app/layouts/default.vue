<script setup lang="ts">
const publicNavLinks = [
  { label: 'Home', to: '/' },
  { label: 'Explore', to: '/explore' },
  { label: 'Pricing', to: '/pricing' },
]
</script>

<template>
  <div class="min-h-screen flex flex-col bg-background text-foreground">
    <!-- Public Header -->
    <header
      class="sticky top-0 z-40 w-full border-b border-gray-200 dark:border-gray-800 bg-background/80 backdrop-blur">
      <div class="container mx-auto flex h-16 items-center justify-between px-4">
        <div class="flex items-center gap-6">
          <NuxtLink to="/" class="font-bold text-xl text-primary-600 dark:text-primary-400 flex items-center gap-2">
            <UIcon name="i-heroicons-globe-alt" class="w-6 h-6" />
            <span>AdsPlatform</span>
          </NuxtLink>
          <nav class="hidden md:flex gap-4">
            <NuxtLink v-for="link in publicNavLinks" :key="link.to" :to="link.to"
              class="text-sm font-medium text-gray-600 dark:text-gray-300 hover:text-primary-600 dark:hover:text-primary-400 transition-colors">
              {{ link.label }}
            </NuxtLink>
          </nav>
        </div>

        <div class="flex items-center gap-3">
          <UColorModeButton />
          <UButton to="/creator" color="neutral" variant="ghost">Creator Portal</UButton>
          <UButton to="/admin" color="primary" variant="solid">Admin Portal</UButton>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="flex-1 container mx-auto px-4 py-8">
      <slot />
    </main>

    <!-- Footer -->
    <footer class="border-t border-gray-200 dark:border-gray-800 py-6 bg-gray-50/50 dark:bg-gray-900/50">
      <div class="container mx-auto px-4 text-center text-sm text-gray-500 dark:text-gray-400">
        © {{ new Date().getFullYear() }} AdsPlatform. Public Portal Layout.
      </div>
    </footer>
  </div>
</template>
