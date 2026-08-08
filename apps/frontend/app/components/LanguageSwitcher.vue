<template>
  <label class="sr-only" for="article-language">Article language</label>
  <select id="article-language" v-model="locale" class="rounded-lg border border-gray-300 bg-white px-3 py-1.5 text-sm text-gray-800 shadow-sm dark:border-gray-700 dark:bg-gray-900 dark:text-gray-100">
    <option value="en">English</option>
    <option value="km">&#x1797;&#x17B6;&#x179F;&#x17B6;&#x1781;&#x17D2;&#x1798;&#x17C2;&#x179A;</option>
  </select>
</template>

<script setup lang="ts">
const locale = defineModel<string>({ default: 'en' })
</script>
