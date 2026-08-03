import { useApi } from "~/composables/useApi";

export type CategoryItem = {
  id: number;
  name: string;
  createdAt: string | null;
};

/**
 * Shared category list. Uses useState so the data (and in-flight state) is
 * shared across every component that calls this — the layout's filter
 * dropdown and the campaigns page both use it without double-fetching.
 */
export function useCategories() {
  const categories = useState<CategoryItem[]>("categories", () => []);
  const isLoadingCategories = useState<boolean>(
    "categories-loading",
    () => false,
  );
  const hasFetched = useState<boolean>("categories-fetched", () => false);

  async function fetchCategories() {
    if (hasFetched.value || isLoadingCategories.value) return;
    isLoadingCategories.value = true;
    try {
      const api = useApi();
      const res = await api.categories.$get();
      const json: any = await res.json();
      if (json?.code === 1 && Array.isArray(json?.data)) {
        categories.value = json.data;
      }
      hasFetched.value = true;
    } catch (error) {
      console.error("[GET /categories] failed:", error);
    } finally {
      isLoadingCategories.value = false;
    }
  }

  return { categories, isLoadingCategories, fetchCategories };
}
