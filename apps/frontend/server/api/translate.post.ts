import { translateManyWithGoogleTranslate } from '../utils/googleTranslate';

const MAX_TEXTS_PER_REQUEST = 100;
const SUPPORTED_TARGETS = new Set<string>([
  "en", "km", "zh", "ja", "fr", "ko", "th", "vi", "lo", "my", "id", "ms", "hi", "tl"
]);

type TranslateRequestBody = {
  texts?: unknown;
  target?: unknown;
};

export default defineEventHandler(async (event) => {
  let body: TranslateRequestBody;

  try {
    body = (await readBody(event)) as TranslateRequestBody;
  } catch {
    throw createError({ statusCode: 400, statusMessage: "Invalid JSON request body." });
  }

  const texts = Array.isArray(body?.texts)
    ? body.texts.filter((text): text is string => typeof text === "string" && text.trim().length > 0)
    : [];
  const target = typeof body?.target === "string" ? body.target : "";

  if (!SUPPORTED_TARGETS.has(target)) {
    throw createError({ statusCode: 400, statusMessage: "Unsupported translation target." });
  }

  if (texts.length === 0) {
    return { translations: [] };
  }

  if (texts.length > MAX_TEXTS_PER_REQUEST) {
    throw createError({ statusCode: 413, statusMessage: `Translate up to ${MAX_TEXTS_PER_REQUEST} text values per request.` });
  }

  if (target === "en") {
    return { translations: texts };
  }

  try {
    const translations = await translateManyWithGoogleTranslate(texts, target);
    return { translations };
  } catch (error) {
    const name = error instanceof Error ? error.name : "UnknownError";
    const message = error instanceof Error ? error.message : "Unknown Google Translate error.";
    console.error(`Google Translate request failed: ${name}: ${message}`);

    // Return original texts as fallback so the page UI remains functional
    return { translations: texts };
  }
});

