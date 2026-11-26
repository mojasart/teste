import { createApp } from 'vue'
import '@fontsource/pixelify-sans/500.css'
import './styles.css'
import App from './App.vue'
import { router } from './router.js'

const app = createApp(App).use(router)

// v-reveal: o elemento sobe suave quando entra na tela
const io =
  'IntersectionObserver' in window
    ? new IntersectionObserver(
        (entries) => {
          for (const e of entries) {
            if (e.isIntersecting) {
              e.target.classList.add('is-in')
              io.unobserve(e.target)
            }
          }
        },
        { rootMargin: '0px 0px -6% 0px' }
      )
    : null

app.directive('reveal', {
  mounted(el, { value = 0 }) {
    if (!io) return
    el.style.setProperty('--delay', `${value * 90}ms`)
    el.classList.add('will-reveal')
    io.observe(el)
  },
  unmounted(el) {
    io?.unobserve(el)
  },
})

app.mount('#app')
