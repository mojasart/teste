import { createMemoryHistory, createRouter, createWebHistory } from 'vue-router'
import { admin } from './api.js'

const routes = [
  { path: '/', component: () => import('./views/Home.vue') },
  { path: '/addons/:slug', component: () => import('./views/Addon.vue') },
  { path: '/contact', component: () => import('./views/Contact.vue'), meta: { title: 'Contact' } },
  { path: '/admin/login', component: () => import('./views/admin/Login.vue'), meta: { admin: true, public: true, title: 'Entrar' } },
  {
    path: '/admin',
    component: () => import('./views/admin/AdminLayout.vue'),
    meta: { admin: true },
    children: [
      { path: '', component: () => import('./views/admin/AdminProjects.vue'), meta: { title: 'Projetos' } },
      { path: 'projetos/novo', component: () => import('./views/admin/AdminProjectEdit.vue'), meta: { title: 'Novo projeto' } },
      { path: 'projetos/:id', component: () => import('./views/admin/AdminProjectEdit.vue'), meta: { title: 'Editar projeto' } },
      { path: 'mensagens', component: () => import('./views/admin/AdminMessages.vue'), meta: { title: 'Mensagens' } },
      { path: 'textos', component: () => import('./views/admin/AdminSettings.vue'), meta: { title: 'Textos e links' } },
    ],
  },
  { path: '/:rest(.*)*', component: () => import('./views/NotFound.vue'), meta: { title: 'Page not found' } },
]

export const router = createRouter({
  // a demonstração (GitHub Pages) roda sem servidor: navegação em memória
  history: import.meta.env.VITE_DEMO ? createMemoryHistory() : createWebHistory('/'),
  routes,
  scrollBehavior(to, from, saved) {
    if (saved) return saved
    if (to.hash) return { el: to.hash, behavior: 'smooth' }
    if (to.path !== from.path) return { top: 0 }
  },
})

router.beforeEach(async (to) => {
  if (to.meta.admin && !to.meta.public) {
    const ok = await admin.check()
    if (!ok) return { path: '/admin/login', query: { voltar: to.fullPath } }
  }
})

router.afterEach((to) => {
  const t = to.meta.title
  document.title = t ? `${t} | PurpleByte Studios` : 'PurpleByte Studios'
  document.body.classList.toggle('site', !to.path.startsWith('/admin'))
})
