/**
 * Safely constructs a SQLite LIKE pattern string bounded to maxLen characters.
 * Cloudflare D1 strictly enforces SQLITE_LIMIT_LIKE_PATTERN_LENGTH (~50 characters).
 * Passing longer strings causes:
 *   "D1_ERROR: LIKE or GLOB pattern too complex: SQLITE_ERROR"
 *
 * This utility trims, cleans wildcards, and bounds the pattern safely.
 */
export function buildSafeLikePattern(rawSearch: string | undefined | null, maxLen = 40): string {
  if (!rawSearch) return "%";
  // Replace SQL wildcard characters that might cause pattern compilation issues
  const cleaned = rawSearch.replace(/[%_]/g, " ").trim();
  if (!cleaned) return "%";
  // Bound to maxLen characters to guarantee D1 pattern limits
  const bounded = cleaned.length > maxLen ? cleaned.slice(0, maxLen).trim() : cleaned;
  return `%${bounded}%`;
}

