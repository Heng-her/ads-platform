const CHANNEL_COLORS: Record<string, { color: string; bg: string; border: string; icon: string }> = {
  BUSINESS: { color: "#f5a524", bg: "rgba(245, 165, 36, 0.15)", border: "rgba(245, 165, 36, 0.35)", icon: "i-lucide-briefcase" },
  FINANCE: { color: "#f5a524", bg: "rgba(245, 165, 36, 0.15)", border: "rgba(245, 165, 36, 0.35)", icon: "i-lucide-trending-up" },
  NEWS: { color: "#2dd4bf", bg: "rgba(45, 212, 191, 0.15)", border: "rgba(45, 212, 191, 0.35)", icon: "i-lucide-newspaper" },
  TECHNOLOGY: { color: "#38bdf8", bg: "rgba(56, 189, 248, 0.15)", border: "rgba(56, 189, 248, 0.35)", icon: "i-lucide-zap" },
  SPORTS: { color: "#f87171", bg: "rgba(248, 113, 113, 0.15)", border: "rgba(248, 113, 113, 0.35)", icon: "i-lucide-trophy" },
  ENTERTAINMENT: { color: "#c084fc", bg: "rgba(192, 132, 252, 0.15)", border: "rgba(192, 132, 252, 0.35)", icon: "i-lucide-film" },
  DESIGN: { color: "#f472b6", bg: "rgba(244, 114, 182, 0.15)", border: "rgba(244, 114, 182, 0.35)", icon: "i-lucide-palette" },
  ARTICLE: { color: "#38bdf8", bg: "rgba(56, 189, 248, 0.15)", border: "rgba(56, 189, 248, 0.35)", icon: "i-lucide-file-text" },
  SPONSORED: { color: "#fbbf24", bg: "rgba(251, 191, 36, 0.18)", border: "rgba(251, 191, 36, 0.4)", icon: "i-lucide-megaphone" },
  BANNER: { color: "#34d399", bg: "rgba(52, 211, 153, 0.15)", border: "rgba(52, 211, 153, 0.35)", icon: "i-lucide-image" },
  VIDEO: { color: "#a855f7", bg: "rgba(168, 85, 247, 0.15)", border: "rgba(168, 85, 247, 0.35)", icon: "i-lucide-video" },
  NATIVE: { color: "#818cf8", bg: "rgba(129, 140, 248, 0.15)", border: "rgba(129, 140, 248, 0.35)", icon: "i-lucide-pin" },
};

/**
 * Deterministic color per category/content-type name.
 */
export function channelColor(name: string | null | undefined): string {
  if (!name) return "#8890a6";
  const upper = name.toUpperCase();
  if (CHANNEL_COLORS[upper]) return CHANNEL_COLORS[upper].color;
  
  let hash = 0;
  for (let i = 0; i < name.length; i++) {
    hash = name.charCodeAt(i) + ((hash << 5) - hash);
  }
  const hue = Math.abs(hash) % 360;
  return `hsl(${hue} 70% 60%)`;
}

/**
 * Returns full style token (color, background, border, icon) for a category or content type.
 */
export function channelStyle(name: string | null | undefined) {
  if (!name) {
    return {
      color: "#8890a6",
      background: "rgba(136, 144, 166, 0.15)",
      borderColor: "rgba(136, 144, 166, 0.3)",
      icon: "i-lucide-tag",
    };
  }

  const upper = name.toUpperCase();
  if (CHANNEL_COLORS[upper]) {
    const item = CHANNEL_COLORS[upper];
    return {
      color: item.color,
      background: item.bg,
      borderColor: item.border,
      icon: item.icon,
    };
  }

  const color = channelColor(name);
  return {
    color,
    background: "rgba(45, 212, 191, 0.12)",
    borderColor: "rgba(45, 212, 191, 0.3)",
    icon: "i-lucide-tag",
  };
}
