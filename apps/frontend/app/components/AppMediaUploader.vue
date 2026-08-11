<script setup lang="ts">
import { ref } from 'vue'
import { useCloudinaryUpload, type CloudinaryUploadResponse } from '~/composables/useCloudinaryUpload'

const props = withDefaults(
  defineProps<{
    folder?: string
    accept?: 'image' | 'video' | 'any'
    label?: string
    hint?: string
    multiple?: boolean
    maxFiles?: number
  }>(),
  {
    folder: 'campaigns',
    accept: 'image',
    label: 'Upload Media',
    hint: 'Images (PNG, JPG, WEBP, GIF) up to 50MB',
    multiple: false,
    maxFiles: 5,
  }
)

const emit = defineEmits<{
  (e: 'uploaded', payload: CloudinaryUploadResponse): void
  (e: 'multiUploaded', payload: CloudinaryUploadResponse[]): void
  (e: 'error', message: string): void
}>()

const fileInputRef = ref<HTMLInputElement | null>(null)
const isDragging = ref(false)

const { uploadMedia, isUploading, uploadProgress, errorMessage, isAdmin } = useCloudinaryUpload()

function triggerSelect() {
  fileInputRef.value?.click()
}

async function handleFiles(files: FileList | null) {
  if (!files || files.length === 0) return

  const fileArray = Array.from(files).slice(0, props.multiple ? props.maxFiles : 1)
  const uploadedResults: CloudinaryUploadResponse[] = []

  for (const file of fileArray) {
    try {
      const result = await uploadMedia(file, props.folder)
      uploadedResults.push(result)
      if (!props.multiple) {
        emit('uploaded', result)
      }
    } catch (err: any) {
      emit('error', err.message || 'Upload failed')
      break
    }
  }

  if (uploadedResults.length > 0 && props.multiple) {
    emit('multiUploaded', uploadedResults)
  }

  if (fileInputRef.value) {
    fileInputRef.value.value = ''
  }
}

function onFileChange(e: Event) {
  const target = e.target as HTMLInputElement
  handleFiles(target.files)
}

function onDrop(e: DragEvent) {
  isDragging.value = false
  handleFiles(e.dataTransfer?.files || null)
}
</script>

<template>
  <div class="space-y-2">
    <!-- Dropzone Area -->
    <div class="relative border-2 border-dashed rounded-lg p-4 text-center cursor-pointer transition-all" :class="[
      isDragging
        ? 'border-primary-500 bg-primary-50/50 dark:bg-primary-950/20'
        : 'border-gray-300 dark:border-gray-700 hover:border-gray-400 dark:hover:border-gray-600 bg-gray-50/50 dark:bg-gray-900/50',
      isUploading ? 'opacity-60 pointer-events-none' : ''
    ]" @click="triggerSelect" @dragover.prevent="isDragging = true" @dragleave.prevent="isDragging = false"
      @drop.prevent="onDrop">
      <input ref="fileInputRef" type="file" class="hidden"
        :accept="accept === 'video' ? 'video/*' : accept === 'image' ? 'image/*' : 'image/*,video/*'"
        :multiple="multiple" @change="onFileChange" />

      <div class="flex flex-col items-center justify-center gap-2 py-2">
        <div
          class="w-10 h-10 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center text-gray-500 dark:text-gray-400">
          <UIcon :name="accept === 'video' ? 'i-heroicons-video-camera' : 'i-heroicons-cloud-arrow-up'"
            class="w-5 h-5" />
        </div>

        <div class="text-sm">
          <span class="font-medium text-gray-900 dark:text-gray-100">Click to upload</span>
          <span class="text-gray-500 dark:text-gray-400"> or drag and drop</span>
        </div>

        <p class="text-sm text-gray-400 dark:text-gray-500">
          {{ hint || (isAdmin ? 'Admin bypass enabled: Images & Videos up to 2GB' : 'Max 50MB file size per upload') }}
        </p>

        <!-- Progress indicator -->
        <div v-if="isUploading" class="w-full max-w-xs mt-2 space-y-1">
          <div class="flex justify-between text-xs text-gray-500 font-mono">
            <span>Uploading to Cloudinary...</span>
            <span>{{ uploadProgress }}%</span>
          </div>
          <UProgress :value="uploadProgress" size="xs" color="primary" />
        </div>
      </div>
    </div>

    <!-- Error message display -->
    <p v-if="errorMessage" class="text-sm text-red-500 flex items-center gap-1 font-medium">
      <UIcon name="i-heroicons-exclamation-circle" class="w-4 h-4 shrink-0" />
      <span>{{ errorMessage }}</span>
    </p>
  </div>
</template>
