<script setup lang="ts">
import { watch } from 'vue'
import { useRoute } from '#app'

interface Props {
  title: string
  icon: string
  iconClass?: string
  role: 'admin' | 'creator' | 'public'
  side?: 'left' | 'right'
}

const open = defineModel<boolean>('open', { default: false })
withDefaults(defineProps<Props>(), {
  side: 'left'
})

// Automatically close the drawer on route change
const route = useRoute()
watch(() => route.fullPath, () => {
  open.value = false
})
</script>

<template>
  <USlideover v-model:open="open" :side="side" :ui="{ content: 'w-[70%]' }" class="z-50">
    <template #content>
      <div class="p-6 flex flex-col h-full bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100">
        <!-- Drawer Header -->
        <div class="flex items-center justify-between mb-8 shrink-0">
          <div class="flex items-center gap-2">
            <UIcon :name="icon" class="w-6 h-6" :class="iconClass" />
            <span class="font-bold text-lg">{{ title }}</span>
          </div>

          <UButton icon="i-heroicons-x-mark" color="neutral" variant="ghost" aria-label="Close menu"
            @click="open = false" />
        </div>

        <!-- Drawer Content -->
        <div class="flex-1 overflow-y-auto space-y-6 min-h-0">
          <!-- Public Welcome/CTA Block -->
          <div v-if="role === 'public'"
            class="bg-gray-50 dark:bg-gray-800/40 p-4 rounded-xl border border-gray-100 dark:border-gray-800/80 space-y-3">
            <div class="space-y-1">
              <h4 class="font-bold text-sm text-gray-900 dark:text-gray-100">Welcome to NewPlatform</h4>
              <p class="text-[11px] leading-relaxed text-gray-500 dark:text-gray-400">Launch premium advertising
                campaigns or monetize your channel traffic today.</p>
            </div>
            <UButton to="/register" size="sm" block color="primary" icon="i-heroicons-user-plus">
              Get Started
            </UButton>
          </div>
        </div>

        <!-- Drawer Footer -->
        <div class="pt-4 border-t border-gray-200 dark:border-gray-800 flex items-center justify-between shrink-0">
          <NuxtLink to="/"
            class="flex items-center gap-2 text-xs font-medium text-gray-500 hover:text-gray-700 dark:hover:text-gray-300 transition-colors py-2">
            <UIcon name="i-heroicons-arrow-right-start-on-rectangle" class="w-4 h-4" />
            <span>Exit Portal</span>
          </NuxtLink>
          <UColorModeButton />
        </div>
      </div>
    </template>
  </USlideover>
</template>
