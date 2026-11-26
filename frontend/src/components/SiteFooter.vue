<script setup>
import { useRoute } from 'vue-router'
import { computed } from 'vue'
import { site } from '../content.js'
import BrandMark from './BrandMark.vue'
import SocialIcons from './SocialIcons.vue'
import logo from '../assets/logo.webp'
import badge from '../assets/marketplace-partner.png'

const year = new Date().getFullYear()
const route = useRoute()
const onContact = computed(() => route.path.replace(/\/$/, '') === '/contact')
const links = [
  { to: { path: '/', hash: '#premium' }, label: 'Premium Content' },
  { to: { path: '/', hash: '#gallery' }, label: 'Gallery' },
  { to: { path: '/', hash: '#free' }, label: 'Free Content' },
  { to: { path: '/contact' }, label: 'Contact' },
]
</script>

<template>
  <footer class="footer">
    <div class="wrap">
      <div class="slab">
        <div class="slab__top">
          <img :src="logo" alt="PurpleByte Studios" class="slab__logo" width="500" height="182" />
          <img :src="badge" alt="Official Minecraft Partner" class="slab__badge" width="250" height="289" />
        </div>
        <p class="slab__pitch">Add-ons for Minecraft: Bedrock Edition, built by players who love machines, magic and survival.</p>
        <nav class="slab__nav" aria-label="Footer">
          <RouterLink v-for="l in links" :key="l.label" :to="l.to">{{ l.label }}</RouterLink>
        </nav>
        <div v-if="!onContact" class="slab__social">
          <SocialIcons small />
          <a v-if="site.social.discord" :href="site.social.discord" target="_blank" rel="noopener" class="btn btn--light btn--small">Join our Discord</a>
        </div>
        <div class="slab__mark" aria-hidden="true"><BrandMark spin /></div>
      </div>
      <p class="legal">© {{ year }} PurpleByte LLC. Minecraft is a trademark of Mojang Studios and Microsoft.</p>
    </div>
  </footer>
</template>

<style scoped>
.footer {
  padding-top: clamp(64px, 8vw, 110px);
}

.slab {
  position: relative;
  display: grid;
  gap: 22px;
  padding: clamp(24px, 4vw, 48px);
  padding-right: clamp(24px, 30%, 420px);
  overflow: hidden;
  color: var(--white);
  background: var(--byte);
  border-radius: 14px 14px 0 0;
  box-shadow: inset 0 -6px 0 var(--byte-deep);
}

.slab__top {
  display: flex;
  align-items: center;
  gap: 18px;
}

.slab__logo {
  width: clamp(170px, 22vw, 260px);
  height: auto;
  filter: drop-shadow(3px 4px 0 var(--byte-deep));
}

.slab__badge {
  width: auto;
  height: clamp(46px, 5vw, 62px);
}

.slab__pitch {
  max-width: 44ch;
  font-size: 1.05rem;
}

.slab__nav {
  display: flex;
  flex-wrap: wrap;
  gap: 8px 24px;
}

.slab__nav a {
  font-weight: 600;
  text-decoration: none;
}

.slab__nav a:hover {
  text-decoration: underline;
  text-underline-offset: 4px;
}

.slab__social {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 16px 22px;
}

.slab__social :deep(.social) {
  justify-content: flex-start;
}

.slab__mark {
  position: absolute;
  right: clamp(-110px, -6vw, -40px);
  bottom: clamp(-130px, -8vw, -50px);
  width: clamp(220px, 30vw, 420px);
}

.legal {
  padding-block: 18px 26px;
  font-size: var(--step--1);
  color: var(--mid);
}

@media (max-width: 700px) {
  .slab {
    padding-right: clamp(24px, 4vw, 48px);
    padding-bottom: 150px;
  }

  .slab__mark {
    width: 190px;
    right: -40px;
    bottom: -60px;
  }
}
</style>
