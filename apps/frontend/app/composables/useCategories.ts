import { onMounted } from "vue";
import { useApi } from "~/composables/useApi";

export type CategoryItem = {
  id: number;
  name: string;
  createdAt: string | null;
};

/**
 * Shared category list composable. Categories are loaded once in the browser and
 * retained in Nuxt state for the rest of the session.
 */
export function useCategories() {
  const categories = useState<CategoryItem[]>(
    "categories-shared-data",
    () => [],
  );
  // Loading state must be shared too: several components can use this composable
  // during the same page render.
  const isLoadingCategories = useState<boolean>(
    "categories-shared-loading",
    () => false,
  );

  async function fetchCategories(force = false) {
    if ((categories.value.length > 0 && !force) || isLoadingCategories.value) {
      return;
    }
    isLoadingCategories.value = true;
    try {
      const api = useApi();
      const res = await api.action.$post({
        json: { action: "categories/list" },
      });
      const json = (await res.json()) as {
        code: number;
        data?: CategoryItem[];
      };
      if (json?.code === 1 && Array.isArray(json?.data)) {
        categories.value = json.data;
      }
    } catch (error) {
      console.error("[POST /action categories/list] failed:", error);
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // Do not request during SSR: this asynchronous request is not awaited by SSR,
  // so hydration would request it again. Mounted components share the loading
  // guard above, leaving one request per refresh.
  if (import.meta.client) {
    onMounted(() => {
      if (categories.value.length === 0) {
        fetchCategories();
      }
    });
  }

  return { categories, isLoadingCategories, fetchCategories };
}
