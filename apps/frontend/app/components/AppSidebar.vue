<script setup lang="ts">
import { useSidebar } from '~/composables/useSidebar'

interface NavLink {
  label: string
  icon: string
  to: string
}

interface Props {
  links: NavLink[]
  role: 'admin' | 'creator'
  title: string
  icon: string
  iconClass?: string
}

defineProps<Props>()
const { isCollapsed, toggleCollapse } = useSidebar()
</script>

<template>
  <aside
    class="hidden md:flex flex-col border-r border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 transition-all duration-300 ease-in-out shrink-0"
    :class="[isCollapsed ? 'w-18' : 'w-18 lg:w-64']"
  >
    <!-- Sidebar Header -->
    <div class="h-16 flex items-center px-4 border-b border-gray-200 dark:border-gray-800 shrink-0">
      <div
        class="flex items-center gap-3 overflow-hidden whitespace-nowrap w-full"
        :class="[isCollapsed ? 'justify-center' : 'justify-center lg:justify-start']"
      >
        <UIcon
          :name="icon"
          class="w-6 h-6 shrink-0"
          :class="iconClass"
        />
        <span
          class="font-bold text-lg tracking-wide transition-opacity duration-300"
          :class="[isCollapsed ? 'hidden' : 'hidden lg:inline']"
        >
          {{ title }}
        </span>
      </div>
    </div>

    <!-- Navigation Links -->
    <nav class="flex-1 p-3 space-y-1 overflow-y-auto">
      <UTooltip
        v-for="item in links"
        :key="item.to"
        :text="item.label"
        :disabled="!isCollapsed"
        side="right"
      >
        <!-- For screen sizes between md and lg, the tooltip should be enabled because labels are hidden -->
        <UTooltip
          :text="item.label"
          class="block w-full"
          :disabled="isCollapsed"
          side="right"
          :ui="{ content: 'lg:hidden' }"
        >
          <NuxtLink
            :to="item.to"
            class="flex items-center gap-3 px-3 py-2.5 text-sm font-medium rounded-lg transition-colors group relative"
            :class="[
              isCollapsed ? 'justify-center px-2' : 'justify-center lg:justify-start px-2 lg:px-3',
              role === 'admin'
                ? 'text-gray-600 dark:text-gray-300 hover:bg-red-500/10 hover:text-red-600 dark:hover:text-red-400'
                : 'text-gray-600 dark:text-gray-300 hover:bg-amber-500/10 hover:text-amber-600 dark:hover:text-amber-400'
            ]"
            :active-class="
              role === 'admin'
                ? 'bg-red-500/15 text-red-600 dark:text-red-400 font-semibold'
                : 'bg-amber-50 dark:bg-amber-950/60 text-amber-600 dark:text-amber-400 font-semibold'
            "
          >
            <UIcon
              :name="item.icon"
              class="w-5 h-5 shrink-0"
            />
            <span
              class="transition-opacity duration-300 whitespace-nowrap"
              :class="[isCollapsed ? 'hidden' : 'hidden lg:inline']"
            >
              {{ item.label }}
            </span>
          </NuxtLink>
        </UTooltip>
      </UTooltip>
    </nav>

    <!-- Bottom Actions -->
    <div class="p-3 border-t border-gray-200 dark:border-gray-800 space-y-2 shrink-0">
      <!-- Exit and Theme selection -->
      <div
        class="flex items-center justify-between"
        :class="[isCollapsed ? 'flex-col gap-2' : 'flex-col lg:flex-row gap-2 lg:gap-0']"
      >
        <UTooltip
          text="Exit Portal"
          :disabled="!isCollapsed"
          side="right"
        >
          <NuxtLink
            to="/"
            class="flex items-center gap-2 text-xs font-medium text-gray-500 hover:text-gray-700 dark:hover:text-gray-300 transition-colors p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800"
            :class="[isCollapsed ? 'justify-center' : 'justify-center lg:justify-start']"
          >
            <UIcon
              name="i-heroicons-arrow-right-start-on-rectangle"
              class="w-4 h-4"
            />
            <span :class="[isCollapsed ? 'hidden' : 'hidden lg:inline']">Exit Portal</span>
          </NuxtLink>
        </UTooltip>
        <UColorModeButton />
      </div>

      <!-- Collapse Toggle Button (Desktop only) -->
      <UButton
        color="neutral"
        variant="ghost"
        :icon="isCollapsed ? 'i-heroicons-chevron-right' : 'i-heroicons-chevron-left'"
        block
        class="hidden lg:flex mt-2"
        @click="toggleCollapse"
      >
        <span v-if="!isCollapsed">Collapse</span>
      </UButton>
    </div>
  </aside>
</template>
