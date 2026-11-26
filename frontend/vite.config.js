import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// build: vai para backend/public/dist, servido pelo index.php
// dev:   npm run dev (porta 5173) + php -S na 8000 para a API
// demo: npm run build -- --mode demo → demo-dist/, sem PHP (dados de src/demo/)
export default defineConfig(({ command, mode }) => ({
  plugins: [vue()],
  base: mode === 'demo' ? './' : command === 'build' ? '/dist/' : '/',
  build: {
    outDir: mode === 'demo' ? 'demo-dist' : '../backend/public/dist',
    emptyOutDir: true,
  },
  server: {
    proxy: {
      '/api': 'http://127.0.0.1:8100',
      '/media': 'http://127.0.0.1:8100',
      '/uploads': 'http://127.0.0.1:8100',
    },
  },
}))
