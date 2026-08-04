<script setup lang="ts">
import { ref, computed } from 'vue'
import { getArticleUrl, getSocialShareLinks } from '~/lib/utils'

const props = defineProps<{
  modelValue: boolean
  title?: string
  article?: any
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void
}>()

const copied = ref(false)

const articleTitle = computed(() => props.article?.title || props.title || 'Share Article')

const fullUrl = computed(() => {
  if (typeof window === 'undefined') return ''
  if (props.article) {
    return `${window.location.origin}${getArticleUrl(props.article)}`
  }
  return window.location.href
})

const sharePlatforms = computed(() => getSocialShareLinks(articleTitle.value, fullUrl.value))

const hasNativeShare = computed(() => typeof navigator !== 'undefined' && Boolean(navigator.share))

function closeModal() {
  emit('update:modelValue', false)
}

function copyLink() {
  if (!fullUrl.value) return
  navigator.clipboard.writeText(fullUrl.value).then(() => {
    copied.value = true
    setTimeout(() => {
      copied.value = false
    }, 2000)
  })
}

async function triggerNativeShare() {
  if (typeof navigator !== 'undefined' && navigator.share && fullUrl.value) {
    try {
      await navigator.share({
        title: articleTitle.value,
        text: props.article?.description || articleTitle.value,
        url: fullUrl.value
      })
      closeModal()
    } catch {
      // User cancelled
    }
  }
}
</script>

<template>
  <Teleport to="body">
    <div v-if="modelValue"
      class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-gray-950/70 backdrop-blur-sm transition-opacity animate-in fade-in duration-200">

      <!-- Backdrop click to close -->
      <div class="absolute inset-0" @click="closeModal" />

      <!-- Modal Card -->
      <div
        class="relative w-full max-w-md bg-white dark:bg-[#122131] border border-gray-200 dark:border-[#273647] rounded-3xl p-6 shadow-2xl space-y-5 z-10 text-gray-900 dark:text-white">

        <!-- Modal Header -->
        <div class="flex items-center justify-between pb-3 border-b border-gray-100 dark:border-[#273647]">
          <h3 class="font-extrabold text-base flex items-center gap-2">
            <UIcon name="i-heroicons-share" class="w-5 h-5 text-primary" />
            Share to Social Platforms
          </h3>
          <button @click="closeModal"
            class="p-1 rounded-xl text-gray-400 hover:text-gray-900 dark:hover:text-white hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors">
            <UIcon name="i-heroicons-x-mark" class="w-5 h-5" />
          </button>
        </div>

        <!-- Article Title Preview -->
        <div class="p-3 rounded-2xl bg-gray-50 dark:bg-[#0d1c2d] border border-gray-100 dark:border-[#273647]/60">
          <p class="text-xs font-semibold line-clamp-2 text-gray-700 dark:text-gray-300">
            {{ articleTitle }}
          </p>
        </div>

        <!-- Social Platforms Grid (Using Image Assets from /icon) -->
        <div>
          <span class="text-[11px] font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 mb-3 block">
            Select Platform
          </span>
          <div class="grid grid-cols-5 gap-3">
            <a v-for="platform in sharePlatforms" :key="platform.name" :href="platform.shareUrl" target="_blank"
              rel="noopener noreferrer"
              class="flex flex-col items-center gap-2 p-2 rounded-2xl transition-all duration-200 group hover:scale-105"
              :title="`Share on ${platform.name}`">
              <div
                class="w-12 h-12 rounded-2xl flex items-center justify-center bg-gray-100 dark:bg-[#0d1c2d] border border-gray-200 dark:border-[#273647] shadow-sm transition-all group-hover:shadow-md group-hover:border-primary/50 overflow-hidden p-2">
                <img :src="platform.iconImg" :alt="platform.name"
                  class="w-full h-full object-contain transition-transform group-hover:scale-110" />
              </div>
              <span
                class="text-[10px] font-bold text-gray-600 dark:text-gray-300 group-hover:text-gray-900 dark:group-hover:text-white">
                {{ platform.name.split(' ')[0] }}
              </span>
            </a>
          </div>
        </div>

        <!-- Native Share Button (Mobile/Supported devices) -->
        <button v-if="hasNativeShare" @click="triggerNativeShare"
          class="w-full py-2.5 px-4 rounded-xl text-xs font-bold text-gray-900 dark:text-white bg-gray-100 dark:bg-[#1c2b3c] hover:bg-gray-200 dark:hover:bg-gray-700/80 border border-gray-200 dark:border-[#273647] flex items-center justify-center gap-2 transition-all shadow-sm">
          <UIcon name="i-heroicons-device-phone-mobile" class="w-4 h-4 text-primary" />
          <span>Share via Device Apps (Telegram, etc.)</span>
        </button>

        <!-- Copy Link Section -->
        <div class="pt-2 border-t border-gray-100 dark:border-[#273647]">
          <span class="text-[11px] font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 mb-2 block">
            Direct Link
          </span>
          <div class="flex items-center gap-2">
            <input readonly :value="fullUrl"
              class="flex-1 bg-gray-50 dark:bg-[#0d1c2d] border border-gray-200 dark:border-[#273647] text-xs font-medium rounded-xl px-3 py-2 text-gray-700 dark:text-gray-300 focus:outline-none select-all" />
            <button @click="copyLink"
              class="px-4 py-2 rounded-xl text-xs font-bold transition-all shrink-0 flex items-center gap-1.5 shadow-sm"
              :class="copied
                ? 'bg-emerald-500 text-white'
                : 'bg-primary text-gray-950 hover:bg-primary-400'">
              <UIcon :name="copied ? 'i-heroicons-check' : 'i-heroicons-link'" class="w-4 h-4" />
              <span>{{ copied ? 'Copied!' : 'Copy' }}</span>
            </button>
          </div>
        </div>

      </div>
    </div>
  </Teleport>
</template>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
