<script setup lang="ts">
import { useRoute } from 'vue-router'

definePageMeta({
  layout: 'creator'
})

const route = useRoute()
const campaignId = computed(() => route.params.id as string)
</script>

<template>
  <CampaignForm :is-edit="true" :campaign-id="campaignId" />
</template>
