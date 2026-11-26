import { createApp } from 'vue'
import '@fontsource-variable/bricolage-grotesque/standard.css'
import './styles.css'
import App from './App.vue'
import { router } from './router.js'

const app = createApp(App).use(router)

// v-reveal: o elemento "é colocado" como um bloco quando entra na tela
const io =
  'IntersectionObserver' in window
    ? new IntersectionObserver(
        (entries) => {
          for (const e of entries) {
            if (e.isIntersecting) {
              e.target.classList.add('is-placed')
              io.unobserve(e.target)
            }
          }
        },
        { rootMargin: '0px 0px -8% 0px' }
      )
    : null
app.directive('reveal', {
  mounted(el, { value = 0 }) {
    if (!io) return
    el.style.setProperty('--delay', `${value * 90}ms`)
    el.classList.add('will-place')
    io.observe(el)
  },
  unmounted(el) {
    io?.unobserve(el)
  },
})

app.mount('#app')
