import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const DOMAIN = process.env.SITE_URL || 'https://ads-platform.crypten.workers.dev';

const routes = [
  { url: '/', priority: '1.0', changefreq: 'daily' },
  { url: '/explore', priority: '0.9', changefreq: 'daily' },
  { url: '/news', priority: '0.9', changefreq: 'daily' },
  { url: '/trending', priority: '0.9', changefreq: 'daily' },
  { url: '/article', priority: '0.9', changefreq: 'daily' },
  { url: '/advertisers', priority: '0.8', changefreq: 'weekly' },
  { url: '/ai', priority: '0.8', changefreq: 'weekly' },
  { url: '/finance', priority: '0.8', changefreq: 'weekly' },
  { url: '/formats', priority: '0.8', changefreq: 'weekly' },
  { url: '/pricing', priority: '0.8', changefreq: 'weekly' },
  { url: '/terms', priority: '0.5', changefreq: 'monthly' },
  { url: '/login', priority: '0.4', changefreq: 'monthly' },
  { url: '/register', priority: '0.4', changefreq: 'monthly' }
];

function generateSitemap() {
  const currentDate = new Date().toISOString().split('T')[0];

  const urlEntries = routes
    .map(
      (route) => `  <url>
    <loc>${DOMAIN}${route.url}</loc>
    <lastmod>${currentDate}</lastmod>
    <changefreq>${route.changefreq}</changefreq>
    <priority>${route.priority}</priority>
  </url>`
    )
    .join('\n');

  const xmlContent = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urlEntries}
</urlset>`;

  const outputPath = path.resolve(__dirname, '../public/sitemap.xml');
  fs.writeFileSync(outputPath, xmlContent.trim(), 'utf8');
  console.log(`[Sitemap] Successfully generated sitemap.xml at ${outputPath}`);
}

generateSitemap();
