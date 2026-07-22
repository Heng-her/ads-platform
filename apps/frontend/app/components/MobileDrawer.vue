<script setup lang="ts">
import { watch } from 'vue'
import { useRoute } from '#app'

interface NavLink {
  label: string
  icon?: string
  to: string
}

interface Props {
  title: string
  icon: string
  iconClass?: string
  links: NavLink[]
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
  <USlideover
    v-model:open="open"
    :side="side"
    :ui="{ content: 'w-[70%]' }"
    class="z-50"
  >
    <template #content>
      <div class="p-6 flex flex-col h-full bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100">
        <!-- Drawer Header -->
        <div class="flex items-center justify-between mb-8 shrink-0">
          <div class="flex items-center gap-2">
            <UIcon
              :name="icon"
              class="w-6 h-6"
              :class="iconClass"
            />
            <span class="font-bold text-lg">{{ title }}</span>
          </div>

          <UButton
            icon="i-heroicons-x-mark"
            color="neutral"
            variant="ghost"
            aria-label="Close menu"
            @click="open = false"
          />
        </div>

        <!-- Drawer Content -->
        <div class="flex-1 overflow-y-auto space-y-6 min-h-0">
          <!-- Navigation Links -->
          <nav class="flex flex-col gap-1">
            <NuxtLink
              v-for="link in links"
              :key="link.to"
              :to="link.to"
              class="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
              active-class="bg-gray-100 dark:bg-gray-800 text-primary font-semibold"
            >
              <UIcon
                v-if="link.icon"
                :name="link.icon"
                class="w-5 h-5 shrink-0"
              />
              <span>{{ link.label }}</span>
            </NuxtLink>
          </nav>

          <!-- Role specific actions / Public Portal Buttons -->
          <div
            v-if="role === 'public'"
            class="pt-6 border-t border-gray-200 dark:border-gray-800 flex flex-col gap-3"
          >
            <UButton
              to="/creator"
              block
              color="neutral"
              variant="soft"
            >
              Creator Portal
            </UButton>

            <UButton
              to="/admin"
              block
              color="primary"
            >
              Admin Portal
            </UButton>
          </div>
        </div>

        <!-- Drawer Footer -->
        <div class="pt-4 border-t border-gray-200 dark:border-gray-800 flex items-center justify-between shrink-0">
          <NuxtLink
            to="/"
            class="flex items-center gap-2 text-xs font-medium text-gray-500 hover:text-gray-700 dark:hover:text-gray-300 transition-colors py-2"
          >
            <UIcon
              name="i-heroicons-arrow-right-start-on-rectangle"
              class="w-4 h-4"
            />
            <span>Exit Portal</span>
          </NuxtLink>
          <UColorModeButton />
        </div>
      </div>
    </template>
  </USlideover>
</template>
