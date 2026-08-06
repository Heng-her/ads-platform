<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useCampaigns, type CampaignImageItem, type CampaignData } from '~/composables/useCampaigns'
import { useCategories } from '~/composables/useCategories'
import type { CloudinaryUploadResponse } from '~/composables/useCloudinaryUpload'

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

const isFetching = ref(props.isEdit && !!props.campaignId)
const submitError = ref<string | null>(null)
const videoInputTemp = ref('')

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

function handleCoverUploaded(res: CloudinaryUploadResponse) {
  form.value.imageUrl = res.url
  if (!form.value.imageTitle) {
    form.value.imageTitle = form.value.title || 'Campaign Cover Image'
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

function removeGalleryImage(index: number) {
  form.value.images.splice(index, 1)
}

function handleVideoUploaded(res: CloudinaryUploadResponse) {
  if (form.value.videoUrls.length >= 2) {
    alert('Maximum 2 videos allowed per campaign.')
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

function removeVideoUrl(index: number) {
  form.value.videoUrls.splice(index, 1)
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
    router.push('/creator/campaigns')
  } catch (err: any) {
    submitError.value = err.message || 'Failed to save campaign'
  }
}

onMounted(() => {
  fetchCategories()
  loadData()
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
            <div class="relative group border border-gray-200 dark:border-gray-700 rounded-lg overflow-hidden h-28 bg-gray-50 dark:bg-gray-950 flex items-center justify-center">
              <img :src="form.imageUrl" alt="Cover" class="h-full w-full object-cover" />
              <button
                class="absolute top-2 right-2 p-1 bg-red-600 text-white rounded-full opacity-80 hover:opacity-100"
                @click="form.imageUrl = ''"
              >
                <UIcon name="i-heroicons-x-mark" class="w-4 h-4" />
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
            <div v-for="(img, idx) in form.images" :key="idx" class="relative group border border-gray-200 dark:border-gray-800 rounded-lg overflow-hidden p-1 bg-gray-50 dark:bg-gray-950">
              <img :src="img.url" class="w-full h-20 object-cover rounded" />
              <button
                class="absolute top-2 right-2 p-1 bg-red-600 text-white rounded-full opacity-80 hover:opacity-100"
                @click="removeGalleryImage(idx)"
              >
                <UIcon name="i-heroicons-x-mark" class="w-3 h-3" />
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

              <!-- List of attached video URLs -->
              <div v-if="form.videoUrls.length > 0" class="space-y-2 pt-1">
                <div v-for="(vUrl, idx) in form.videoUrls" :key="idx" class="flex items-center justify-between p-2 bg-gray-50 dark:bg-gray-800 rounded border border-gray-200 dark:border-gray-700 text-sm">
                  <div class="flex items-center gap-2 truncate">
                    <UIcon name="i-heroicons-video-camera" class="w-4 h-4 text-amber-500 shrink-0" />
                    <span class="truncate font-mono text-sm">{{ vUrl }}</span>
                  </div>
                  <button class="text-red-500 hover:text-red-600" @click="removeVideoUrl(idx)">
                    <UIcon name="i-heroicons-trash" class="w-4 h-4" />
                  </button>
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
  </div>
</template>
