import sanitizeHtml from "sanitize-html";

/**
 * Sanitizes campaign rich-text content to prevent Stored XSS attacks.
 * Allows safe HTML formatting, images, video embeds, links, Tailwind CSS classes,
 * and inline styles while stripping dangerous script tags, event handlers, and javascript: URLs.
 */
export function sanitizeArticleContent(rawHtml: string): string {
  if (!rawHtml) return "";

  return sanitizeHtml(rawHtml, {
    allowedTags: [
      "h1",
      "h2",
      "h3",
      "h4",
      "h5",
      "h6",
      "p",
      "br",
      "hr",
      "span",
      "div",
      "blockquote",
      "pre",
      "code",
      "ul",
      "ol",
      "li",
      "b",
      "i",
      "strong",
      "em",
      "strike",
      "s",
      "del",
      "u",
      "mark",
      "sub",
      "sup",
      "a",
      "img",
      "video",
      "source",
      "iframe",
    ],
    allowedAttributes: {
      a: ["href", "target", "rel", "class", "title"],
      img: ["src", "alt", "title", "class", "width", "height", "loading"],
      video: [
        "src",
        "controls",
        "autoplay",
        "muted",
        "loop",
        "preload",
        "class",
        "width",
        "height",
      ],
      source: ["src", "type"],
      iframe: [
        "src",
        "title",
        "class",
        "allow",
        "allowfullscreen",
        "frameborder",
        "width",
        "height",
      ],
      "*": ["class", "style"],
    },
    allowedSchemes: ["http", "https", "mailto", "tel", "data"],
    allowedSchemesByTag: {
      img: ["http", "https", "data"],
      video: ["http", "https", "data"],
      iframe: ["http", "https"],
    },
    allowedStyles: {
      "*": {
        color: [
          /^#(?:[0-9a-f]{3}){1,2}$/i,
          /^#(?:[0-9a-f]{4}){1,2}$/i,
          /^rgb\(/i,
          /^rgba\(/i,
          /^hsl\(/i,
          /^hsla\(/i,
          /^[a-z]+$/i,
        ],
        "background-color": [
          /^#(?:[0-9a-f]{3}){1,2}$/i,
          /^#(?:[0-9a-f]{4}){1,2}$/i,
          /^rgb\(/i,
          /^rgba\(/i,
          /^hsl\(/i,
          /^hsla\(/i,
          /^[a-z]+$/i,
        ],
        "font-size": [/^\d+(?:\.\d+)?(?:px|em|rem|%)$/i],
        "text-align": [/^(?:left|center|right|justify)$/i],
        "text-decoration": [/^(?:none|underline|line-through)$/i],
      },
    },
    transformTags: {
      a: (tagName, attribs) => ({
        tagName: "a",
        attribs: {
          ...attribs,
          target: "_blank",
          rel: "noopener noreferrer nofollow",
        },
      }),
    },
  });
}
