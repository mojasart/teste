// Todo o conteúdo do site vem de src/content/*.json (edite lá).
import addonsData from './content/addons.json'
import siteData from './content/site.json'

// caminhos "media/..." viram endereços dentro do site (respeitando a pasta base)
export const asset = (p) => (!p || /^https?:\/\//.test(p) ? p : import.meta.env.BASE_URL + p)

const premium = addonsData.premium.map((a) => ({
  ...a,
  keyart: asset(a.keyart),
  hero: asset(a.hero),
  trailer: asset(a.trailer),
  gallery: a.gallery.map((g) => ({ ...g, src: asset(g.src), thumb: asset(g.thumb) })),
}))
// grátis sem página própria levam à lista de addons da PurpleByte no Vatonage
const free = addonsData.free.map((a) => ({ ...a, icon: asset(a.icon), link: a.link || siteData.freeMoreUrl }))

export const content = { premium, free }
export const site = siteData

export const findAddon = (slug) => premium.find((a) => a.slug === slug)

export function paragraphs(text = '') {
  return text.split(/\n\s*\n/).map((p) => p.trim()).filter(Boolean)
}

export function youtubeId(url = '') {
  const m = url.match(/(?:youtu\.be\/|v=|embed\/|shorts\/)([\w-]{11})/)
  return m ? m[1] : null
}
