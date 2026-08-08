const GOOGLE_TRANSLATE_ENDPOINT = "https://translate.googleapis.com/translate_a/single";

type GoogleTranslateSentence = [string?, string?, ...unknown[]];
type GoogleTranslateResponse = [GoogleTranslateSentence[]?, ...unknown[]];

function normalizeTargetLanguage(target: string) {
  if (target === "zh") return "zh-CN";
  return target;
}

export async function translateManyWithGoogleTranslate(texts: string[], target: string): Promise<string[]> {
  if (texts.length === 0) return [];

  const BATCH_SIZE = 40;
  const results: string[] = new Array(texts.length);

  for (let i = 0; i < texts.length; i += BATCH_SIZE) {
    const batch = texts.slice(i, i + BATCH_SIZE);

    try {
      const body = new URLSearchParams();
      body.append("client", "gtx");
      body.append("sl", "auto");
      body.append("tl", normalizeTargetLanguage(target));
      body.append("dt", "t");
      body.append("q", batch.join("\n"));

      const response = await fetch(GOOGLE_TRANSLATE_ENDPOINT, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        },
        body: body.toString(),
      });

      if (!response.ok) {
        console.error(`Google Translate HTTP ${response.status} for batch at ${i}`);
        batch.forEach((text, index) => {
          results[i + index] = text;
        });
        continue;
      }

      const data = (await response.json()) as GoogleTranslateResponse;
      const sentences = data[0] || [];

      batch.forEach((text, index) => {
        const sentence = sentences[index];
        const translated = sentence && sentence[0] ? sentence[0].replace(/\n$/, "").trim() : text;
        results[i + index] = translated || text;
      });
    } catch (err) {
      console.error("Translation batch error:", err);
      batch.forEach((text, index) => {
        results[i + index] = text;
      });
    }
  }

  return results;
}


