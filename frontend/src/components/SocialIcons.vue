<script setup>
import { computed } from 'vue'
import { site } from '../api.js'

// ícones simples (marcas) em SVG, só aparecem os que têm link preenchido no painel
const icons = {
  youtube: 'M23.5 6.2a3 3 0 0 0-2.1-2.1C19.5 3.6 12 3.6 12 3.6s-7.5 0-9.4.5A3 3 0 0 0 .5 6.2 31 31 0 0 0 0 12a31 31 0 0 0 .5 5.8 3 3 0 0 0 2.1 2.1c1.9.5 9.4.5 9.4.5s7.5 0 9.4-.5a3 3 0 0 0 2.1-2.1A31 31 0 0 0 24 12a31 31 0 0 0-.5-5.8zM9.6 15.6V8.4l6.3 3.6z',
  discord: 'M20.3 4.4A19.8 19.8 0 0 0 15.4 3l-.6 1.3a18.4 18.4 0 0 0-5.6 0L8.6 3a19.7 19.7 0 0 0-4.9 1.5C.6 9.1-.3 13.7.1 18.2a19.9 19.9 0 0 0 6 3l1.3-2.1a13 13 0 0 1-2-1l.5-.4a14.2 14.2 0 0 0 12.2 0l.5.4c-.6.4-1.3.7-2 1l1.3 2.1a19.8 19.8 0 0 0 6-3c.5-5.2-.9-9.7-3.6-13.8zM8 15.4c-1.2 0-2.2-1.1-2.2-2.4s1-2.4 2.2-2.4 2.2 1.1 2.2 2.4-1 2.4-2.2 2.4zm8 0c-1.2 0-2.2-1.1-2.2-2.4s1-2.4 2.2-2.4 2.2 1.1 2.2 2.4-1 2.4-2.2 2.4z',
  x: 'M18.2 2.3h3.4l-7.4 8.4L23 21.7h-6.8l-5.3-7-6.1 7H1.4l7.9-9L.9 2.3h7l4.8 6.4zm-1.2 17.4h1.9L7 4.2H5z',
  instagram: 'M12 2.2c3.2 0 3.6 0 4.8.1 3.3.1 4.8 1.7 4.9 4.9.1 1.3.1 1.6.1 4.8s0 3.6-.1 4.8c-.1 3.2-1.7 4.8-4.9 4.9-1.3.1-1.6.1-4.8.1s-3.6 0-4.8-.1c-3.3-.1-4.8-1.7-4.9-4.9C2.2 15.6 2.2 15.2 2.2 12s0-3.6.1-4.8C2.4 3.9 3.9 2.4 7.2 2.3 8.4 2.2 8.8 2.2 12 2.2zM12 7a5 5 0 1 0 0 10 5 5 0 0 0 0-10zm0 8.2a3.2 3.2 0 1 1 0-6.4 3.2 3.2 0 0 1 0 6.4zm5.2-9.6a1.2 1.2 0 1 0 0 2.4 1.2 1.2 0 0 0 0-2.4z',
}

const links = computed(() => {
  const s = site.settings || {}
  return [
    ['YouTube', 'youtube', s.social_youtube],
    ['Discord', 'discord', s.social_discord],
    ['X', 'x', s.social_twitter],
    ['Instagram', 'instagram', s.social_instagram],
  ].filter(([, , url]) => url)
})
</script>

<template>
  <nav v-if="links.length" class="social" aria-label="Social media">
    <a v-for="[name, key, url] in links" :key="key" :href="url" target="_blank" rel="noopener" class="social__link">
      <svg viewBox="0 0 24 24" aria-hidden="true"><path :d="icons[key]" /></svg>
      <span class="visually-hidden">{{ name }}</span>
    </a>
  </nav>
</template>

<style scoped>
.social {
  display: flex;
  gap: 10px;
}

.social__link {
  display: grid;
  place-items: center;
  width: 44px;
  height: 44px;
  color: var(--hi);
  background: var(--night-2);
  border: 1px solid var(--night-3);
  border-radius: 10px;
  transition: background 150ms ease, border-color 150ms ease, transform 150ms ease;
}

.social__link:hover {
  background: var(--byte);
  border-color: var(--byte);
  transform: translateY(-2px);
}

.social__link svg {
  width: 20px;
  height: 20px;
  fill: currentColor;
}
</style>
