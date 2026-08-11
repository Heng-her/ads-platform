export interface AdProviderStats {
  provider: 'GOOGLE_ADSENSE' | 'ADSTERRA'
  providerName: string
  revenue: number
  impressions: number
  clicks: number
  ctr: number
  cpm: number
  trend: Array<{ date: string; revenue: number; impressions: number }>
}

export interface IAdProvider {
  providerName: string
  getStats(startDate: string, endDate: string, credentials: Record<string, any>): Promise<AdProviderStats>
  testConnection(credentials: Record<string, any>): Promise<{ success: boolean; message: string }>
}
