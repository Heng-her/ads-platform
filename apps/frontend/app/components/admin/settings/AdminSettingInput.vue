<script setup lang="ts">
import { ref, computed } from 'vue'

const props = withDefaults(defineProps<{
  label?: string
  modelValue?: string | number | null
  type?: 'text' | 'password' | 'number' | 'email' | 'url' | 'textarea'
  placeholder?: string
  hint?: string
  icon?: string
  prefix?: string
  suffix?: string
  rows?: number
  disabled?: boolean
  required?: boolean
  error?: string
}>(), {
  type: 'text',
  rows: 3
})

const emit = defineEmits<{
  (e: 'update:modelValue', val: string | number): void
}>()

const showPassword = ref(false)

const currentType = computed(() => {
  if (props.type === 'password') {
    return showPassword.value ? 'text' : 'password'
  }
  return props.type
})

function handleInput(event: Event) {
  const target = event.target as HTMLInputElement | HTMLTextAreaElement
  if (props.type === 'number') {
    const num = parseFloat(target.value)
    emit('update:modelValue', isNaN(num) ? 0 : num)
  } else {
    emit('update:modelValue', target.value)
  }
}
</script>

<template>
  <div class="space-y-1.5">
    <div v-if="label" class="flex items-center justify-between">
      <label class="block text-xs font-semibold text-gray-300">
        {{ label }}
        <span v-if="required" class="text-red-400 ml-0.5">*</span>
      </label>
      <slot name="label-right" />
    </div>

    <div class="relative flex items-center">
      <!-- Icon / Prefix -->
      <div v-if="icon || prefix" class="absolute left-3.5 flex items-center text-gray-400 pointer-events-none text-xs font-mono">
        <UIcon v-if="icon" :name="icon" class="w-4 h-4 shrink-0 text-gray-400" />
        <span v-else-if="prefix">{{ prefix }}</span>
      </div>

      <!-- Textarea -->
      <textarea
        v-if="type === 'textarea'"
        :value="modelValue ?? ''"
        :placeholder="placeholder"
        :rows="rows"
        :disabled="disabled"
        class="w-full rounded-xl border border-gray-800 bg-gray-950 px-3.5 py-2.5 text-xs text-white placeholder-gray-500 focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20 transition-all font-sans disabled:opacity-50"
        :class="{ 'pl-9': icon || prefix, 'border-red-500/50': error }"
        @input="handleInput"
      />

      <!-- Standard Input -->
      <input
        v-else
        :value="modelValue ?? ''"
        :type="currentType"
        :placeholder="placeholder"
        :disabled="disabled"
        class="w-full rounded-xl border border-gray-800 bg-gray-950 py-2.5 px-3.5 text-xs text-white placeholder-gray-500 focus:border-primary-500 focus:outline-none focus:ring-2 focus:ring-primary-500/20 transition-all font-sans disabled:opacity-50"
        :class="{
          'pl-9': icon || prefix,
          'pr-9': type === 'password' || suffix,
          'border-red-500/50': error
        }"
        @input="handleInput"
      />

      <!-- Password Eye Toggle -->
      <button
        v-if="type === 'password'"
        type="button"
        class="absolute right-3 text-gray-400 hover:text-white transition-colors p-1"
        @click="showPassword = !showPassword"
      >
        <UIcon :name="showPassword ? 'i-heroicons-eye-slash' : 'i-heroicons-eye'" class="h-4 w-4" />
      </button>

      <!-- Suffix -->
      <span v-else-if="suffix" class="absolute right-3.5 text-xs text-gray-400 pointer-events-none font-mono">
        {{ suffix }}
      </span>
    </div>

    <!-- Error or Hint Message -->
    <p v-if="error" class="text-[11px] text-red-400 font-medium">
      {{ error }}
    </p>
    <p v-else-if="hint" class="text-[11px] text-gray-400 leading-normal">
      {{ hint }}
    </p>
  </div>
</template>
