<script setup lang="ts">
import { ref, computed, nextTick, onBeforeUnmount, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useCampaigns, type CampaignImageItem, type CampaignData } from '~/composables/useCampaigns'
import { useCategories } from '~/composables/useCategories'
import { useCloudinaryUpload, type CloudinaryUploadResponse } from '~/composables/useCloudinaryUpload'
import { useCampaignDraft, type CampaignDraftForm } from '~/composables/useCampaignDraft'
import { useAuthStore } from '~/stores/auth'

const props = withDefaults(
  defineProps<{
    isEdit?: boolean
    campaignId?: string
  }>(),
  {
    isEdit: false,
    campaignId: undefined,
  }
)

const router = useRouter()
const { getCampaign, createCampaign, updateCampaign, isLoading } = useCampaigns()
const { categories, fetchCategories } = useCategories()
const { deleteMediaByUrl } = useCloudinaryUpload()
const authStore = useAuthStore()
const { getDraft, saveDraft, removeDraft } = useCampaignDraft()

const isFetching = ref(props.isEdit && !!props.campaignId)
const submitError = ref<string | null>(null)
const videoInputTemp = ref('')
const deletingMediaUrl = ref<string | null>(null)
const isRestoringDraft = ref(false)
const draftStatus = ref<'idle' | 'saving' | 'saved' | 'error'>('idle')
const hasSubmitted = ref(false)
const imagePreviewOpen = ref(false)
const imagePreviewUrl = ref('')
const imagePreviewTitle = ref('Image preview')
let draftSaveTimer: ReturnType<typeof setTimeout> | undefined

const form = ref({
  title: '',
  description: '',
  category: 'GENERAL',
  contentType: 'ARTICLE',
  content: '',
  imageUrl: '',
  imageTitle: '',
  imageDescription: '',
  images: [] as CampaignImageItem[],
  videoUrls: [] as string[],
  adNetwork: '',
  adUnitCode: '',
  status: 'PUBLIC' as 'DRAFT' | 'PUBLIC',
})

const draftKey = computed(() => {
  const ownerId = authStore.user?.id || 'anonymous'
  const target = props.isEdit && props.campaignId ? `edit:${props.campaignId}` : 'create'
  return `creator:${ownerId}:${target}`
})

function getDraftForm() {
  return JSON.parse(JSON.stringify(form.value)) as CampaignDraftForm
}

async function persistDraft() {
  if (!import.meta.client || isRestoringDraft.value || hasSubmitted.value) return

  draftStatus.value = 'saving'
  const saved = await saveDraft(draftKey.value, getDraftForm())
  draftStatus.value = saved ? 'saved' : 'error'
}

function scheduleDraftSave() {
  if (!import.meta.client || isRestoringDraft.value) return

  if (draftSaveTimer) clearTimeout(draftSaveTimer)
  draftSaveTimer = setTimeout(() => {
    draftSaveTimer = undefined
    void persistDraft()
  }, 500)
}

function applyDraft(draft: CampaignDraftForm) {
  form.value = {
    title: draft.title || '',
    description: draft.description || '',
    category: draft.category || 'GENERAL',
    contentType: draft.contentType || 'ARTICLE',
    content: draft.content || '',
    imageUrl: draft.imageUrl || '',
    imageTitle: draft.imageTitle || '',
    imageDescription: draft.imageDescription || '',
    images: Array.isArray(draft.images) ? draft.images : [],
    videoUrls: Array.isArray(draft.videoUrls) ? draft.videoUrls : [],
    adNetwork: draft.adNetwork || '',
    adUnitCode: draft.adUnitCode || '',
    status: draft.status === 'DRAFT' ? 'DRAFT' : 'PUBLIC',
  }
}

function openImagePreview(url: string, title = 'Image preview') {
  if (!url) return
  imagePreviewUrl.value = url
  imagePreviewTitle.value = title || 'Image preview'
  imagePreviewOpen.value = true
}

async function loadData() {
  if (props.isEdit && props.campaignId) {
    isFetching.value = true
    try {
      const data: CampaignData = await getCampaign(props.campaignId)
      if (data) {
        form.value.title = data.title || ''
        form.value.description = data.description || ''
        form.value.category = data.category || 'GENERAL'
        form.value.contentType = data.contentType || 'ARTICLE'
        form.value.content = data.content || ''
        form.value.imageUrl = data.imageUrl || ''
        form.value.imageTitle = data.imageTitle || ''
        form.value.imageDescription = data.imageDescription || ''
        form.value.images = data.images || []
        form.value.videoUrls = data.videoUrls || []
        form.value.adNetwork = data.adNetwork || ''
        form.value.adUnitCode = data.adUnitCode || ''
        form.value.status = data.status || 'PUBLIC'
      }
    } catch (err: any) {
      submitError.value = err.message || 'Failed to load campaign details'
    } finally {
      isFetching.value = false
    }
  }
}

async function initialiseForm() {
  isRestoringDraft.value = true
  authStore.initAuth()

  try {
    await loadData()
    const draft = await getDraft(draftKey.value)
    if (draft) applyDraft(draft)
  } finally {
    await nextTick()
    isRestoringDraft.value = false
  }
}

function handleCoverUploaded(res: CloudinaryUploadResponse) {
  form.value.imageUrl = res.url
  if (!form.value.imageTitle) {
    const filename = res.originalFilename?.replace(/\.[^/.]+$/, '').trim()
    form.value.imageTitle = filename || form.value.title || 'Campaign Cover Image'
  }
}

function handleGalleryUploaded(resList: CloudinaryUploadResponse[]) {
  for (const item of resList) {
    form.value.images.push({
      url: item.url,
      title: form.value.title || 'Gallery Image',
    })
  }
}

function handleSingleGalleryUploaded(res: CloudinaryUploadResponse) {
  form.value.images.push({
    url: res.url,
    title: form.value.title || 'Gallery Image',
  })
}

async function removeCoverImage() {
  const url = form.value.imageUrl
  if (!url) return

  await removeMedia(url, false, () => {
    form.value.imageUrl = ''
    form.value.imageTitle = ''
    form.value.imageDescription = ''
  })
}

async function removeGalleryImage(index: number) {
  const image = form.value.images[index]
  if (!image) return

  await removeMedia(image.url, false, () => {
    form.value.images.splice(index, 1)
  })
}

async function handleVideoUploaded(res: CloudinaryUploadResponse) {
  if (form.value.videoUrls.length >= 2) {
    alert('Maximum 2 videos allowed per campaign.')
    try {
      await deleteMediaByUrl(res.url, true)
    } catch {
      // The upload is already over the campaign limit. Keep the user-facing
      // form unchanged if cleanup cannot be completed.
    }
    return
  }
  form.value.videoUrls.push(res.url)
}

function addVideoUrlDirect() {
  if (!videoInputTemp.value.trim()) return
  if (form.value.videoUrls.length >= 2) {
    alert('Maximum 2 videos allowed per campaign.')
    return
  }
  form.value.videoUrls.push(videoInputTemp.value.trim())
  videoInputTemp.value = ''
}

async function removeVideoUrl(index: number) {
  const url = form.value.videoUrls[index]
  if (!url) return

  await removeMedia(url, true, () => {
    form.value.videoUrls.splice(index, 1)
  })
}

async function removeMedia(
  url: string,
  isVideo: boolean,
  onRemoved: () => void,
) {
  if (deletingMediaUrl.value) return

  deletingMediaUrl.value = url
  submitError.value = null
  try {
    await deleteMediaByUrl(url, isVideo)
    onRemoved()
  } catch (err: any) {
    submitError.value = err.message || 'Failed to delete media'
  } finally {
    deletingMediaUrl.value = null
  }
}

async function handleSubmit(saveStatus?: 'DRAFT' | 'PUBLIC') {
  if (saveStatus) {
    form.value.status = saveStatus
  }
  const cleanTitle = form.value.title.trim()
  if (!cleanTitle) {
    submitError.value = 'Title is required'
    return
  }
  if (cleanTitle.length < 3) {
    submitError.value = 'Title must be at least 3 characters long'
    return
  }

  submitError.value = null
  try {
    const cleanImageUrl = form.value.imageUrl?.trim()
    const cleanImages = form.value.images.filter((img) => img.url && img.url.trim().length > 0)
    const cleanVideos = form.value.videoUrls.filter((v) => v && v.trim().length > 0)

    const payload = {
      title: cleanTitle,
      description: form.value.description.trim() || undefined,
      category: form.value.category || undefined,
      contentType: form.value.contentType || 'ARTICLE',
      content: form.value.content || undefined,
      imageUrl: cleanImageUrl && cleanImageUrl.startsWith('http') ? cleanImageUrl : undefined,
      imageTitle: form.value.imageTitle || undefined,
      imageDescription: form.value.imageDescription || undefined,
      images: cleanImages.length > 0 ? cleanImages : undefined,
      videoUrls: cleanVideos.length > 0 ? cleanVideos : undefined,
      adNetwork: form.value.adNetwork || undefined,
      adUnitCode: form.value.adUnitCode || undefined,
      status: form.value.status,
    }

    if (props.isEdit && props.campaignId) {
      await updateCampaign(props.campaignId, payload)
    } else {
      await createCampaign(payload)
    }
    hasSubmitted.value = true
    if (draftSaveTimer) clearTimeout(draftSaveTimer)
    await removeDraft(draftKey.value)
    router.push('/creator/campaigns')
  } catch (err: any) {
    submitError.value = err.message || 'Failed to save campaign'
  }
}

watch(form, scheduleDraftSave, { deep: true })

onMounted(() => {
  fetchCategories()
  void initialiseForm()
})

onBeforeUnmount(() => {
  if (draftSaveTimer) clearTimeout(draftSaveTimer)
  void persistDraft()
})
</script>

<template>
  <div class="w-full space-y-6 pb-12">
    <!-- Header -->
    <div class="flex items-center justify-between border-b border-gray-200 dark:border-gray-800 pb-4">
      <div>
        <div class="flex items-center gap-2">
          <UButton
            to="/creator/campaigns"
            icon="i-heroicons-arrow-left"
            color="neutral"
            variant="ghost"
            size="xs"
          />
          <h1 class="text-2xl font-bold text-gray-900 dark:text-gray-100">
            {{ isEdit ? 'Edit Campaign' : 'Create Campaign' }}
          </h1>
        </div>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
          {{ isEdit ? 'Update campaign information, content, and attached media assets.' : 'Compose your campaign content, attach media, and publish to the network.' }}
        </p>
        <p v-if="draftStatus === 'saving'" class="text-xs text-gray-400 mt-1">
          Saving your progress locally...
        </p>
        <p v-else-if="draftStatus === 'saved'" class="text-xs text-green-600 dark:text-green-400 mt-1">
          Progress saved locally. It will return after a page reload.
        </p>
        <p v-else-if="draftStatus === 'error'" class="text-xs text-amber-600 dark:text-amber-400 mt-1">
          Local draft saving is unavailable; keep this page open until you save the campaign.
        </p>
      </div>

      <div class="flex items-center gap-2">
        <UButton
          color="neutral"
          variant="outline"
          size="sm"
          :loading="isLoading"
          @click="handleSubmit('DRAFT')"
        >
          Save Draft
        </UButton>
        <UButton
          color="primary"
          size="sm"
          :loading="isLoading"
          @click="handleSubmit('PUBLIC')"
        >
          {{ isEdit ? 'Save & Update' : 'Publish Campaign' }}
        </UButton>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="isFetching" class="py-12 text-center text-gray-500 text-base">
      <UIcon name="i-heroicons-arrow-path" class="w-6 h-6 animate-spin mx-auto mb-2 text-gray-400" />
      Loading campaign data...
    </div>

    <!-- Error Alert -->
    <div v-else-if="submitError" class="p-3 bg-red-50 dark:bg-red-950/40 border border-red-200 dark:border-red-800 rounded-lg text-sm text-red-600 dark:text-red-400 flex items-center gap-2">
      <UIcon name="i-heroicons-exclamation-triangle" class="w-4 h-4 shrink-0" />
      <span>{{ submitError }}</span>
    </div>

    <!-- Form Container -->
    <div v-if="!isFetching" class="space-y-6 bg-white dark:bg-gray-900 p-6 rounded-lg border border-gray-200 dark:border-gray-800">
      <!-- Title & Basic Metadata -->
      <div class="space-y-4">
        <div>
          <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">
            Campaign Title <span class="text-red-500">*</span>
          </label>
          <UInput
            v-model="form.title"
            placeholder="e.g. New Summer Promotion Campaign"
            size="lg"
            class="w-full"
          />
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">
              Category
            </label>
            <select
              v-model="form.category"
              class="w-full text-sm bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-md p-2 text-gray-900 dark:text-gray-100 focus:outline-none"
            >
              <option value="GENERAL">General</option>
              <option v-for="cat in categories" :key="cat.id" :value="cat.name">
                {{ cat.name }}
              </option>
            </select>
          </div>

          <div>
            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">
              Content Type
            </label>
            <select
              v-model="form.contentType"
              class="w-full text-sm bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-md p-2 text-gray-900 dark:text-gray-100 focus:outline-none"
            >
              <option value="ARTICLE">Article</option>
              <option value="NEWS">News</option>
              <option value="BANNER">Banner Promotion</option>
            </select>
          </div>
        </div>

        <div>
          <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">
            Short Description / Summary
          </label>
          <textarea
            v-model="form.description"
            rows="2"
            placeholder="Brief overview of the campaign..."
            class="w-full text-sm bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-md p-2 text-gray-900 dark:text-gray-100 focus:outline-none"
          ></textarea>
        </div>
      </div>

      <!-- Rich Text Body Content -->
      <div class="space-y-2 pt-2 border-t border-gray-100 dark:border-gray-800">
        <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300">
          Campaign Body Content (Rich Text / HTML / Tailwind)
        </label>
        <p class="text-sm text-gray-400">
          Use the visual editor toolbar for formatting (H1, H2, Bold, Lists, Media) or toggle "HTML / Tailwind Source" to write raw HTML markup and custom Tailwind CSS classes.
        </p>
        <CampaignRichTextEditor
          v-model="form.content"
          placeholder="Start writing campaign body content..."
        />
      </div>

      <!-- Media Assets & Cloudinary Upload -->
      <div class="space-y-4 pt-4 border-t border-gray-100 dark:border-gray-800">
        <h3 class="text-base font-bold text-gray-900 dark:text-gray-100">
          Media Assets &amp; Cloudinary Upload
        </h3>

        <!-- Main Cover Image -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <AppMediaUploader
            label="Main Cover Image"
            accept="image"
            folder="campaigns/covers"
            @uploaded="handleCoverUploaded"
          />

          <div v-if="form.imageUrl" class="space-y-2">
            <p class="text-sm font-semibold text-gray-700 dark:text-gray-300">Cover Preview &amp; Metadata</p>
            <div
              class="relative group border border-gray-200 dark:border-gray-700 rounded-lg overflow-hidden h-28 bg-gray-50 dark:bg-gray-950 flex items-center justify-center cursor-zoom-in"
              role="button"
              tabindex="0"
              :aria-label="`Open ${form.imageTitle || 'cover image'} preview`"
              @click="openImagePreview(form.imageUrl, form.imageTitle || 'Cover image')"
              @keydown.enter.prevent="openImagePreview(form.imageUrl, form.imageTitle || 'Cover image')"
              @keydown.space.prevent="openImagePreview(form.imageUrl, form.imageTitle || 'Cover image')"
            >
              <img :src="form.imageUrl" :alt="form.imageTitle || 'Cover image'" class="h-full w-full object-cover" />
              <span class="absolute bottom-2 left-2 rounded bg-black/60 px-2 py-1 text-xs text-white opacity-0 transition-opacity group-hover:opacity-100">
                Click to preview
              </span>
              <button
                type="button"
                class="absolute top-2 right-2 p-1 bg-red-600 text-white rounded-full opacity-80 hover:opacity-100"
                :disabled="deletingMediaUrl === form.imageUrl"
                :title="deletingMediaUrl === form.imageUrl ? 'Deleting media...' : 'Delete cover image'"
                @click.stop="removeCoverImage"
              >
                <UIcon
                  :name="deletingMediaUrl === form.imageUrl ? 'i-heroicons-arrow-path' : 'i-heroicons-x-mark'"
                  :class="['w-4 h-4', deletingMediaUrl === form.imageUrl ? 'animate-spin' : '']"
                />
              </button>
            </div>
            <UInput v-model="form.imageTitle" placeholder="Image Title / Alt text" size="sm" />
            <UInput v-model="form.imageDescription" placeholder="Image Caption / Description" size="sm" />
          </div>
        </div>

        <!-- Gallery Images -->
        <div class="space-y-2 pt-2">
          <AppMediaUploader
            label="Multi-Image Gallery"
            accept="image"
            folder="campaigns/gallery"
            :multiple="true"
            @multiUploaded="handleGalleryUploaded"
            @uploaded="handleSingleGalleryUploaded"
          />

          <div v-if="form.images.length > 0" class="grid grid-cols-2 sm:grid-cols-4 gap-3 pt-2">
            <div
              v-for="(img, idx) in form.images"
              :key="idx"
              class="relative group border border-gray-200 dark:border-gray-800 rounded-lg overflow-hidden p-1 bg-gray-50 dark:bg-gray-950 cursor-zoom-in"
              role="button"
              tabindex="0"
              :aria-label="`Open ${img.title || 'gallery image'} preview`"
              @click="openImagePreview(img.url, img.title || 'Gallery image')"
              @keydown.enter.prevent="openImagePreview(img.url, img.title || 'Gallery image')"
              @keydown.space.prevent="openImagePreview(img.url, img.title || 'Gallery image')"
            >
              <img :src="img.url" :alt="img.title || 'Gallery image'" class="w-full h-20 object-cover rounded" />
              <span class="absolute bottom-2 left-2 rounded bg-black/60 px-2 py-1 text-xs text-white opacity-0 transition-opacity group-hover:opacity-100">
                Preview
              </span>
              <button
                type="button"
                class="absolute top-2 right-2 p-1 bg-red-600 text-white rounded-full opacity-80 hover:opacity-100"
                :disabled="deletingMediaUrl === img.url"
                :title="deletingMediaUrl === img.url ? 'Deleting media...' : 'Delete gallery image'"
                @click.stop="removeGalleryImage(idx)"
              >
                <UIcon
                  :name="deletingMediaUrl === img.url ? 'i-heroicons-arrow-path' : 'i-heroicons-x-mark'"
                  :class="['w-3 h-3', deletingMediaUrl === img.url ? 'animate-spin' : '']"
                />
              </button>
            </div>
          </div>
        </div>

        <!-- Video Upload / Video URLs -->
        <div class="space-y-2 pt-2">
          <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300">
            Campaign Videos (Up to 2 MP4 / WebM Videos)
          </label>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <AppMediaUploader
              label="Upload Video"
              accept="video"
              folder="campaigns/videos"
              hint="Allowed: MP4, MOV, WEBM. (Max 50MB for creators)"
              @uploaded="handleVideoUploaded"
            />

            <div class="space-y-2">
              <p class="text-sm font-semibold text-gray-700 dark:text-gray-300">Or Add Direct Video URL</p>
              <div class="flex gap-2">
                <UInput
                  v-model="videoInputTemp"
                  placeholder="https://res.cloudinary.com/..."
                  size="sm"
                  class="flex-1"
                />
                <UButton
                  color="neutral"
                  variant="subtle"
                  size="sm"
                  @click="addVideoUrlDirect"
                >
                  Add Video
                </UButton>
              </div>

              <!-- Attached video previews -->
              <div v-if="form.videoUrls.length > 0" class="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-1">
                <div
                  v-for="(vUrl, idx) in form.videoUrls"
                  :key="vUrl"
                  class="relative overflow-hidden rounded-lg border border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800"
                >
                  <video
                    :src="vUrl"
                    controls
                    muted
                    preload="metadata"
                    class="w-full h-32 object-cover bg-black"
                  >
                    Your browser does not support video previews.
                  </video>
                  <button
                    type="button"
                    class="absolute top-2 right-2 p-1 bg-red-600 text-white rounded-full opacity-80 hover:opacity-100"
                    :disabled="deletingMediaUrl === vUrl"
                    :title="deletingMediaUrl === vUrl ? 'Deleting media...' : 'Delete video'"
                    @click.stop="removeVideoUrl(idx)"
                  >
                    <UIcon
                      :name="deletingMediaUrl === vUrl ? 'i-heroicons-arrow-path' : 'i-heroicons-x-mark'"
                      :class="['w-4 h-4', deletingMediaUrl === vUrl ? 'animate-spin' : '']"
                    />
                  </button>
                  <p class="truncate px-2 py-1 text-xs text-gray-500 dark:text-gray-400" :title="vUrl">
                    {{ vUrl }}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Monetization Integration -->
      <div class="space-y-4 pt-4 border-t border-gray-100 dark:border-gray-800">
        <h3 class="text-base font-bold text-gray-900 dark:text-gray-100">
          Monetization &amp; Ad Placement (Optional)
        </h3>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">
              Ad Network Integration
            </label>
            <select
              v-model="form.adNetwork"
              class="w-full text-sm bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-md p-2 text-gray-900 dark:text-gray-100 focus:outline-none"
            >
              <option value="">None / Custom</option>
              <option value="GOOGLE_ADSENSE">Google AdSense</option>
              <option value="ADSTERRA">Adsterra</option>
              <option value="CUSTOM">Custom Ad Slot</option>
            </select>
          </div>

          <div>
            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">
              Ad Unit Code Snippet / Zone ID
            </label>
            <UInput
              v-model="form.adUnitCode"
              placeholder="e.g. ca-pub-123456789 or zone-987"
              size="sm"
            />
          </div>
        </div>
      </div>
    </div>

    <!-- Full-size image preview -->
    <UModal
      v-model:open="imagePreviewOpen"
      :title="imagePreviewTitle"
      :ui="{ content: 'w-[calc(100vw-2rem)] max-w-[90vw] sm:max-w-[86vw] lg:max-w-[84vw]' }"
    >
      <template #body>
        <div class="flex h-[68vh] max-h-[68vh] min-h-[16rem] items-center justify-center overflow-auto bg-gray-950 p-2 sm:h-[72vh] sm:max-h-[72vh] sm:p-4">
          <img
            :src="imagePreviewUrl"
            :alt="imagePreviewTitle"
            class="max-h-full max-w-full object-contain"
          />
        </div>
      </template>
    </UModal>
  </div>
</template>
