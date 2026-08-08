type TranslationResponse = { data?: { translations?: Array<{ translatedText?: string }> }; error?: { message?: string } };

/** Google Cloud Translation v2 client. Its API key is kept only in the Worker. */
export class GoogleTranslateService {
  constructor(private apiKey?: string) {}

  async translate(values: Array<string | null | undefined>, source: string, target: string) {
    if (!this.apiKey) throw new Error("Google Translate is not configured. Add GOOGLE_TRANSLATE_API_KEY to the Worker secrets.");
    const present = values.map((value, index) => ({ index, value })).filter((item): item is { index: number; value: string } => Boolean(item.value));
    if (!present.length) return values.map(() => null);
    const response = await fetch(`https://translation.googleapis.com/language/translate/v2?key=${encodeURIComponent(this.apiKey)}`, {
      method: "POST", headers: { "content-type": "application/json" },
      body: JSON.stringify({ q: present.map((item) => item.value), source, target, format: "html" }),
    });
    const body = await response.json() as TranslationResponse;
    if (!response.ok) throw new Error(body.error?.message || "Google Translate request failed");
    const translated = values.map(() => null as string | null);
    for (const [position, item] of present.entries()) translated[item.index] = body.data?.translations?.[position]?.translatedText ?? null;
    return translated;
  }
}
