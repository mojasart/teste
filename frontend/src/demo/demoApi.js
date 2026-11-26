// Dados fixos para a demonstração sem servidor (gerados a partir da API).
import { ApiError } from '../api.js'
import addons from './addons.json'
import categories from './categories.json'
import settings from './settings.json'

// imagens ficam ao lado da página: /media/x.webp → media/x.webp
const rel = (u) => (u ? u.replace(/^\//, '') : u)
const fix = (a) => ({
  ...a,
  cover_image: rel(a.cover_image),
  banner_image: rel(a.banner_image),
  trailer_url: a.trailer_url.startsWith('/') ? rel(a.trailer_url) : a.trailer_url,
  gallery: a.gallery.map((g) => ({ ...g, src: rel(g.src), thumb: rel(g.thumb) })),
})
const list = addons.map(fix)

export async function demoApi(path, { method = 'GET' } = {}) {
  const [route, query = ''] = path.split('?')
  if (route.startsWith('/admin')) {
    throw new ApiError('O painel fica desligado nesta demonstração.', 403)
  }
  if (method === 'POST' && route === '/contact') return { ok: true }
  if (route === '/addons') {
    const cat = new URLSearchParams(query).get('category')
    return cat ? list.filter((a) => a.category?.slug === cat) : list
  }
  if (route.startsWith('/addons/')) {
    const a = list.find((x) => x.slug === decodeURIComponent(route.slice(8)))
    if (!a) throw new ApiError('Projeto não encontrado.', 404)
    return a
  }
  if (route === '/categories') return categories
  if (route === '/settings') return settings
  throw new ApiError('Rota não encontrada.', 404)
}
