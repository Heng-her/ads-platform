import { onMounted } from "vue";
import { useApi } from "~/composables/useApi";

export type CategoryItem = {
  id: number;
  name: string;
  createdAt: string | null;
};

/**
 * Shared category list composable. Always fetches from GET /api/categories
 * whenever categories state is empty.
 */
export function useCategories() {
  const categories = useState<CategoryItem[]>(
    "categories-shared-data",
    () => [],
  );
  const isLoadingCategories = useState<boolean>(
    "categories-loading-state",
    () => false,
  );

  async function fetchCategories(force = false) {
    if ((categories.value.length > 0 && !force) || isLoadingCategories.value)
      return;
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

  // Trigger fetch immediately if empty
  if (categories.value.length === 0 && !isLoadingCategories.value) {
    fetchCategories();
  }

  // On client side mount, ensure categories are loaded
  if (import.meta.client) {
    onMounted(() => {
      if (categories.value.length === 0) {
        fetchCategories();
      }
    });
  }

  return { categories, isLoadingCategories, fetchCategories };
}
