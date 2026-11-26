import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// build: vai para backend/public/dist, servido pelo index.php
// dev:   npm run dev (porta 5173) + php -S na 8000 para a API
export default defineConfig(({ command }) => ({
  plugins: [vue()],
  base: command === 'build' ? '/dist/' : '/',
  build: {
    outDir: '../backend/public/dist',
    emptyOutDir: true,
  },
  server: {
    proxy: {
      '/api': 'http://127.0.0.1:8000',
      '/media': 'http://127.0.0.1:8000',
      '/uploads': 'http://127.0.0.1:8000',
    },
  },
}))
