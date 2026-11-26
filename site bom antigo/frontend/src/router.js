import { createMemoryHistory, createRouter, createWebHistory } from 'vue-router'
import { admin } from './api.js'

const routes = [
  { path: '/', component: () => import('./views/Home.vue') },
  { path: '/projects', component: () => import('./views/Projects.vue'), meta: { title: 'Projects' } },
  { path: '/projects/:slug', component: () => import('./views/Project.vue') },
  { path: '/about', component: () => import('./views/About.vue'), meta: { title: 'About' } },
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
  // a demonstração roda dentro de uma página sem servidor: navegação em memória
  history: import.meta.env.VITE_DEMO ? createMemoryHistory() : createWebHistory('/'),
  routes,
  scrollBehavior: (to, from, saved) => saved || (to.path !== from.path ? { top: 0 } : undefined),
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
})
