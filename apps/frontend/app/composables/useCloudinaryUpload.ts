import { ref } from "vue";
import { useAuthStore } from "~/stores/auth";

export interface CloudinaryUploadResponse {
  publicId: string;
  url: string;
  resourceType: "image" | "video" | "raw";
  width?: number;
  height?: number;
  duration?: number;
  format: string;
  bytes: number;
  createdAt: string;
}

export interface CloudinaryErrorResponse {
  error: string;
}

export function useCloudinaryUpload() {
  const config = useRuntimeConfig();
  const authStore = useAuthStore();

  const isUploading = ref(false);
  const uploadProgress = ref(0);
  const errorMessage = ref<string | null>(null);

  const baseUrl =
    (config.public as any)?.cloudinaryBaseUrl ||
    "https://api-upload-image-8ym9.onrender.com";
  const apiKey = (config.public as any)?.cloudinaryApiKey || "crypten-api-key";
  const bypassSecret = (config.public as any)?.cloudinaryBypassSecret || "";

  const isAdmin = computed(() => authStore.user?.role === "admin");

  /**
   * Upload image or video to Cloudinary API
   */
  async function uploadMedia(
    file: File,
    folder: string = "campaigns",
  ): Promise<CloudinaryUploadResponse> {
    isUploading.value = true;
    uploadProgress.value = 0;
    errorMessage.value = null;

    const isVideo = file.type.startsWith("video/");
    const isImage = file.type.startsWith("image/");

    if (!isImage && !isVideo) {
      isUploading.value = false;
      throw new Error(
        "Unsupported file type. Please upload an image or video.",
      );
    }

    // 50MB check for non-admin (50 * 1024 * 1024 bytes)
    const MAX_CREATOR_SIZE = 50 * 1024 * 1024; // 50MB
    const MAX_ADMIN_SIZE = 2000 * 1024 * 1024; // 2GB

    const maxSize = isAdmin.value ? MAX_ADMIN_SIZE : MAX_CREATOR_SIZE;
    if (file.size > maxSize) {
      isUploading.value = false;
      const sizeMB = (file.size / (1024 * 1024)).toFixed(1);
      const limitMB = isAdmin.value ? "2000MB" : "50MB";
      const err = `File size (${sizeMB}MB) exceeds limit of ${limitMB}.`;
      errorMessage.value = err;
      throw new Error(err);
    }

    const fieldName = isVideo ? "video" : "image";
    const formData = new FormData();
    formData.append(fieldName, file);

    const headers: Record<string, string> = {
      "x-api-key": apiKey,
    };

    // If Admin, inject x-api-bypass header for unlimited upload / size limit bypass
    if (isAdmin.value && bypassSecret) {
      headers["x-api-bypass"] = bypassSecret;
    }

    try {
      const response = await fetch(`${baseUrl}/api/${folder}`, {
        method: "POST",
        headers,
        body: formData,
      });

      if (!response.ok) {
        let errJson: CloudinaryErrorResponse | null = null;
        try {
          errJson = await response.json();
        } catch {
          // ignore parse error
        }
        const message =
          errJson?.error || `Upload failed with status ${response.status}`;
        errorMessage.value = message;
        throw new Error(message);
      }

      const data: CloudinaryUploadResponse = await response.json();
      uploadProgress.value = 100;
      return data;
    } catch (err: any) {
      errorMessage.value = err.message || "Upload failed";
      throw err;
    } finally {
      isUploading.value = false;
    }
  }

  /**
   * Delete uploaded media from Cloudinary
   */
  async function deleteMedia(publicId: string, isVideo = false) {
    errorMessage.value = null;
    const endpoint = isVideo ? "videos" : "images";

    const headers: Record<string, string> = {
      "x-api-key": apiKey,
    };

    if (isAdmin.value && bypassSecret) {
      headers["x-api-bypass"] = bypassSecret;
    }

    try {
      const encodedId = encodeURIComponent(publicId);
      const response = await fetch(`${baseUrl}/api/${endpoint}/${encodedId}`, {
        method: "DELETE",
        headers,
      });

      if (!response.ok) {
        let errJson: CloudinaryErrorResponse | null = null;
        try {
          errJson = await response.json();
        } catch {
          // ignore
        }
        throw new Error(errJson?.error || "Delete failed");
      }

      return await response.json();
    } catch (err: any) {
      errorMessage.value = err.message || "Delete failed";
      throw err;
    }
  }

  return {
    uploadMedia,
    deleteMedia,
    isUploading,
    uploadProgress,
    errorMessage,
    isAdmin,
  };
}
