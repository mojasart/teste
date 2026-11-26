import { reactive } from 'vue'

export class ApiError extends Error {
  constructor(message, status, fields = {}) {
    super(message)
    this.status = status
    this.fields = fields
  }
}

export const admin = reactive({
  user: null,
  async check() {
    if (this.user) return true
    try {
      this.user = await api('/admin/me')
      return true
    } catch {
      return false
    }
  },
})

export async function api(path, opts = {}) {
  if (import.meta.env.VITE_DEMO) return (await import('./demo/demoApi.js')).demoApi(path, opts)
  return realApi(path, opts)
}

async function realApi(path, { method = 'GET', body, form } = {}) {
  const headers = {}
  if (body !== undefined) headers['Content-Type'] = 'application/json'
  if (method !== 'GET' && admin.user) headers['X-CSRF-Token'] = admin.user.csrf
  let res
  try {
    res = await fetch('/api' + path, {
      method,
      headers,
      credentials: 'same-origin',
      body: form ?? (body !== undefined ? JSON.stringify(body) : undefined),
    })
  } catch {
    throw new ApiError('Sem conexão com o servidor. Confira sua internet e tente de novo.', 0)
  }
  const data = await res.json().catch(() => ({}))
  if (!res.ok) {
    if (res.status === 401) admin.user = null
    throw new ApiError(data.error || 'Algo deu errado. Tente de novo.', res.status, data.fields || {})
  }
  return data
}

// textos editáveis do site, carregados uma vez
export const site = reactive({ settings: null })
let settingsPromise
export function loadSettings() {
  settingsPromise ??= api('/settings')
    .then((s) => (site.settings = s))
    .catch(() => (site.settings = {}))
  return settingsPromise
}
export function refreshSettings(s) {
  site.settings = s
}

export function paragraphs(text = '') {
  return text.split(/\n\s*\n/).map((p) => p.trim()).filter(Boolean)
}

export function youtubeId(url = '') {
  const m = url.match(/(?:youtu\.be\/|v=|embed\/|shorts\/)([\w-]{11})/)
  return m ? m[1] : null
}

export function formatDate(iso) {
  if (!iso) return ''
  const [y, m, d] = iso.split('-').map(Number)
  return new Date(y, m - 1, d).toLocaleDateString('pt-BR', { day: 'numeric', month: 'long', year: 'numeric' })
}
