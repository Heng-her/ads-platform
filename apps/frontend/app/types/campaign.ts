import type { InferResponseType } from 'hono/client'
import type { useApi } from '~/composables/useApi'

type ApiClient = ReturnType<typeof useApi>

export type CampaignsListResponse = InferResponseType<ApiClient['campaigns']['$get']>
export type CampaignItem = NonNullable<NonNullable<CampaignsListResponse['data']>['items']>[number]

export type CategoriesListResponse = InferResponseType<ApiClient['categories']['$get']>
export type CategoryItem = NonNullable<CategoriesListResponse['data']>[number]
