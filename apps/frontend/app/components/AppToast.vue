<script setup lang="ts">
import { useAppToast } from '~/composables/useAppToast'

const { toasts, remove } = useAppToast()
</script>

<template>
  <ClientOnly>
    <div
      class="fixed bottom-5 right-5 z-[99999] flex flex-col gap-2 max-w-sm w-full pointer-events-none px-4 sm:px-0"
    >
      <TransitionGroup name="toast">
        <div
          v-for="t in toasts"
          :key="t.id"
          :class="[
            'pointer-events-auto flex items-center justify-between gap-3 rounded-full border px-4 py-2.5 text-xs sm:text-sm font-medium shadow-xl backdrop-blur-md transition-all duration-300',
            t.type === 'success'
              ? 'border-emerald-500/40 bg-emerald-950/90 text-emerald-100 shadow-emerald-950/30'
              : t.type === 'error'
              ? 'border-rose-500/40 bg-rose-950/90 text-rose-100 shadow-rose-950/30'
              : t.type === 'warning'
              ? 'border-amber-500/40 bg-amber-950/90 text-amber-100 shadow-amber-950/30'
              : 'border-blue-500/40 bg-gray-900/90 text-gray-100 shadow-black/30'
          ]"
        >
          <div class="flex items-center gap-2.5 min-w-0">
            <UIcon
              :name="
                t.type === 'success'
                  ? 'i-heroicons-check-circle'
                  : t.type === 'error'
                  ? 'i-heroicons-x-circle'
                  : t.type === 'warning'
                  ? 'i-heroicons-exclamation-triangle'
                  : 'i-heroicons-information-circle'
              "
              :class="[
                'h-4 w-4 shrink-0',
                t.type === 'success'
                  ? 'text-emerald-400'
                  : t.type === 'error'
                  ? 'text-rose-400'
                  : t.type === 'warning'
                  ? 'text-amber-400'
                  : 'text-blue-400'
              ]"
            />
            <div class="truncate">
              <span class="font-semibold">{{ t.title }}</span>
              <span v-if="t.description" class="ml-1 opacity-80 font-normal">
                - {{ t.description }}
              </span>
            </div>
          </div>

          <button
            class="shrink-0 rounded-full p-0.5 opacity-70 hover:opacity-100 transition"
            aria-label="Dismiss toast"
            @click="remove(t.id)"
          >
            <UIcon name="i-heroicons-x-mark" class="h-3.5 w-3.5" />
          </button>
        </div>
      </TransitionGroup>
    </div>
  </ClientOnly>
</template>

<style scoped>
.toast-enter-active,
.toast-leave-active {
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}
.toast-enter-from {
  opacity: 0;
  transform: translateY(12px) scale(0.95);
}
.toast-leave-to {
  opacity: 0;
  transform: translateY(-8px) scale(0.95);
}
</style>
