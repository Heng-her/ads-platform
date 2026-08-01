<script setup lang="ts">
import { ref } from 'vue'

const openFaqIndex = ref<number | null>(0)

const faqs = [
  {
    q: 'How does non-custodial ad escrow work?',
    a: 'When you launch a campaign, your ad deposit is transferred directly into an open-source smart contract on Arbitrum/Base/Ethereum. The funds are held in escrow and released micro-fractionally to publisher wallets only when cryptographic proof of a verified ad impression is recorded on-chain.'
  },
  {
    q: 'Can I withdraw my campaign budget if I pause or stop an ad?',
    a: 'Yes. Because your deposit is held in a non-custodial smart escrow, you retain full ownership. When you pause or complete a campaign, all remaining unspent funds are instantly unlocked and returnable to your wallet via a simple smart contract call.'
  },
  {
    q: 'How does the protocol prevent ad fraud and fake bot traffic?',
    a: 'Our infrastructure uses decentralized verification nodes that validate cryptographic Merkle proofs for each impression event. Suspicious traffic spikes failing cryptographic signatures are rejected automatically before any escrow release occurs.'
  },
  {
    q: 'What cryptocurrencies or tokens are supported for ad deposits?',
    a: 'The protocol supports native stablecoins (USDC, USDT) and native gas tokens (ETH) across Arbitrum, Base, Polygon, and Ethereum Mainnet to ensure predictable campaign budgeting.'
  },
  {
    q: 'What is the protocol fee rate and how is it used?',
    a: 'The base protocol execution fee is 1.5% of completed campaign escrow streams, which drops to 0.5% for accounts holding or staking protocol tokens. Protocol fees directly maintain verification node infrastructure and DAO treasury.'
  }
]

function toggleFaq(index: number) {
  openFaqIndex.value = openFaqIndex.value === index ? null : index
}
</script>

<template>
  <section class="max-w-4xl mx-auto space-y-8">
    <div class="text-center space-y-3">
      <UBadge color="primary" variant="subtle" class="font-mono text-xs uppercase">Frequently Asked Questions</UBadge>
      <h2 class="text-3xl sm:text-4xl font-extrabold text-gray-900 dark:text-white">
        Frequently Asked Questions
      </h2>
      <p class="text-sm text-gray-600 dark:text-gray-400">Everything you need to know about non-custodial ad escrows and Web3 settlement.</p>
    </div>

    <div class="space-y-3">
      <div
        v-for="(faq, i) in faqs"
        :key="i"
        class="rounded-xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 overflow-hidden transition-colors"
      >
        <button
          type="button"
          class="w-full p-4 sm:p-5 text-left flex items-center justify-between gap-4 font-bold text-sm text-gray-900 dark:text-white hover:text-emerald-500 dark:hover:text-emerald-400 transition-colors"
          @click="toggleFaq(i)"
        >
          <span>{{ faq.q }}</span>
          <UIcon
            name="i-heroicons-chevron-down"
            class="w-5 h-5 text-gray-400 transition-transform duration-200 shrink-0"
            :class="{ 'rotate-180 text-emerald-400': openFaqIndex === i }"
          />
        </button>

        <div
          v-if="openFaqIndex === i"
          class="px-4 sm:px-5 pb-5 text-xs sm:text-sm text-gray-600 dark:text-gray-400 leading-relaxed border-t border-gray-100 dark:border-gray-850 pt-3"
        >
          {{ faq.a }}
        </div>
      </div>
    </div>
  </section>
</template>
