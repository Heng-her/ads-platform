<script setup lang="ts">
import { ref, computed } from 'vue'
import { getArticleUrl, getSocialShareLinks } from '~/lib/utils'
import type { CampaignItem } from '~/types/campaign'

const props = defineProps<{
  modelValue: boolean
  title?: string
  article?: CampaignItem
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

      <section role="dialog" aria-modal="true" aria-labelledby="share-modal-title"
        class="relative z-10 w-full max-w-lg overflow-hidden rounded-[28px] border border-white/70 bg-white shadow-2xl dark:border-white/10 dark:bg-[#102131]">
        <div class="absolute inset-x-0 top-0 h-28 bg-gradient-to-br from-primary/25 via-primary/10 to-transparent" />

        <div class="relative p-5 sm:p-6">
          <div class="flex items-start justify-between gap-4">
            <div class="flex items-center gap-3">
              <div
                class="flex h-11 w-11 items-center justify-center rounded-2xl bg-primary text-gray-950 shadow-lg shadow-primary/20">
                <UIcon name="i-heroicons-share" class="h-5 w-5" />
              </div>
              <div>
                <p class="text-xs font-semibold uppercase tracking-[0.16em] text-primary">Send it onward</p>
                <h3 id="share-modal-title" class="mt-0.5 text-lg font-extrabold text-gray-950 dark:text-white">Share
                  this article</h3>
              </div>
            </div>
            <button @click="closeModal" aria-label="Close share dialog"
              class="rounded-xl p-2 text-gray-400 transition-colors hover:bg-gray-100 hover:text-gray-900 dark:hover:bg-white/10 dark:hover:text-white">
              <UIcon name="i-heroicons-x-mark" class="h-5 w-5" />
            </button>
          </div>

          <div class="mt-6 rounded-2xl border border-gray-200/80 bg-gray-50 p-4 dark:border-white/10 dark:bg-white/5">
            <div class="flex items-start gap-3">
              <div class="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-primary/15 text-primary">
                <UIcon name="i-heroicons-document-text" class="h-4 w-4" />
              </div>
              <div class="min-w-0">
                <p class="text-[10px] font-bold uppercase tracking-[0.14em] text-gray-400">You’re sharing</p>
                <p class="mt-1 line-clamp-2 text-sm font-bold leading-5 text-gray-800 dark:text-gray-100">{{
                  articleTitle }}</p>
              </div>
            </div>
          </div>

          <div class="mt-6">
            <p class="text-xs font-bold text-gray-700 dark:text-gray-200">Choose a platform</p>
            <div class="mt-3 grid grid-cols-5 gap-2 sm:gap-3">
              <a v-for="platform in sharePlatforms" :key="platform.name" :href="platform.shareUrl" target="_blank"
                rel="noopener noreferrer" :title="`Share on ${platform.name}`"
                class="group flex min-w-0 flex-col items-center gap-2 rounded-2xl px-1 py-2 text-center transition-all duration-200 hover:-translate-y-1 hover:bg-gray-50 dark:hover:bg-white/5">
                <span
                  class="flex h-12 w-12 items-center justify-center rounded-2xl border border-gray-200 bg-white p-2 shadow-sm transition-all group-hover:border-primary/40 group-hover:shadow-md dark:border-white/10 dark:bg-[#162a3d]">
                  <img :src="platform.iconImg" :alt="platform.name" class="h-full w-full object-contain" />
                </span>
                <span
                  class="truncate text-[10px] font-bold text-gray-500 group-hover:text-gray-950 dark:text-gray-400 dark:group-hover:text-white">{{
                    platform.name }}</span>
              </a>
            </div>
          </div>

          <button v-if="hasNativeShare" @click="triggerNativeShare"
            class="mt-5 flex w-full items-center justify-center gap-2 rounded-2xl border border-primary/25 bg-primary/10 px-4 py-3 text-sm font-bold text-primary transition-colors hover:bg-primary/15">
            <UIcon name="i-heroicons-arrow-up-tray" class="h-4 w-4" />
            Share with an app on this device
          </button>

          <div class="mt-5 border-t border-gray-100 pt-5 dark:border-white/10">
            <div class="mb-2 flex items-center justify-between">
              <label class="text-xs font-bold text-gray-700 dark:text-gray-200">Copy a link</label>
              <span v-if="copied" class="text-xs font-bold text-emerald-600 dark:text-emerald-400">Copied to
                clipboard</span>
            </div>
            <div
              class="flex rounded-2xl border border-gray-200 bg-gray-50 p-1.5 focus-within:border-primary/50 dark:border-white/10 dark:bg-white/5">
              <input readonly :value="fullUrl" aria-label="Article link"
                class="min-w-0 flex-1 bg-transparent px-2.5 text-xs font-medium text-gray-600 outline-none dark:text-gray-300" />
              <button @click="copyLink"
                class="inline-flex shrink-0 items-center gap-1.5 rounded-xl px-3 py-2 text-xs font-bold transition-all"
                :class="copied ? 'bg-emerald-500 text-white' : 'bg-primary text-gray-950 hover:bg-primary-400'">
                <UIcon :name="copied ? 'i-heroicons-check' : 'i-heroicons-clipboard-document'" class="h-4 w-4" />
                {{ copied ? 'Copied' : 'Copy link' }}
              </button>
            </div>
          </div>
        </div>
      </section>
    </div>
  </Teleport>
</template>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
