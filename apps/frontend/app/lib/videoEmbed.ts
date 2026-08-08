export function getVideoEmbedUrl(videoUrl: string): string | null {
  try {
    const url = new URL(videoUrl);
    const host = url.hostname.replace(/^www\./, "").toLowerCase();

    if (host === "youtu.be") {
      const videoId = url.pathname.split("/").filter(Boolean)[0];
      return videoId ? `https://www.youtube-nocookie.com/embed/${videoId}` : null;
    }

    if (host === "youtube.com" || host.endsWith(".youtube.com")) {
      const videoId = url.searchParams.get("v") || url.pathname.match(/^\/(?:shorts|embed)\/([^/?]+)/)?.[1];
      return videoId ? `https://www.youtube-nocookie.com/embed/${videoId}` : null;
    }

    if (host === "tiktok.com" || host.endsWith(".tiktok.com")) {
      const videoId = url.pathname.match(/\/video\/(\d+)/)?.[1];
      return videoId ? `https://www.tiktok.com/embed/v2/${videoId}` : null;
    }
  } catch {
    return null;
  }

  return null;
}
