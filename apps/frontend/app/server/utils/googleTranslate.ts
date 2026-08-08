import https from "node:https";

const GOOGLE_TRANSLATE_ENDPOINT = "https://translate.googleapis.com/translate_a/single";

type GoogleTranslateSentence = [string?, string?, ...unknown[]];
type GoogleTranslateResponse = [GoogleTranslateSentence[]?, ...unknown[]];

function normalizeTargetLanguage(target: string) {
  if (target === "zh") return "zh-CN";
  return target;
}

function parseGoogleTranslateResponse(data: GoogleTranslateResponse) {
  return (data[0] || []).map((sentence) => sentence[0] || "").join("");
}

function requestGoogleTranslate(url: URL) {
  return new Promise<GoogleTranslateResponse>((resolve, reject) => {
    const request = https.request(
      url,
      {
        method: "GET",
        family: 4,
        headers: {
          "User-Agent": "Mozilla/5.0",
        },
        timeout: 15000,
      },
      (response) => {
        const chunks: Buffer[] = [];

        response.on("data", (chunk) => {
          chunks.push(Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk));
        });

        response.on("end", () => {
          const rawBody = Buffer.concat(chunks).toString("utf8");

          if (!response.statusCode || response.statusCode < 200 || response.statusCode >= 300) {
            reject(new Error(`Google Translate request failed with status ${response.statusCode || 500}.`));
            return;
          }

          try {
            resolve(JSON.parse(rawBody) as GoogleTranslateResponse);
          } catch {
            reject(new Error("Google Translate returned an invalid response."));
          }
        });
      }
    );

    request.on("timeout", () => {
      request.destroy(new Error("Google Translate request timed out."));
    });
    request.on("error", reject);
    request.end();
  });
}

export async function translateWithGoogleTranslate(text: string, target: string) {
  const trimmedText = text.trim();

  if (!trimmedText) return text;

  const url = new URL(GOOGLE_TRANSLATE_ENDPOINT);
  url.searchParams.set("client", "gtx");
  url.searchParams.set("sl", "auto");
  url.searchParams.set("tl", normalizeTargetLanguage(target));
  url.searchParams.set("dt", "t");
  url.searchParams.set("q", trimmedText);

  const data = await requestGoogleTranslate(url);
  const translatedText = parseGoogleTranslateResponse(data);

  return translatedText || text;
}

export async function translateManyWithGoogleTranslate(texts: string[], target: string) {
  return Promise.all(texts.map((text) => translateWithGoogleTranslate(text, target)));
}
