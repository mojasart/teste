<script setup>
import { computed } from 'vue'
import { site } from '../api.js'
import BrandMark from './BrandMark.vue'

const socials = computed(() => {
  const s = site.settings || {}
  return [
    ['YouTube', s.social_youtube],
    ['Discord', s.social_discord],
    ['X / Twitter', s.social_twitter],
    ['Instagram', s.social_instagram],
  ].filter(([, url]) => url)
})
const year = new Date().getFullYear()
</script>

<template>
  <footer class="footer">
    <div class="wrap footer__grid">
      <div class="footer__brand">
        <span class="footer__mark"><BrandMark gap="var(--ink)" /></span>
        <p>PurpleByte Studios</p>
      </div>

      <nav aria-label="Rodapé" class="footer__links">
        <RouterLink to="/projetos">Projetos</RouterLink>
        <RouterLink to="/sobre">Sobre</RouterLink>
        <RouterLink to="/contato">Contato</RouterLink>
        <a v-if="site.settings?.contact_email" :href="`mailto:${site.settings.contact_email}`">{{ site.settings.contact_email }}</a>
      </nav>

      <nav v-if="socials.length" aria-label="Redes sociais" class="footer__links">
        <a v-for="[name, url] in socials" :key="name" :href="url" target="_blank" rel="noopener">{{ name }}</a>
      </nav>
    </div>

    <p class="wrap footer__legal">
      © {{ year }} PurpleByte Studios. Minecraft é uma marca da Mojang Studios e da Microsoft.
    </p>
  </footer>
</template>

<style scoped>
.footer {
  background: var(--ink);
  color: #d9cdf5;
  padding: 56px 0 28px;
}

.footer__grid {
  display: grid;
  grid-template-columns: 1.4fr 1fr 1fr;
  gap: 32px;
}

.footer__brand {
  display: flex;
  align-items: center;
  gap: 14px;
  color: var(--white);
  font-weight: 800;
  font-stretch: 80%;
  font-size: var(--step-1);
}

.footer__mark {
  width: 48px;
}

.footer__links {
  display: grid;
  gap: 8px;
  align-content: start;
}

.footer__links a {
  text-decoration: none;
  width: fit-content;
}

.footer__links a:hover {
  color: var(--white);
  text-decoration: underline;
}

.footer__legal {
  margin-top: 48px;
  font-size: var(--step--1);
  color: #a596c7;
}

@media (max-width: 720px) {
  .footer__grid {
    grid-template-columns: 1fr;
  }
}
</style>
