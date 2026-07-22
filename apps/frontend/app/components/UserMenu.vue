<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  role: 'admin' | 'creator'
}

const props = defineProps<Props>()

const items = computed(() => {
  if (props.role === 'admin') {
    return [
      [
        {
          label: 'Switch to Creator',
          icon: 'i-heroicons-sparkles',
          to: '/creator'
        },
        {
          label: 'System Settings',
          icon: 'i-heroicons-cog-8-tooth',
          to: '/admin/settings'
        }
      ],
      [
        {
          label: 'Exit Admin',
          icon: 'i-heroicons-arrow-right-start-on-rectangle',
          to: '/'
        }
      ]
    ]
  } else {
    return [
      [
        {
          label: 'Switch to Admin',
          icon: 'i-heroicons-shield-check',
          to: '/admin'
        },
        {
          label: 'Studio Settings',
          icon: 'i-heroicons-cog-6-tooth',
          to: '/creator/settings'
        }
      ],
      [
        {
          label: 'Exit to Public',
          icon: 'i-heroicons-arrow-right-start-on-rectangle',
          to: '/'
        }
      ]
    ]
  }
})

const avatarAlt = computed(() => props.role === 'admin' ? 'Admin User' : 'Creator User')
</script>

<template>
  <UDropdownMenu
    :items="items"
    :content="{ align: 'end' }"
    :ui="{ content: 'min-w-[180px] z-50' }"
  >
    <button class="flex items-center gap-2 focus:outline-none rounded-full p-0.5 hover:ring-2 hover:ring-primary/50 dark:hover:ring-primary/30 transition-all shrink-0">
      <UAvatar
        :alt="avatarAlt"
        size="sm"
        class="font-semibold text-xs select-none cursor-pointer"
      />
    </button>
  </UDropdownMenu>
</template>
