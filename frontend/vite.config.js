import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { cpSync, existsSync, readFileSync, writeFileSync, mkdirSync, statSync, createReadStream } from 'node:fs'
import { join, resolve, extname } from 'node:path'

// Site estático:
//  - as imagens vêm direto de ../imagens, servidas em /media
//  - cada página ganha seu próprio index.html (título, descrição e prévia para redes sociais)
//  - sitemap.xml, robots.txt e 404.html são gerados no build
// BASE: caminho onde o site fica ('/' com domínio próprio, '/teste/' no GitHub Pages sem domínio)

const MEDIA = resolve(__dirname, '../imagens')
const SKIP = ['antigas', 'fonts', 'social', 'gallery.json', 'assets (1).zip']
const site = JSON.parse(readFileSync('src/content/site.json', 'utf8'))
// endereço final do site (para links de prévia e sitemap); o deploy pode trocar via SITE_URL
if (process.env.SITE_URL) site.url = process.env.SITE_URL
const addons = JSON.parse(readFileSync('src/content/addons.json', 'utf8'))

const esc = (s) => String(s).replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/</g, '&lt;')

function pages(base) {
  const url = (p) => site.url.replace(/\/$/, '') + p
  const img = (p) => url('/' + p)
  return [
    { path: '/', title: `${site.name} | Minecraft add-ons`, desc: site.description, image: img(addons.premium[0].hero) },
    { path: '/contact/', title: `Contact | ${site.name}`, desc: 'Partnerships, custom add-ons and support.', image: img(addons.premium[0].hero) },
    ...addons.premium.map((a) => ({
      path: `/addons/${a.slug}/`,
      title: `${a.title} | ${site.name}`,
      desc: a.tagline,
      image: img(a.keyart),
    })),
  ].map((p) => ({ ...p, canonical: url(p.path) }))
}

function staticSite() {
  let base = '/'
  let outDir = 'dist'
  return {
    name: 'purplebyte-static',
    configResolved(c) {
      base = c.base
      outDir = c.build.outDir
    },
    // dev: /media/... lê de ../imagens
    configureServer(server) {
      const types = { '.webp': 'image/webp', '.png': 'image/png', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg', '.svg': 'image/svg+xml', '.mp4': 'video/mp4' }
      server.middlewares.use((req, res, next) => {
        const m = req.url.split('?')[0].match(/^(?:.*?)\/media\/(.+)$/)
        if (!m) return next()
        const file = resolve(MEDIA, decodeURIComponent(m[1]))
        if (!file.startsWith(MEDIA) || !existsSync(file) || !statSync(file).isFile()) return next()
        res.setHeader('Content-Type', types[extname(file).toLowerCase()] || 'application/octet-stream')
        createReadStream(file).pipe(res)
      })
    },
    closeBundle() {
      const out = resolve(outDir)
      cpSync(MEDIA, join(out, 'media'), { recursive: true, filter: (src) => !SKIP.some((s) => src === join(MEDIA, s)) })

      const shell = readFileSync(join(out, 'index.html'), 'utf8')
      for (const p of pages(base)) {
        const head = [
          `<title>${esc(p.title)}</title>`,
          `<meta name="description" content="${esc(p.desc)}" />`,
          `<link rel="canonical" href="${esc(p.canonical)}" />`,
          `<meta property="og:type" content="website" />`,
          `<meta property="og:site_name" content="${esc(site.name)}" />`,
          `<meta property="og:title" content="${esc(p.title)}" />`,
          `<meta property="og:description" content="${esc(p.desc)}" />`,
          `<meta property="og:url" content="${esc(p.canonical)}" />`,
          `<meta property="og:image" content="${esc(p.image)}" />`,
          `<meta name="twitter:card" content="summary_large_image" />`,
        ].join('\n    ')
        const html = shell.replace(/<title>[\s\S]*?<!--\/seo-->/, head)
        const dir = join(out, p.path)
        mkdirSync(dir, { recursive: true })
        writeFileSync(join(dir, 'index.html'), html)
      }
      // GitHub Pages usa 404.html para endereços que não existem
      writeFileSync(join(out, '404.html'), shell)
      writeFileSync(
        join(out, 'sitemap.xml'),
        `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${pages(base)
          .map((p) => `  <url><loc>${p.canonical}</loc></url>`)
          .join('\n')}\n</urlset>\n`
      )
      writeFileSync(join(out, 'robots.txt'), `User-agent: *\nAllow: /\nSitemap: ${site.url.replace(/\/$/, '')}/sitemap.xml\n`)
      writeFileSync(join(out, '.nojekyll'), '')
    },
  }
}

export default defineConfig({
  plugins: [vue(), staticSite()],
  base: process.env.BASE || '/',
  build: { outDir: 'dist', emptyOutDir: true },
})
