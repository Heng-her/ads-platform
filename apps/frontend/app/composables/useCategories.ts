import { onMounted } from "vue";
import { useApi } from "~/composables/useApi";

export type CategoryItem = {
  id: number;
  name: string;
  createdAt: string | null;
};

export type CustomCategoryItem = CategoryItem & {
  userId?: string;
  userEmail?: string;
  username?: string;
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

  const myCategories = useState<CategoryItem[]>(
    "my-categories-shared-data",
    () => [],
  );
  const isLoadingMyCategories = useState<boolean>(
    "my-categories-shared-loading",
    () => false,
  );

  const allCustomCategories = useState<CustomCategoryItem[]>(
    "all-custom-categories-shared-data",
    () => [],
  );
  const isLoadingAllCustomCategories = useState<boolean>(
    "all-custom-categories-shared-loading",
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

  async function createCategory(name: string) {
    const api = useApi();
    const res = await api.action.$post({
      json: { action: "categories/create", data: { name } },
    });
    const json = (await res.json()) as {
      code: number;
      msg?: string;
      data?: CategoryItem;
    };
    if (json?.code === 1) {
      await fetchCategories(true);
    }
    return json;
  }

  async function updateCategory(id: number, name: string) {
    const api = useApi();
    const res = await api.action.$post({
      json: { action: "categories/update", data: { id, name } },
    });
    const json = (await res.json()) as {
      code: number;
      msg?: string;
      data?: CategoryItem;
    };
    if (json?.code === 1) {
      await fetchCategories(true);
    }
    return json;
  }

  async function deleteCategory(id: number) {
    const api = useApi();
    const res = await api.action.$post({
      json: { action: "categories/delete", data: { id } },
    });
    const json = (await res.json()) as { code: number; msg?: string };
    if (json?.code === 1) {
      await fetchCategories(true);
    }
    return json;
  }

  async function fetchMyCategories(force = false) {
    if (
      (myCategories.value.length > 0 && !force) ||
      isLoadingMyCategories.value
    ) {
      return;
    }
    isLoadingMyCategories.value = true;
    try {
      const api = useApi();
      const res = await api.action.$post({
        json: { action: "my/categories/list" },
      });
      const json = (await res.json()) as {
        code: number;
        data?: CategoryItem[];
      };
      if (json?.code === 1 && Array.isArray(json?.data)) {
        myCategories.value = json.data;
      }
    } catch (error) {
      console.error("[POST /action my/categories/list] failed:", error);
    } finally {
      isLoadingMyCategories.value = false;
    }
  }

  async function createMyCategory(name: string) {
    const api = useApi();
    const res = await api.action.$post({
      json: { action: "my/categories/create", data: { name } },
    });
    const json = (await res.json()) as {
      code: number;
      msg?: string;
      data?: CategoryItem;
    };
    if (json?.code === 1) {
      await fetchMyCategories(true);
    }
    return json;
  }

  async function updateMyCategory(id: number, name: string) {
    const api = useApi();
    const res = await api.action.$post({
      json: { action: "my/categories/update", data: { id, name } },
    });
    const json = (await res.json()) as {
      code: number;
      msg?: string;
      data?: CategoryItem;
    };
    if (json?.code === 1) {
      await fetchMyCategories(true);
    }
    return json;
  }

  async function deleteMyCategory(id: number) {
    const api = useApi();
    const res = await api.action.$post({
      json: { action: "my/categories/delete", data: { id } },
    });
    const json = (await res.json()) as { code: number; msg?: string };
    if (json?.code === 1) {
      await fetchMyCategories(true);
    }
    return json;
  }

  const allCategories = computed(() => {
    const list: CategoryItem[] = [];
    const seen = new Set<string>();

    for (const cat of myCategories.value) {
      if (cat.name && !seen.has(cat.name.toLowerCase())) {
        seen.add(cat.name.toLowerCase());
        list.push(cat);
      }
    }

    for (const cat of categories.value) {
      if (
        cat.name &&
        cat.name !== "OTHER" &&
        !seen.has(cat.name.toLowerCase())
      ) {
        seen.add(cat.name.toLowerCase());
        list.push(cat);
      }
    }

    return list;
  });

  // Do not request during SSR: this asynchronous request is not awaited by SSR,
  // so hydration would request it again. Mounted components share the loading
  // guard above, leaving one request per refresh.
  if (import.meta.client) {
    onMounted(() => {
      if (categories.value.length === 0) {
        fetchCategories();
      }
      if (myCategories.value.length === 0) {
        fetchMyCategories();
      }
    });
  }

  async function fetchAllCustomCategories(force = false) {
    if (
      (allCustomCategories.value.length > 0 && !force) ||
      isLoadingAllCustomCategories.value
    ) {
      return;
    }
    isLoadingAllCustomCategories.value = true;
    try {
      const api = useApi();
      const res = await api.action.$post({
        json: { action: "categories/all-custom-list" },
      });
      const json = (await res.json()) as {
        code: number;
        data?: CustomCategoryItem[];
      };
      if (json?.code === 1 && Array.isArray(json?.data)) {
        allCustomCategories.value = json.data;
      }
    } catch (error) {
      console.error("[POST /action categories/all-custom-list] failed:", error);
    } finally {
      isLoadingAllCustomCategories.value = false;
    }
  }

  async function deleteCustomCategoryByAdmin(id: number) {
    const api = useApi();
    const res = await api.action.$post({
      json: { action: "categories/delete-custom", data: { id } },
    });
    const json = (await res.json()) as { code: number; msg?: string };
    if (json?.code === 1) {
      await fetchAllCustomCategories(true);
    }
    return json;
  }

  return {
    categories,
    isLoadingCategories,
    fetchCategories,
    createCategory,
    updateCategory,
    deleteCategory,
    myCategories,
    isLoadingMyCategories,
    fetchMyCategories,
    createMyCategory,
    updateMyCategory,
    deleteMyCategory,
    allCustomCategories,
    isLoadingAllCustomCategories,
    fetchAllCustomCategories,
    deleteCustomCategoryByAdmin,
    allCategories,
  };
}
