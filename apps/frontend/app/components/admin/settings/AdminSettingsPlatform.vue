<script setup lang="ts">
import { ref, computed } from 'vue'
import AdminSettingInput from './AdminSettingInput.vue'
import AppMediaUploader from '~/components/AppMediaUploader.vue'
import type { CloudinaryUploadResponse } from '~/composables/useCloudinaryUpload'

export interface RouteSeoConfig {
  title: string
  description: string
  image: string
}

export interface PlatformConfig {
  siteName: string
  siteDescription: string
  siteUrl: string
  defaultLanguage: string
  allowRegistrations: boolean
  ogImage?: string
  seo?: {
    home?: RouteSeoConfig
    explore?: RouteSeoConfig
    trending?: RouteSeoConfig
    pricing?: RouteSeoConfig
    news?: RouteSeoConfig
  }
}

export interface SecurityConfig {
  creatorDeletionPassword: string
}

const config = defineModel<PlatformConfig>({ required: true })
const securityConfig = defineModel<SecurityConfig>('security', { required: true })

type SubTab = 'general' | 'seo'
type SeoRouteKey = 'home' | 'explore' | 'trending' | 'pricing' | 'news'
type PreviewPlatformMode = 'twitter' | 'google' | 'facebook'

const activeSubTab = ref<SubTab>('general')
const activeSeoTab = ref<SeoRouteKey>('home')
const previewMode = ref<PreviewPlatformMode>('twitter')

const routeLabels: Record<SeoRouteKey, { label: string; routePath: string; defaultImage: string; icon: string }> = {
  home: { label: 'Home Page', routePath: '/', defaultImage: '/images/seo/og-home.svg', icon: 'i-heroicons-home' },
  explore: { label: 'Explore Feed', routePath: '/explore', defaultImage: '/images/seo/og-explore.svg', icon: 'i-heroicons-magnifying-glass' },
  trending: { label: 'Trending Posts', routePath: '/trending', defaultImage: '/images/seo/og-trending.svg', icon: 'i-heroicons-fire' },
  pricing: { label: 'Monetization & Pricing', routePath: '/pricing', defaultImage: '/images/seo/og-pricing.svg', icon: 'i-heroicons-currency-dollar' },
  news: { label: 'News & Trends', routePath: '/news', defaultImage: '/images/seo/og-news.svg', icon: 'i-heroicons-newspaper' }
}

const currentRouteInfo = computed(() => routeLabels[activeSeoTab.value])

function getRouteConfig(routeKey: SeoRouteKey): RouteSeoConfig {
  if (!config.value.seo) config.value.seo = {}
  if (!config.value.seo[routeKey]) {
    config.value.seo[routeKey] = {
      title: '',
      description: '',
      image: routeLabels[routeKey].defaultImage
    }
  }
  return config.value.seo[routeKey]!
}

const currentConfig = computed(() => getRouteConfig(activeSeoTab.value))

function handleGlobalOgUploaded(res: CloudinaryUploadResponse) {
  const imageUrl = res.url || (res as any).secure_url
  if (imageUrl) {
    config.value.ogImage = imageUrl
  }
}

function handleRouteOgUploaded(res: CloudinaryUploadResponse) {
  const imageUrl = res.url || (res as any).secure_url
  if (imageUrl) {
    currentConfig.value.image = imageUrl
  }
}

function resetRouteImage() {
  currentConfig.value.image = currentRouteInfo.value.defaultImage
}
</script>

<template>
  <div class="space-y-6">
    <!-- Main Sub-Navigation Bar (Tab in Tab) -->
    <div class="flex border-b border-gray-800 bg-gray-900/60 p-1.5 rounded-xl gap-2">
      <button
        type="button"
        class="flex-1 flex items-center justify-center gap-2 py-2.5 px-4 rounded-lg text-xs font-bold transition-all"
        :class="activeSubTab === 'general'
          ? 'bg-primary-600 text-white shadow-md'
          : 'text-gray-400 hover:text-white hover:bg-gray-800/60'"
        @click="activeSubTab = 'general'"
      >
        <UIcon name="i-heroicons-cog-6-tooth" class="w-4 h-4" />
        <span>General Platform &amp; Security</span>
      </button>

      <button
        type="button"
        class="flex-1 flex items-center justify-center gap-2 py-2.5 px-4 rounded-lg text-xs font-bold transition-all"
        :class="activeSubTab === 'seo'
          ? 'bg-primary-600 text-white shadow-md'
          : 'text-gray-400 hover:text-white hover:bg-gray-800/60'"
        @click="activeSubTab = 'seo'"
      >
        <UIcon name="i-heroicons-share" class="w-4 h-4" />
        <span>Public Pages SEO &amp; OG Images</span>
      </button>
    </div>

    <!-- SUB-TAB 1: General & Security -->
    <div v-if="activeSubTab === 'general'" class="space-y-6">
      <!-- General Site Settings Card -->
      <div class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm">
        <h2 class="text-lg font-semibold text-white">General Site Settings</h2>
        <p class="mt-1 text-sm text-gray-400">Manage site metadata, domain URL, and creator registration permissions.</p>

        <div class="mt-6 grid gap-6 md:grid-cols-2">
          <AdminSettingInput
            v-model="config.siteName"
            label="Site Title / Brand Name"
            icon="i-heroicons-globe-alt"
            placeholder="Signal — Ads Platform"
          />

          <AdminSettingInput
            v-model="config.siteUrl"
            label="Website Base URL / Domain"
            icon="i-heroicons-link"
            placeholder="http://localhost:3000"
            hint="Used for canonical URLs and absolute Open Graph image paths."
          />

          <div class="col-span-2">
            <AdminSettingInput
              v-model="config.siteDescription"
              label="Global Default Meta Description"
              type="textarea"
              :rows="2"
              placeholder="Signal is a modern advertising & publisher network connecting creators and advertisers."
            />
          </div>

          <div class="col-span-2 space-y-3">
            <AdminSettingInput
              v-model="config.ogImage"
              label="Default Social Share Image (OG Image URL)"
              icon="i-heroicons-photo"
              placeholder="/images/seo/og-default.svg"
              hint="Fallback image used when sharing site links on Twitter, Facebook, LinkedIn, or Discord."
            />

            <!-- Image Uploader for Global OG -->
            <div class="pt-2">
              <label class="block text-xs font-semibold text-gray-300 mb-1">Upload Global Default Share Image</label>
              <AppMediaUploader
                folder="seo"
                hint="Upload PNG, JPG, or WEBP for default social share card"
                @uploaded="handleGlobalOgUploaded"
              />
            </div>
          </div>
        </div>
      </div>

      <!-- Creator Account Deletion Security Card -->
      <div class="rounded-xl border border-red-900/40 bg-gray-900 p-6 shadow-sm">
        <div class="flex items-center gap-3">
          <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-red-500/10 text-red-400">
            <UIcon name="i-heroicons-shield-check" class="h-6 w-6" />
          </div>
          <div>
            <h2 class="text-lg font-semibold text-white">Creator Account Deletion Security</h2>
            <p class="text-xs text-gray-400">Set the master security password required by administrators to permanently delete creator accounts on the Approvals page.</p>
          </div>
        </div>

        <div class="mt-6 max-w-md space-y-2">
          <AdminSettingInput
            v-model="securityConfig.creatorDeletionPassword"
            label="Creator Deletion Security Password"
            type="password"
            icon="i-heroicons-key"
            placeholder="Enter deletion security password"
            hint="Administrators must enter this exact password on /admin/approvals to delete any creator account."
          />
        </div>
      </div>
    </div>

    <!-- SUB-TAB 2: Dynamic Page SEO & Social Share Cards -->
    <div v-else-if="activeSubTab === 'seo'" class="rounded-xl border border-gray-800 bg-gray-900 p-6 shadow-sm space-y-6">
      <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-gray-800 pb-4">
        <div>
          <div class="flex items-center gap-2">
            <UIcon name="i-heroicons-share" class="w-5 h-5 text-primary-400" />
            <h2 class="text-lg font-semibold text-white">Per-Route SEO &amp; Open Graph Images</h2>
          </div>
          <p class="mt-1 text-sm text-gray-400">Customize meta titles, meta descriptions, and custom share images for each main public page route.</p>
        </div>
      </div>

      <!-- Route Selector Tabs -->
      <div class="flex flex-wrap gap-2 border-b border-gray-800 pb-3">
        <button
          v-for="(info, key) in routeLabels"
          :key="key"
          type="button"
          class="flex items-center gap-2 px-3.5 py-2 rounded-lg text-xs font-semibold transition-all"
          :class="activeSeoTab === key
            ? 'bg-primary-600 text-white shadow-md shadow-primary-900/30'
            : 'bg-gray-800/80 text-gray-400 hover:bg-gray-800 hover:text-white'"
          @click="activeSeoTab = key"
        >
          <UIcon :name="info.icon" class="w-4 h-4" />
          <span>{{ info.label }}</span>
          <span class="text-[10px] opacity-75 font-mono">({{ info.routePath }})</span>
        </button>
      </div>

      <!-- Selected Route SEO Form & Live Card Preview -->
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 pt-2">
        <!-- Form Inputs & Uploader (Left) -->
        <div class="lg:col-span-7 space-y-4">
          <AdminSettingInput
            v-model="currentConfig.title"
            :label="`Meta Title (${currentRouteInfo.label})`"
            icon="i-heroicons-document-text"
            placeholder="Custom title for search engine result pages"
          />

          <AdminSettingInput
            v-model="currentConfig.description"
            :label="`Meta Description (${currentRouteInfo.label})`"
            type="textarea"
            :rows="3"
            placeholder="Custom excerpt summary used for search results & social snippets"
          />

          <AdminSettingInput
            v-model="currentConfig.image"
            :label="`Open Graph Image &amp; Google Search Thumbnail URL (${currentRouteInfo.label})`"
            icon="i-heroicons-photo"
            :placeholder="currentRouteInfo.defaultImage"
            hint="Absolute URL or relative path (e.g. /images/seo/og-home.svg or https://res.cloudinary.com/...)"
          />

          <!-- Custom Image Uploader for current route -->
          <div class="pt-2 border-t border-gray-800 space-y-2">
            <div class="flex items-center justify-between">
              <label class="block text-xs font-semibold text-gray-300">
                Upload Custom Share Image / Thumbnail for {{ currentRouteInfo.label }}
              </label>
              <button
                v-if="currentConfig.image !== currentRouteInfo.defaultImage"
                type="button"
                class="text-xs text-amber-400 hover:underline flex items-center gap-1 font-medium"
                @click="resetRouteImage"
              >
                <UIcon name="i-heroicons-arrow-path" class="w-3.5 h-3.5" />
                Reset to Default Image
              </button>
            </div>

            <AppMediaUploader
              folder="seo"
              hint="Upload high-res banner or Google search thumbnail image"
              @uploaded="handleRouteOgUploaded"
            />
          </div>
        </div>

        <!-- Social Media & Google SERP Card Live Preview (Right) -->
        <div class="lg:col-span-5 bg-gray-950/80 border border-gray-800 rounded-xl p-4 flex flex-col justify-between space-y-4">
          <div class="space-y-3">
            <!-- Live Preview Mode Switcher -->
            <div class="flex items-center justify-between text-xs text-gray-400 font-medium">
              <span class="flex items-center gap-1.5 text-primary-400 font-semibold">
                <UIcon name="i-heroicons-sparkles" class="w-4 h-4" />
                Live Preview Mode
              </span>

              <div class="flex bg-gray-900 border border-gray-800 p-0.5 rounded-md gap-1">
                <button
                  type="button"
                  class="px-2 py-1 rounded text-[11px] font-semibold transition-colors"
                  :class="previewMode === 'twitter' ? 'bg-primary-600 text-white' : 'text-gray-400 hover:text-white'"
                  @click="previewMode = 'twitter'"
                >
                  Twitter / X
                </button>
                <button
                  type="button"
                  class="px-2 py-1 rounded text-[11px] font-semibold transition-colors"
                  :class="previewMode === 'facebook' ? 'bg-primary-600 text-white' : 'text-gray-400 hover:text-white'"
                  @click="previewMode = 'facebook'"
                >
                  Facebook / Discord
                </button>
                <button
                  type="button"
                  class="px-2 py-1 rounded text-[11px] font-semibold transition-colors"
                  :class="previewMode === 'google' ? 'bg-primary-600 text-white' : 'text-gray-400 hover:text-white'"
                  @click="previewMode = 'google'"
                >
                  Google SERP
                </button>
              </div>
            </div>

            <!-- Preview Card Box (Twitter / Facebook / Discord Mode) -->
            <div v-if="previewMode !== 'google'" class="rounded-lg overflow-hidden border border-gray-800 bg-gray-900 shadow-md">
              <!-- OG Image preview -->
              <div class="aspect-[1200/630] bg-gray-950 flex items-center justify-center relative overflow-hidden group">
                <img
                  v-if="currentConfig.image"
                  :src="currentConfig.image"
                  class="w-full h-full object-cover"
                  alt="OG Image Preview"
                />
                <div v-else class="text-xs text-gray-500 flex flex-col items-center gap-2">
                  <UIcon name="i-heroicons-photo" class="w-8 h-8" />
                  <span>No image specified</span>
                </div>
              </div>

              <!-- Meta details preview -->
              <div class="p-3.5 space-y-1">
                <div class="text-[11px] font-semibold text-gray-400 uppercase tracking-wider">
                  {{ config.siteUrl.replace(/^https?:\/\//, '') }}
                </div>
                <div class="text-sm font-bold text-white line-clamp-1">
                  {{ currentConfig.title || config.siteName }}
                </div>
                <div class="text-xs text-gray-400 line-clamp-2">
                  {{ currentConfig.description || config.siteDescription }}
                </div>
              </div>
            </div>

            <!-- Preview Card Box (Google Search SERP Mode with Rich Thumbnail Image) -->
            <div v-else class="rounded-lg border border-gray-800 bg-gray-900 p-4 space-y-2 shadow-md">
              <div class="flex items-center gap-2 text-xs text-gray-400 font-mono">
                <UIcon name="i-heroicons-globe-alt" class="w-3.5 h-3.5 text-emerald-400 shrink-0" />
                <span class="text-gray-300 font-sans truncate">{{ config.siteUrl }}{{ currentRouteInfo.routePath }}</span>
              </div>
              <div class="text-base font-semibold text-blue-400 hover:underline line-clamp-1 cursor-pointer">
                {{ currentConfig.title || config.siteName }}
              </div>

              <div class="flex gap-3 items-start pt-1">
                <div class="flex-1 text-xs text-gray-300 line-clamp-3 leading-relaxed">
                  {{ currentConfig.description || config.siteDescription }}
                </div>

                <!-- Google Search Result Thumbnail Image -->
                <div v-if="currentConfig.image" class="w-20 h-20 rounded-lg border border-gray-800 bg-gray-950 overflow-hidden shrink-0 shadow-sm">
                  <img :src="currentConfig.image" class="w-full h-full object-cover" alt="Google Search Thumbnail" />
                </div>
              </div>
            </div>
          </div>

          <!-- Bottom Footer Status -->
          <div class="pt-3 border-t border-gray-800/80 text-[11px] text-gray-400 flex items-center justify-between">
            <span class="flex items-center gap-1.5 text-emerald-400 font-medium">
              <UIcon name="i-heroicons-check-circle" class="w-4 h-4 shrink-0" />
              <span>Google SERP Thumbnail &amp; Schema JSON-LD Enabled</span>
            </span>
            <span class="font-mono text-[10px] text-gray-500">{{ currentRouteInfo.routePath }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
