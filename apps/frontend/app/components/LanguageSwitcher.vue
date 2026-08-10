<script setup lang="ts">
import { computed } from 'vue'

export interface LanguageItem {
  code: string
  label: string
  flag: string
}

const props = defineProps<{
  modelValue?: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const localeCookie = useCookie<string>('locale', { default: () => 'en' })

const currentLocale = computed({
  get() {
    return props.modelValue ?? localeCookie.value ?? 'en'
  },
  set(val: string) {
    localeCookie.value = val
    emit('update:modelValue', val)
  }
})

const languages: LanguageItem[] = [
  { code: 'en', label: 'English', flag: '🇬🇧' },
  { code: 'km', label: 'ភាសាខ្មែរ', flag: '🇰🇭' },
  { code: 'zh', label: '中文', flag: '🇨🇳' },
  { code: 'ja', label: '日本語', flag: '🇯🇵' },
  { code: 'fr', label: 'Français', flag: '🇫🇷' },
  { code: 'ko', label: '한국어', flag: '🇰🇷' },
  { code: 'th', label: 'ไทย', flag: '🇹🇭' },
  { code: 'vi', label: 'Tiếng Việt', flag: '🇻🇳' },
  { code: 'lo', label: 'ລາວ', flag: '🇱🇦' },
  { code: 'my', label: 'မြန်မာ', flag: '🇲🇲' },
  { code: 'id', label: 'Bahasa Indonesia', flag: '🇮🇩' },
  { code: 'ms', label: 'Bahasa Melayu', flag: '🇲🇾' },
  { code: 'hi', label: 'हिन्दी', flag: '🇮🇳' },
  { code: 'tl', label: 'Filipino', flag: '🇵🇭' }
]

const currentLang = computed<LanguageItem>(() => {
  return languages.find(l => l.code === currentLocale.value) ?? languages[0]!
})

const menuItems = computed(() => [
  languages.map(l => ({
    label: `${l.label} ${l.flag}`,
    icon: l.code === currentLocale.value ? 'i-heroicons-check' : undefined,
    onSelect: () => {
      currentLocale.value = l.code
    }
  }))
])
</script>

<template>
  <UDropdownMenu :items="menuItems" :content="{ align: 'end' }"
    :ui="{ content: 'max-h-64 overflow-y-auto z-50 min-w-[160px]' }">
    <button type="button" data-no-google-translate
      class="flex items-center gap-1.5 rounded-lg border border-gray-300 bg-white px-2 py-1.5 text-xs sm:text-sm font-medium text-gray-800 shadow-sm dark:border-gray-700 dark:bg-gray-900 dark:text-gray-100 hover:border-gray-400 dark:hover:border-gray-600 focus:outline-none transition-colors"
      :aria-label="`Current language: ${currentLang.label}`">
      <!-- Mobile View: Show ONLY Flag emoji -->
      <span class="sm:hidden text-base leading-none select-none">{{ currentLang.flag }}</span>

      <!-- Desktop View: Show Language Name + Flag emoji -->
      <span class="hidden sm:inline-flex items-center gap-1.5 select-none">
        <span>{{ currentLang.label }}</span>
        <span class="text-base leading-none">{{ currentLang.flag }}</span>
      </span>

      <UIcon name="i-heroicons-chevron-down" class="w-3.5 h-3.5 text-gray-400 shrink-0" />
    </button>
  </UDropdownMenu>
</template>
