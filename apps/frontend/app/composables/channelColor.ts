/**
 * Deterministic color per category/content-type name.
 */
export function channelColor(name: string | null | undefined): string {
  if (!name) return "#8890a6";
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
  const color = channelColor(name);
  return {
    color,
    background: "rgba(45, 212, 191, 0.12)",
    borderColor: "rgba(45, 212, 191, 0.3)",
    icon: "i-lucide-tag",
  };
}
