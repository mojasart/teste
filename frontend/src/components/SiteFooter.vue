<script setup>
import { computed } from 'vue'
import { site } from '../api.js'
import BrandMark from './BrandMark.vue'
import PartnerBadge from './PartnerBadge.vue'
import SocialIcons from './SocialIcons.vue'
import logo from '../assets/logo-horizontal.png'

const email = computed(() => site.settings?.contact_email)
const discord = computed(() => site.settings?.social_discord)
const year = new Date().getFullYear()
</script>

<template>
  <footer class="footer">
    <section class="wrap touch" aria-labelledby="get-in-touch">
      <h2 id="get-in-touch" class="touch__title">Get in touch</h2>

      <div class="touch__grid">
        <article class="card">
          <span class="card__icon" aria-hidden="true">
            <svg viewBox="0 0 24 24"><path d="M3 5h18v14H3z" /><path d="m3 6 9 7 9-7" /></svg>
          </span>
          <h3>Work with us</h3>
          <p>
            Brand partnerships, custom add-ons and collaborations.
            <template v-if="email"> Write to <strong>{{ email }}</strong>.</template>
          </p>
          <RouterLink to="/contact" class="btn card__btn">Contact the studio</RouterLink>
        </article>

        <article class="card">
          <span class="card__icon" aria-hidden="true">
            <svg viewBox="0 0 24 24"><path d="M4 5h16v11H9l-5 4z" /><path d="M9 9.5h6M9 12.5h4" /></svg>
          </span>
          <h3>Need a hand?</h3>
          <p v-if="discord">Questions about an add-on you bought? Our Discord is the fastest way to get help.</p>
          <p v-else>Questions about an add-on you bought? Send us a message and we will help you out.</p>
          <a v-if="discord" :href="discord" target="_blank" rel="noopener" class="btn btn--ghost card__btn">Join our Discord</a>
          <RouterLink v-else to="/contact" class="btn btn--ghost card__btn">Get support</RouterLink>
        </article>

        <article class="card">
          <span class="card__icon" aria-hidden="true">
            <svg viewBox="0 0 24 24"><path d="M4 4h7v7H4zM13 4h7v7h-7zM4 13h7v7H4zM13 13h7v7h-7z" /></svg>
          </span>
          <h3>Our add-ons</h3>
          <p>Machines, storage, magic and more, all made for Minecraft: Bedrock Edition.</p>
          <RouterLink to="/projects" class="btn btn--ghost card__btn">Browse projects</RouterLink>
        </article>
      </div>

      <div class="legal">
        <PartnerBadge small />
        <p class="legal__text">
          © {{ year }} PurpleByte Studios. All rights reserved.<br />
          Minecraft is a trademark of Mojang Studios and Microsoft.
        </p>
        <SocialIcons />
      </div>
    </section>

    <div class="wrap">
      <div class="slab">
        <img class="slab__logo" :src="logo" alt="PurpleByte Studios" width="656" height="241" />
        <nav aria-label="Footer" class="slab__nav">
          <RouterLink to="/">Home</RouterLink>
          <RouterLink to="/projects">Projects</RouterLink>
          <RouterLink to="/about">About</RouterLink>
          <RouterLink to="/contact">Contact</RouterLink>
        </nav>
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
  margin-bottom: 28px;
}

.touch__grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 20px;
}

/* cartões da mesma altura; o botão fica sempre colado embaixo */
.card {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 28px;
  background: var(--night-2);
  border: 1px solid var(--night-3);
  border-radius: 14px;
}

.card__icon {
  display: grid;
  place-items: center;
  width: 44px;
  height: 44px;
  margin-bottom: 6px;
  background: var(--byte);
  border-radius: 10px;
  box-shadow: 3px 3px 0 var(--byte-deep);
}

.card__icon svg {
  width: 22px;
  height: 22px;
  fill: none;
  stroke: var(--white);
  stroke-width: 2;
  stroke-linejoin: round;
}

.card h3 {
  font-size: var(--step-1);
  font-stretch: 85%;
}

.card p {
  color: var(--mid);
}

.card strong {
  color: var(--hi);
}

.card__btn {
  margin-top: auto;
  align-self: flex-start;
}

.card p {
  margin-bottom: 14px;
}

.legal {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 20px 32px;
  margin-top: clamp(40px, 5vw, 64px);
  padding-block: 24px;
  border-top: 1px solid var(--night-3);
  font-size: var(--step--1);
  color: var(--mid);
}

.legal__text {
  flex: 1;
  min-width: 240px;
}

/* painel roxo com o logo e a engrenagem gigante saindo pela borda */
.slab {
  position: relative;
  display: grid;
  align-content: space-between;
  gap: 40px;
  min-height: 300px;
  padding: clamp(28px, 4vw, 44px);
  background: var(--byte);
  border-radius: 16px 16px 0 0;
  overflow: hidden;
}

.slab__logo {
  width: clamp(220px, 30vw, 360px);
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
}

@media (max-width: 820px) {
  .touch__grid {
    grid-template-columns: 1fr;
  }
}
</style>
