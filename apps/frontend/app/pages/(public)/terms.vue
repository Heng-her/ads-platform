<script setup lang="ts">
import { ref, computed } from 'vue'

definePageMeta({
  layout: 'default'
})

useSeoMeta({
  title: 'Terms of Service - NewPlatform',
  description: 'Terms of Service, Smart Contract Rules, and User Agreements for NewPlatform Web3 Advertising Infrastructure.',
  ogTitle: 'Terms of Service - NewPlatform',
  ogDescription: 'Terms of Service and Operational Rules for NewPlatform.',
})

const lastUpdated = 'August 17, 2026'
const activeSection = ref('acceptance')
const searchQuery = ref('')
const copied = ref(false)

const sections = [
  {
    id: 'acceptance',
    title: '1. Acceptance of Terms',
    icon: 'i-lucide-file-check',
    content: `By accessing or using NewPlatform ("the Platform"), including our website, smart contract protocols, APIs, and ad distribution network, you ("User", "Creator", "Advertiser", or "Publisher") agree to be bound by these Terms of Service. If you do not agree to all terms, you must immediately cease accessing or using our services.`
  },
  {
    id: 'platform-overview',
    title: '2. Platform Overview & Web3 Infrastructure',
    icon: 'i-lucide-cpu',
    content: `NewPlatform operates a decentralized, smart-contract powered advertising network. All ad deposit escrows, publisher revenue settlements, and programmatic payouts are executed on EVM/TRON blockchain protocols. Users acknowledge that transactions on public blockchain networks are irreversible, non-refundable once settled on-chain, and subject to variable gas/network fees.`
  },
  {
    id: 'creator-rules',
    title: '3. Creator & Publisher Guidelines',
    icon: 'i-lucide-user-check',
    content: `Publishers and Creators deploying ad slots or sharing content agree to:
- Maintain active, non-deceptive domains and media properties.
- Refrain from generating fraudulent impressions, automated bot clicks, or incentivized click rings.
- Comply with all local content laws and intellectual property rights. Violation will result in immediate escrow freeze and account suspension.`
  },
  {
    id: 'advertiser-rules',
    title: '4. Advertiser Campaign Requirements',
    icon: 'i-lucide-megaphone',
    content: `Advertisers creating campaigns on NewPlatform warrant that:
- All campaign assets, banners, landing pages, and smart contract links do not contain malware, phishing schemes, illegal content, or deceptive financial guarantees.
- Ad budgets deposited into smart contract escrows are locked until impression/click criteria defined by the campaign parameters are validated by our decentralized oracle audit.`
  },
  {
    id: 'payments-escrow',
    title: '5. Payments, Escrow & Payouts',
    icon: 'i-lucide-wallet',
    content: `Deposits can be made in supported cryptocurrencies (USDC, USDT, ETH) or fiat equivalents. Payout requests undergo real-time automated fraud scoring and multi-sig admin audit before on-chain execution. The Platform reserves the right to hold payouts for up to 72 hours in cases of suspected click fraud or bot manipulation.`
  },
  {
    id: 'anti-fraud',
    title: '6. Anti-Fraud & Account Termination',
    icon: 'i-lucide-shield-alert',
    content: `NewPlatform utilizes proprietary AI and heuristic tracking to monitor ad traffic quality. Any user engaging in Sybil attacks, impression spoofing, traffic laundering, or protocol exploitation will have their balance forfeited and be permanently banned from the network without prior notice.`
  },
  {
    id: 'limitation-liability',
    title: '7. Limitation of Liability',
    icon: 'i-lucide-alert-triangle',
    content: `To the maximum extent permitted by law, NewPlatform, its developers, and affiliates shall not be liable for any indirect, incidental, or consequential damages resulting from blockchain network congestion, smart contract vulnerabilities beyond reasonable audit, or third-party outages.`
  },
  {
    id: 'contact',
    title: '8. Contact & Legal Support',
    icon: 'i-lucide-mail',
    content: `For legal inquiries, compliance questions, or DMCA copyright notices, please contact our legal operations team at legal@newplatform.network or reach out through our official community channels.`
  }
]

const filteredSections = computed(() => {
  const query = searchQuery.value.toLowerCase().trim()
  if (!query) return sections
  return sections.filter(s =>
    s.title.toLowerCase().includes(query) ||
    s.content.toLowerCase().includes(query)
  )
})

function scrollToSection(id: string) {
  activeSection.value = id
  const el = document.getElementById(id)
  if (el) {
    el.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }
}

function copyLink() {
  if (import.meta.client) {
    navigator.clipboard.writeText(window.location.href)
    copied.value = true
    setTimeout(() => { copied.value = false }, 2000)
  }
}

function handlePrint() {
  if (import.meta.client) {
    window.print()
  }
}
</script>

<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-12">
    <!-- Header Hero Banner -->
    <header class="relative rounded-3xl bg-slate-950 p-8 sm:p-12 md:p-16 overflow-hidden border border-slate-800 shadow-2xl text-center md:text-left">
      <!-- Glow Effects -->
      <div class="absolute -top-24 -right-24 w-96 h-96 bg-blue-600/20 blur-[120px] rounded-full pointer-events-none" />
      <div class="absolute -bottom-24 -left-24 w-96 h-96 bg-teal-500/15 blur-[120px] rounded-full pointer-events-none" />

      <div class="relative z-10 max-w-3xl space-y-4">
        <div class="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-400 text-xs font-semibold">
          <UIcon name="i-lucide-shield-check" class="w-4 h-4" />
          <span>Legal Agreement & Operating Rules</span>
        </div>

        <h1 class="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-white tracking-tight leading-tight">
          Terms of <span class="bg-gradient-to-r from-blue-400 to-teal-400 bg-clip-text text-transparent">Service</span>
        </h1>

        <p class="text-sm sm:text-base text-slate-300 leading-relaxed">
          Please review the operating terms, smart contract escrow rules, and compliance standards governing the NewPlatform Web3 advertising ecosystem.
        </p>

        <div class="flex flex-wrap items-center gap-4 text-xs text-slate-400 pt-2 justify-center md:justify-start">
          <div class="flex items-center gap-1.5">
            <UIcon name="i-lucide-clock" class="w-4 h-4 text-blue-400" />
            <span>Effective Date: <strong>{{ lastUpdated }}</strong></span>
          </div>
          <span class="hidden sm:inline text-slate-700">•</span>
          <div class="flex items-center gap-1.5">
            <UIcon name="i-lucide-globe" class="w-4 h-4 text-teal-400" />
            <span>Version 2.4 (Global)</span>
          </div>
        </div>
      </div>

      <!-- Action Buttons -->
      <div class="relative z-10 mt-8 flex flex-wrap gap-3 justify-center md:justify-start">
        <button
          @click="handlePrint"
          class="px-4 py-2.5 rounded-xl bg-white/10 hover:bg-white/15 border border-white/15 text-white text-xs font-semibold transition-all flex items-center gap-2 cursor-pointer backdrop-blur-md">
          <UIcon name="i-lucide-printer" class="w-4 h-4" />
          Print / Save PDF
        </button>

        <button
          @click="copyLink"
          class="px-4 py-2.5 rounded-xl bg-white/10 hover:bg-white/15 border border-white/15 text-white text-xs font-semibold transition-all flex items-center gap-2 cursor-pointer backdrop-blur-md">
          <UIcon :name="copied ? 'i-lucide-check' : 'i-lucide-link'" class="w-4 h-4 text-blue-400" />
          {{ copied ? 'Link Copied!' : 'Copy Link' }}
        </button>
      </div>
    </header>

    <!-- Main Content Layout -->
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
      <!-- Left Sidebar: Search & Navigation Tabs -->
      <aside class="lg:col-span-4 sticky top-24 space-y-6">
        <!-- Search Bar -->
        <div class="relative">
          <UIcon name="i-lucide-search" class="absolute left-3.5 top-3 w-4 h-4 text-slate-400 pointer-events-none" />
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Search terms (e.g., escrow, fraud, payout)..."
            class="w-full pl-10 pr-4 py-2.5 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl text-xs sm:text-sm text-slate-900 dark:text-white placeholder-slate-400 focus:ring-2 focus:ring-blue-500 outline-none transition-all shadow-sm">
        </div>

        <!-- Section Links Navigation -->
        <nav class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-4 shadow-sm space-y-1">
          <h3 class="text-xs font-bold text-slate-400 uppercase tracking-wider px-3 mb-3">
            Table of Contents
          </h3>

          <div class="space-y-1 max-h-[60vh] overflow-y-auto pr-1 [scrollbar-width:thin]">
            <button
              v-for="s in sections"
              :key="s.id"
              @click="scrollToSection(s.id)"
              class="w-full text-left px-3 py-2.5 rounded-xl text-xs font-medium transition-all flex items-center justify-between group cursor-pointer"
              :class="[
                activeSection === s.id
                  ? 'bg-blue-50 dark:bg-blue-950/40 text-blue-600 dark:text-blue-400 font-semibold'
                  : 'text-slate-600 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-800/60'
              ]">
              <span class="flex items-center gap-2.5 truncate">
                <UIcon :name="s.icon" class="w-4 h-4 shrink-0 text-slate-400 group-hover:text-blue-500 transition-colors" />
                <span class="truncate">{{ s.title }}</span>
              </span>
              <UIcon name="i-lucide-chevron-right" class="w-3.5 h-3.5 opacity-0 group-hover:opacity-100 transition-opacity shrink-0" />
            </button>
          </div>
        </nav>

        <!-- Help Card -->
        <div class="rounded-2xl bg-gradient-to-br from-blue-900/10 to-teal-900/10 border border-blue-200/50 dark:border-blue-900/30 p-5 space-y-3">
          <div class="flex items-center gap-2.5 text-blue-600 dark:text-blue-400 font-semibold text-sm">
            <UIcon name="i-lucide-help-circle" class="w-5 h-5 shrink-0" />
            <span>Have Questions?</span>
          </div>
          <p class="text-xs text-slate-600 dark:text-slate-400 leading-relaxed">
            Need clarification on campaign terms or smart contract escrow rules? Reach out to our legal team anytime.
          </p>
          <NuxtLink
            to="/news"
            class="inline-flex items-center gap-1.5 text-xs font-semibold text-blue-600 dark:text-blue-400 hover:underline">
            Visit Help & News Center
            <UIcon name="i-lucide-arrow-right" class="w-3.5 h-3.5" />
          </NuxtLink>
        </div>
      </aside>

      <!-- Right Main Column: Terms Content Cards -->
      <main class="lg:col-span-8 space-y-6">
        <div v-if="filteredSections.length === 0" class="text-center py-12 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-8 space-y-3">
          <UIcon name="i-lucide-search-x" class="w-10 h-10 mx-auto text-slate-400" />
          <p class="text-sm font-semibold text-slate-700 dark:text-slate-300">No matching terms found</p>
          <p class="text-xs text-slate-500">Try searching for alternative keywords such as "escrow", "fraud", or "payout".</p>
          <button @click="searchQuery = ''" class="px-4 py-2 bg-blue-600 text-white rounded-xl text-xs font-semibold">
            Clear Search
          </button>
        </div>

        <article
          v-for="s in filteredSections"
          :id="s.id"
          :key="s.id"
          class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-6 sm:p-8 shadow-sm transition-all hover:border-slate-300 dark:hover:border-slate-700 space-y-4 scroll-mt-28">
          <header class="flex items-center gap-3 border-b border-slate-100 dark:border-slate-800/80 pb-4">
            <div class="p-2.5 rounded-xl bg-blue-50 dark:bg-blue-950/50 text-blue-600 dark:text-blue-400 shrink-0">
              <UIcon :name="s.icon" class="w-5 h-5" />
            </div>
            <h2 class="text-lg sm:text-xl font-bold text-slate-900 dark:text-white">
              {{ s.title }}
            </h2>
          </header>

          <div class="text-xs sm:text-sm text-slate-600 dark:text-slate-300 leading-relaxed whitespace-pre-line space-y-2">
            {{ s.content }}
          </div>

          <!-- Highlight Alert Box for Key Sections -->
          <div v-if="s.id === 'platform-overview'" class="rounded-xl border border-amber-200 dark:border-amber-900/40 bg-amber-50/70 dark:bg-amber-950/20 p-4 text-xs text-amber-800 dark:text-amber-300 flex items-start gap-3">
            <UIcon name="i-lucide-alert-circle" class="w-5 h-5 shrink-0 text-amber-600 dark:text-amber-400 mt-0.5" />
            <div>
              <strong class="font-semibold block mb-0.5">Important Web3 Note:</strong>
              Smart contract transactions are final. Please verify recipient addresses and campaign deposit amounts before submitting on-chain transactions.
            </div>
          </div>
        </article>

        <!-- Acceptance Banner Footer -->
        <footer class="rounded-2xl bg-slate-900 text-white p-6 sm:p-8 border border-slate-800 flex flex-col sm:flex-row items-center justify-between gap-6">
          <div class="space-y-1 text-center sm:text-left">
            <h3 class="font-bold text-base">Ready to build or advertise?</h3>
            <p class="text-xs text-slate-400">By creating an account or depositing funds, you accept these Terms of Service.</p>
          </div>

          <div class="flex items-center gap-3 shrink-0">
            <NuxtLink
              to="/register"
              class="px-5 py-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white text-xs font-semibold shadow-lg transition-all">
              Create Account
            </NuxtLink>
            <NuxtLink
              to="/"
              class="px-5 py-2.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-semibold border border-slate-700 transition-all">
              Return Home
            </NuxtLink>
          </div>
        </footer>
      </main>
    </div>
  </div>
</template>

<style scoped>
@media print {
  aside, button, footer {
    display: none !important;
  }
  main {
    width: 100% !important;
  }
  article {
    border: none !important;
    box-shadow: none !important;
    page-break-inside: avoid;
  }
}
</style>
