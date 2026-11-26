import { createApp } from 'vue'
import '@fontsource-variable/bricolage-grotesque/standard.css'
import './styles.css'
import App from './App.vue'
import { router } from './router.js'

createApp(App).use(router).mount('#app')
