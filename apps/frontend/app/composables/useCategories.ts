import { ref, onMounted } from "vue";
import { useApi } from "~/composables/useApi";

export type CategoryItem = {
  id: number;
  name: string;
  createdAt: string | null;
};

/**
 * Shared category list composable. Always fetches from POST /api/action { action: "categories/list" }
 * whenever categories state is empty.
 */
export function useCategories() {
  const categories = useState<CategoryItem[]>(
    "categories-shared-data",
    () => [],
  );
  // Use a local ref for loading state so it doesn't freeze at true during SSR state serialization
  const isLoadingCategories = ref(false);

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

  // Call fetchCategories during setup if empty
  if (categories.value.length === 0) {
    fetchCategories();
  }

  // Ensure categories are fetched on client mount if still empty
  if (import.meta.client) {
    onMounted(() => {
      if (categories.value.length === 0) {
        fetchCategories(true);
      }
    });
  }

  return { categories, isLoadingCategories, fetchCategories };
}
