import { ref } from "vue";
import { useApi } from "./useApi";

export interface CampaignImageItem {
  url: string;
  title?: string;
  description?: string;
}

export interface CampaignData {
  id: string;
  userId: string;
  title: string;
  description?: string | null;
  category?: string | null;
  contentType?: string;
  content?: string | null;
  imageUrl?: string | null;
  imageTitle?: string | null;
  imageDescription?: string | null;
  images?: CampaignImageItem[] | null;
  videoUrls?: string[] | null;
  adNetwork?: string | null;
  adUnitCode?: string | null;
  status: "DRAFT" | "PUBLIC";
  isDeleted?: boolean;
  totalImpressions?: number;
  uniqueViewers?: number;
  createdAt: string;
  updatedAt: string;
  creator?: {
    username: string | null;
    avatar: string | null;
  } | null;
}

export interface AdminCampaignUser {
  id: string;
  username: string;
  email: string;
  avatar?: string | null;
  role: 'ADMIN' | 'CREATOR';
  status: 'ACTIVE' | 'SUSPENDED' | 'PENDING';
  createdAt: string;
  publicPosts: CampaignData[];
}

export interface CampaignFormInput {
  title: string;
  description?: string;
  category?: string;
  contentType?: string;
  content?: string;
  imageUrl?: string;
  imageTitle?: string;
  imageDescription?: string;
  images?: CampaignImageItem[];
  videoUrls?: string[];
  adNetwork?: string;
  adUnitCode?: string;
  status?: "DRAFT" | "PUBLIC";
}

export interface ListCampaignsOptions {
  page?: number;
  limit?: number;
  category?: string;
  contentType?: string;
  search?: string;
  status?: "DRAFT" | "PUBLIC";
}

export function useCampaigns() {
  const isLoading = ref(false);
  const error = ref<string | null>(null);
  const campaignsList = ref<CampaignData[]>([]);
  const totalItems = ref(0);
  const totalPages = ref(1);

  const api = useApi();

  /**
   * List campaigns (for current creator or admin view)
   */
  async function fetchCampaigns(options: ListCampaignsOptions = {}) {
    isLoading.value = true;
    error.value = null;

    try {
      const response = await api.action.$post({
        json: {
          action: "campaigns/list",
          data: options,
        },
      });

      const body = await response.json();
      if (response.ok && body.code === 1 && body.data) {
        campaignsList.value = body.data.items || [];
        totalItems.value = body.data.total || 0;
        totalPages.value = body.data.totalPages || 1;
        return body.data;
      } else {
        throw new Error(body.msg || "Failed to load campaigns");
      }
    } catch (err: any) {
      error.value = err.message || "An error occurred";
      throw err;
    } finally {
      isLoading.value = false;
    }
  }

  /** Fetches only campaigns owned by the authenticated creator. */
  async function fetchMyCampaigns(options: Pick<ListCampaignsOptions, 'page' | 'limit' | 'category' | 'search' | 'status'> = {}) {
    isLoading.value = true;
    error.value = null;
    try {
      const query = Object.fromEntries(
        Object.entries(options)
          .filter(([, value]) => value !== undefined)
          .map(([key, value]) => [key, String(value)]),
      );
      const response = await api.campaigns.me.$get({ query });
      const body = await response.json();
      if (response.ok && body.code === 1 && body.data) {
        campaignsList.value = body.data.items || [];
        totalItems.value = body.data.pagination?.total || 0;
        totalPages.value = body.data.pagination?.totalPages || 1;
        return body.data;
      }
      throw new Error(body.msg || 'Failed to load your campaigns');
    } catch (err: any) {
      error.value = err.message || 'An error occurred';
      throw err;
    } finally {
      isLoading.value = false;
    }
  }

  async function fetchAdminCampaignUsers(options: { page?: number; search?: string } = {}) {
    isLoading.value = true;
    error.value = null;
    try {
      const response = await api.action.$post({ json: { action: 'campaigns/admin-users', data: options } });
      const body = await response.json();
      if (!response.ok || body.code !== 1 || !body.data) throw new Error(body.msg || 'Failed to load users');
      return body.data as { items: AdminCampaignUser[]; total: number; totalPages: number };
    } catch (err: any) {
      error.value = err.message || 'An error occurred';
      throw err;
    } finally {
      isLoading.value = false;
    }
  }

  async function fetchAdminUserCampaigns(userId: string, page = 1) {
    isLoading.value = true;
    error.value = null;
    try {
      const response = await api.action.$post({
        json: { action: 'campaigns/admin-user-campaigns', data: { userId, page } },
      });
      const body = await response.json();
      if (!response.ok || body.code !== 1 || !body.data) throw new Error(body.msg || 'Failed to load user campaigns');
      return body.data as { items: CampaignData[]; total: number; totalPages: number };
    } catch (err: any) {
      error.value = err.message || 'An error occurred';
      throw err;
    } finally {
      isLoading.value = false;
    }
  }

  /**
   * Get single campaign by ID
   */
  async function getCampaign(id: string): Promise<CampaignData> {
    isLoading.value = true;
    error.value = null;

    try {
      const response = await api.action.$post({
        json: {
          action: "campaigns/get",
          data: { id },
        },
      });

      const body = await response.json();
      if (response.ok && body.code === 1 && body.data) {
        return body.data;
      } else {
        throw new Error(body.msg || "Failed to fetch campaign details");
      }
    } catch (err: any) {
      error.value = err.message || "An error occurred";
      throw err;
    } finally {
      isLoading.value = false;
    }
  }

  /**
   * Create new campaign
   */
  async function createCampaign(input: CampaignFormInput): Promise<CampaignData> {
    isLoading.value = true;
    error.value = null;

    try {
      const response = await api.action.$post({
        json: {
          action: "campaigns/create",
          data: input,
        },
      });

      const body = await response.json();
      if (response.ok && body.code === 1 && body.data) {
        return body.data;
      } else {
        throw new Error(body.msg || "Failed to create campaign");
      }
    } catch (err: any) {
      error.value = err.message || "An error occurred";
      throw err;
    } finally {
      isLoading.value = false;
    }
  }

  /**
   * Update existing campaign
   */
  async function updateCampaign(
    id: string,
    input: Partial<CampaignFormInput>
  ): Promise<CampaignData> {
    isLoading.value = true;
    error.value = null;

    try {
      const response = await api.action.$post({
        json: {
          action: "campaigns/update",
          data: { id, ...input },
        },
      });

      const body = await response.json();
      if (response.ok && body.code === 1 && body.data) {
        return body.data;
      } else {
        throw new Error(body.msg || "Failed to update campaign");
      }
    } catch (err: any) {
      error.value = err.message || "An error occurred";
      throw err;
    } finally {
      isLoading.value = false;
    }
  }

  /**
   * Update status only (DRAFT <-> PUBLIC)
   */
  async function updateCampaignStatus(
    id: string,
    status: "DRAFT" | "PUBLIC"
  ): Promise<CampaignData> {
    isLoading.value = true;
    error.value = null;

    try {
      const response = await api.action.$post({
        json: {
          action: "campaigns/update-status",
          data: { id, status },
        },
      });

      const body = await response.json();
      if (response.ok && body.code === 1 && body.data) {
        return body.data;
      } else {
        throw new Error(body.msg || "Failed to update campaign status");
      }
    } catch (err: any) {
      error.value = err.message || "An error occurred";
      throw err;
    } finally {
      isLoading.value = false;
    }
  }

  /**
   * Soft delete campaign
   */
  async function deleteCampaign(id: string) {
    isLoading.value = true;
    error.value = null;

    try {
      const response = await api.action.$delete({
        json: {
          action: "campaigns/delete",
          data: { id },
        },
      });

      const body = await response.json();
      if (response.ok && body.code === 1) {
        campaignsList.value = campaignsList.value.filter((c) => c.id !== id);
        return true;
      } else {
        throw new Error(body.msg || "Failed to delete campaign");
      }
    } catch (err: any) {
      error.value = err.message || "An error occurred";
      throw err;
    } finally {
      isLoading.value = false;
    }
  }

  return {
    campaignsList,
    totalItems,
    totalPages,
    isLoading,
    error,
    fetchCampaigns,
    fetchMyCampaigns,
    fetchAdminCampaignUsers,
    fetchAdminUserCampaigns,
    getCampaign,
    createCampaign,
    updateCampaign,
    updateCampaignStatus,
    deleteCampaign,
  };
}
