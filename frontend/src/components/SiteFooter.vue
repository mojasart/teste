<script setup>
import { computed } from 'vue'
import { site } from '../api.js'
import BrandMark from './BrandMark.vue'
import logo from '../assets/logo-horizontal.png'

const socials = computed(() => {
  const s = site.settings || {}
  return [
    ['YouTube', s.social_youtube],
    ['Discord', s.social_discord],
    ['X', s.social_twitter],
    ['Instagram', s.social_instagram],
  ].filter(([, url]) => url)
})
const email = computed(() => site.settings?.contact_email)
const year = new Date().getFullYear()
</script>

<template>
  <footer class="footer">
    <section class="wrap touch" aria-labelledby="get-in-touch">
      <h2 id="get-in-touch" class="touch__title">Get in touch</h2>
      <div class="touch__grid">
        <div class="touch__item">
          <h3>Work with us</h3>
          <p>
            Brand partnerships, custom add-ons and collaborations.
            <template v-if="email">Write to <strong>{{ email }}</strong>.</template>
          </p>
          <RouterLink to="/contact" class="btn btn--small">Contact the studio</RouterLink>
        </div>
        <div class="touch__item">
          <h3>Need a hand?</h3>
          <p>Questions about an add-on you bought? Send us a message and we will help you out.</p>
          <RouterLink to="/contact" class="btn btn--small btn--ghost">Get support</RouterLink>
        </div>
        <div class="touch__item">
          <h3>Our add-ons</h3>
          <p>Machines, storage, magic and more, all made for Minecraft: Bedrock Edition.</p>
          <RouterLink to="/projects" class="btn btn--small btn--ghost">Browse projects</RouterLink>
        </div>
      </div>

      <div class="legal">
        <p>
          © {{ year }} PurpleByte Studios. All rights reserved.<br />
          Minecraft is a trademark of Mojang Studios and Microsoft.
        </p>
        <nav v-if="socials.length" aria-label="Social media" class="legal__social">
          <a v-for="[name, url] in socials" :key="name" :href="url" target="_blank" rel="noopener">{{ name }}</a>
        </nav>
      </div>
    </section>

    <div class="wrap">
      <div class="slab">
        <nav aria-label="Footer" class="slab__nav">
          <RouterLink to="/">Home</RouterLink>
          <RouterLink to="/projects">Projects</RouterLink>
          <RouterLink to="/about">About</RouterLink>
          <RouterLink to="/contact">Contact</RouterLink>
        </nav>
        <img class="slab__logo" :src="logo" alt="PurpleByte Studios" width="656" height="241" />
        <div class="slab__mark" aria-hidden="true"><BrandMark spin /></div>
      </div>
    </div>
  </footer>
</template>

<style scoped>
.footer {
  padding-top: clamp(56px, 7vw, 96px);
  background: var(--night);
  border-top: 1px solid var(--night-3);
  overflow: hidden;
}

.touch__title {
  font-size: var(--step-3);
  font-stretch: 80%;
  color: var(--byte);
  margin-bottom: 32px;
}

.touch__grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 32px 48px;
}

.touch__item {
  display: grid;
  align-content: start;
  justify-items: start;
  gap: 10px;
}

.touch__item h3 {
  font-size: var(--step-1);
  font-stretch: 85%;
}

.touch__item p {
  color: var(--mid);
  margin-bottom: 8px;
}

.touch__item strong {
  color: var(--hi);
}

.legal {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 16px 32px;
  margin-top: clamp(40px, 5vw, 64px);
  padding-block: 24px;
  border-top: 2px solid var(--byte);
  font-size: var(--step--1);
  color: var(--mid);
}

.legal__social {
  display: flex;
  flex-wrap: wrap;
  gap: 8px 20px;
}

.legal__social a {
  font-weight: 700;
  color: var(--hi);
  text-decoration: none;
}

.legal__social a:hover {
  text-decoration: underline;
}

/* painel roxo com a marca gigante saindo pela borda */
.slab {
  position: relative;
  display: grid;
  grid-template-columns: 1fr;
  align-content: end;
  gap: 24px;
  min-height: 300px;
  margin-bottom: clamp(16px, 2vw, 24px);
  padding: clamp(24px, 4vw, 40px);
  background: var(--byte);
  border-radius: 16px 16px 0 0;
  overflow: hidden;
}

.slab__logo {
  position: absolute;
  top: clamp(24px, 4vw, 40px);
  left: clamp(24px, 4vw, 40px);
  width: clamp(220px, 30vw, 380px);
  height: auto;
  filter: drop-shadow(4px 5px 0 var(--byte-deep));
}

.slab__nav {
  position: relative;
  z-index: 1;
  display: flex;
  flex-wrap: wrap;
  gap: 8px 28px;
}

.slab__nav a {
  font-weight: 800;
  color: var(--white);
  text-decoration: none;
}

.slab__nav a:hover {
  text-decoration: underline;
  text-underline-offset: 4px;
}

.slab__mark {
  position: absolute;
  right: clamp(-90px, -6vw, -40px);
  bottom: clamp(-120px, -8vw, -60px);
  width: clamp(220px, 26vw, 360px);
  opacity: 0.95;
}

@media (max-width: 820px) {
  .touch__grid {
    grid-template-columns: 1fr;
  }

  .slab {
    min-height: 280px;
  }
}
</style>
