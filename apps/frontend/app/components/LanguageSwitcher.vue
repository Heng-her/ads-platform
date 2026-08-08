<template>
  <label class="sr-only" for="article-language">Article language</label>
  <select
    id="article-language"
    v-model="currentLocale"
    data-no-google-translate
    class="rounded-lg border border-gray-300 bg-white px-3 py-1.5 text-sm text-gray-800 shadow-sm dark:border-gray-700 dark:bg-gray-900 dark:text-gray-100 cursor-pointer hover:border-gray-400 focus:outline-none"
  >
    <option value="en">English 🇬🇧</option>
    <option value="km">ភាសាខ្មែរ 🇰🇭</option>
    <option value="zh">中文 🇨🇳</option>
    <option value="ja">日本語 🇯🇵</option>
    <option value="fr">Français 🇫🇷</option>
    <option value="ko">한국어 🇰🇷</option>
    <option value="th">ไทย 🇹🇭</option>
    <option value="vi">Tiếng Việt 🇻🇳</option>
    <option value="lo">ລາວ 🇱🇦</option>
    <option value="my">မြန်မာ 🇲🇲</option>
    <option value="id">Bahasa Indonesia 🇮🇩</option>
    <option value="ms">Bahasa Melayu 🇲🇾</option>
    <option value="hi">हिन्दी 🇮🇳</option>
    <option value="tl">Filipino 🇵🇭</option>
  </select>
</template>

<script setup lang="ts">
import { computed } from 'vue'

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
</script>

