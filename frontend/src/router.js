import { createRouter, createWebHistory } from 'vue-router'
import { findAddon, site } from './content.js'

const routes = [
  { path: '/', component: () => import('./views/Home.vue') },
  {
    path: '/addons/:slug',
    component: () => import('./views/Addon.vue'),
    beforeEnter: (to) => (findAddon(to.params.slug) ? true : { name: 'missing', params: { rest: to.path.split('/').filter(Boolean) } }),
  },
  { path: '/contact', component: () => import('./views/Contact.vue'), meta: { title: 'Contact' } },
  { path: '/:rest(.*)*', name: 'missing', component: () => import('./views/NotFound.vue'), meta: { title: 'Page not found' } },
]

export const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
  scrollBehavior(to, from, saved) {
    if (saved) return saved
    if (to.hash) return { el: to.hash, behavior: 'smooth', top: 12 }
    if (to.path !== from.path) return { top: 0 }
  },
})

router.afterEach((to) => {
  const addon = to.params.slug && findAddon(to.params.slug)
  const t = addon ? addon.title : to.meta.title
  document.title = t ? `${t} | ${site.name}` : `${site.name} | Minecraft add-ons`
})
