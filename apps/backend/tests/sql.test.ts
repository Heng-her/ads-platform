import { describe, it, expect } from "vitest";
import { buildSafeLikePattern } from "../src/utils/sql";

describe("buildSafeLikePattern", () => {
  it("returns '%' for empty or null search", () => {
    expect(buildSafeLikePattern("")).toBe("%");
    expect(buildSafeLikePattern(null)).toBe("%");
    expect(buildSafeLikePattern(undefined)).toBe("%");
  });

  it("safely bounds long strings to prevent Cloudflare D1 SQLITE_LIMIT_LIKE_PATTERN_LENGTH error", () => {
    const longTitle = "Traditional Khmer Vernacular Wooden Architecture: Phteah Rong Daol and Microclimate Cooling";
    const pattern = buildSafeLikePattern(longTitle, 40);

    expect(pattern.length).toBeLessThanOrEqual(42);
    expect(pattern.startsWith("%")).toBe(true);
    expect(pattern.endsWith("%")).toBe(true);
    expect(pattern).toBe("%Traditional Khmer Vernacular Wooden Arch%");
  });

  it("sanitizes wildcards like % and _", () => {
    const dangerousInput = "100%_guaranteed";
    const pattern = buildSafeLikePattern(dangerousInput);
    expect(pattern).toBe("%100  guaranteed%");
  });
});

