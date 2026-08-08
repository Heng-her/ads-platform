import { computed, ref } from "vue";
import { useApi } from "~/composables/useApi";
import { useAuthStore } from "~/stores/auth";

export interface CloudinaryUploadResponse {
  publicId: string;
  url: string;
  /** Original browser filename, retained locally for form labels/metadata. */
  originalFilename?: string;
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

export interface CloudinaryMediaInfo {
  publicId: string;
  isVideo: boolean;
}

/**
 * Extract the Cloudinary public ID from a delivery URL.
 *
 * Campaigns currently persist delivery URLs rather than the upload response,
 * so this also lets edit forms delete media that was uploaded previously.
 */
export function getCloudinaryMediaInfo(url: string): CloudinaryMediaInfo | null {
  try {
    const parsedUrl = new URL(url);
    if (
      parsedUrl.hostname !== "cloudinary.com" &&
      !parsedUrl.hostname.endsWith(".cloudinary.com")
    ) {
      return null;
    }

    const pathSegments = parsedUrl.pathname.split("/").filter(Boolean);
    const uploadIndex = pathSegments.indexOf("upload");
    if (uploadIndex === -1 || uploadIndex === pathSegments.length - 1) {
      return null;
    }

    const uploadTail = pathSegments.slice(uploadIndex + 1);
    const versionIndex = uploadTail.findIndex((segment) => /^v\d+$/.test(segment));
    const assetSegments =
      versionIndex >= 0 ? uploadTail.slice(versionIndex + 1) : uploadTail;

    // A version is expected for Cloudinary upload URLs. Without one, accept
    // only a path that does not look like a transformation expression.
    if (versionIndex < 0 && assetSegments.some((segment) => segment.includes("_"))) {
      return null;
    }

    const encodedPublicId = assetSegments.join("/");
    if (!encodedPublicId) return null;

    const publicId = decodeURIComponent(encodedPublicId).replace(
      /\.[^/.]+$/,
      "",
    );

    return {
      publicId,
      isVideo: pathSegments[uploadIndex - 1] === "video",
    };
  } catch {
    return null;
  }
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
  const isAdmin = computed(() => authStore.user?.role === "admin");
  const api = useApi();

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

    try {
      const response = isAdmin.value
        ? await api.media.upload.$post({
            query: { folder },
            body: formData,
          })
        : await fetch(`${baseUrl}/api/${folder}`, {
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
      return {
        ...data,
        // The API response does not include the browser's original filename.
        // Keep it on the client so forms can use it for default metadata.
        originalFilename: file.name,
      };
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

  /**
   * Delete a media asset using its Cloudinary delivery URL. For direct URLs
   * from another provider, there is no Cloudinary asset to delete.
   */
  async function deleteMediaByUrl(url: string, isVideo?: boolean) {
    const mediaInfo = getCloudinaryMediaInfo(url);
    if (!mediaInfo) return { skipped: true };

    return deleteMedia(mediaInfo.publicId, isVideo ?? mediaInfo.isVideo);
  }

  return {
    uploadMedia,
    deleteMedia,
    deleteMediaByUrl,
    isUploading,
    uploadProgress,
    errorMessage,
    isAdmin,
  };
}
