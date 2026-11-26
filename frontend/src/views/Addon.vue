<script setup>
import { computed, ref } from 'vue'
import { useRoute } from 'vue-router'
import { content, findAddon, paragraphs } from '../content.js'
import GalleryViewer from '../components/GalleryViewer.vue'
import PremiumCard from '../components/PremiumCard.vue'
import SectionHead from '../components/SectionHead.vue'
import VideoModal from '../components/VideoModal.vue'

const route = useRoute()
const trailer = ref('')
// o roteador só abre esta página para addons que existem
const addon = computed(() => findAddon(route.params.slug))
const others = computed(() => content.premium.filter((x) => x.slug !== addon.value.slug))
const body = computed(() => paragraphs(addon.value.description))
</script>

<template>
  <article :key="addon.slug" class="addon" :style="{ '--tint': addon.accent }">
    <div class="wrap">
      <RouterLink :to="{ path: '/', hash: '#premium' }" class="back">
        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M19 12H5M11 6l-6 6 6 6" /></svg>
        All add-ons
      </RouterLink>

      <header class="banner">
        <img :src="addon.hero || addon.gallery[0]?.src || addon.keyart" :alt="addon.gallery[0]?.alt || `${addon.title} key art`" class="banner__art" />
        <div class="banner__info">
          <span v-if="addon.badge" class="banner__badge display">{{ addon.badge }}</span>
          <h1 class="banner__title display">{{ addon.title }}</h1>
        </div>
        <span class="banner__corner banner__corner--tl" aria-hidden="true"></span>
        <span class="banner__corner banner__corner--br" aria-hidden="true"></span>
      </header>

      <div class="detail" :class="{ 'detail--solo': !addon.trailer }">
        <div class="detail__main">
          <p class="detail__tag">{{ addon.tagline }}</p>
          <p v-for="(p, n) in body" :key="n" class="detail__p">{{ p }}</p>
          <div class="detail__actions">
            <a v-if="addon.marketplace" :href="addon.marketplace" target="_blank" rel="noopener" class="btn btn--light">Get it on the Marketplace</a>
            <a v-if="addon.gallery.length" href="#addon-gallery" class="detail__link">
              View Gallery
              <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 5v14M6 13l6 6 6-6" /></svg>
            </a>
          </div>
        </div>

        <button v-if="addon.trailer" type="button" class="teaser" @click="trailer = addon.trailer">
          <img :src="addon.gallery[1]?.src || addon.keyart" alt="" loading="lazy" />
          <span class="teaser__play" aria-hidden="true">
            <svg viewBox="0 0 24 24"><path d="M8 5l12 7-12 7z" /></svg>
          </span>
          <span class="teaser__label">Watch the {{ addon.title }} trailer</span>
        </button>
      </div>

      <section v-if="addon.gallery.length" id="addon-gallery" class="block" aria-labelledby="g-title">
        <SectionHead id="g-title">Gallery</SectionHead>
        <GalleryViewer :items="addon.gallery" />
      </section>

      <section v-if="others.length" class="block" aria-labelledby="m-title">
        <SectionHead id="m-title">More Add-ons</SectionHead>
        <div class="more">
          <PremiumCard v-for="(a, n) in others" :key="a.slug" v-reveal="n" :addon="a" />
        </div>
      </section>
    </div>

    <VideoModal :src="trailer" :title="`${addon.title} trailer`" @close="trailer = ''" />
  </article>
</template>

<style scoped>
.addon {
  padding-top: 22px;
}

.back {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-size: var(--step--1);
  font-weight: 600;
  color: var(--mid);
  text-decoration: none;
}

.back:hover {
  color: var(--hi);
}

.back svg,
.detail__link svg {
  width: 16px;
  height: 16px;
  fill: none;
  stroke: currentColor;
  stroke-width: 2.2;
}

/* ---------- banner: a arte numa "tela" chanfrada, como no topo da home ---------- */
.banner {
  --cut: clamp(18px, 2.4vw, 30px);
  position: relative;
  display: grid;
  align-items: end;
  margin-top: 16px;
  aspect-ratio: 21 / 9;
  min-height: 300px;
  overflow: hidden;
  isolation: isolate;
  background: var(--panel);
  clip-path: polygon(var(--cut) 0, 100% 0, 100% calc(100% - var(--cut)), calc(100% - var(--cut)) 100%, 0 100%, 0 var(--cut));
  animation: rise 700ms cubic-bezier(0.2, 0.8, 0.2, 1) backwards;
}

.banner__art {
  position: absolute;
  inset: 0;
  z-index: -2;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.banner::after {
  content: '';
  position: absolute;
  inset: 0;
  z-index: -1;
  background: linear-gradient(0deg, rgb(20 15 28 / 0.9) 0%, rgb(20 15 28 / 0.2) 45%, transparent 70%);
}

.banner__info {
  display: grid;
  justify-items: start;
  gap: 10px;
  padding: clamp(20px, 3.4vw, 44px);
}

.banner__badge {
  padding: 4px 10px;
  font-size: 1rem;
  letter-spacing: 0.02em;
  color: #1c1527;
  background: var(--brass);
  border-radius: 3px;
  box-shadow: 0 3px 0 var(--brass-deep);
}

.banner__title {
  font-size: clamp(3rem, 8vw, 6.4rem);
  line-height: 0.86;
  text-transform: uppercase;
  text-shadow: 0 4px 0 rgb(0 0 0 / 0.35);
}

.banner__corner {
  position: absolute;
  width: 34px;
  height: 34px;
  border: 0 solid var(--tint);
}

.banner__corner--tl {
  top: 14px;
  left: calc(var(--cut) + 6px);
  border-top-width: 4px;
  border-left-width: 4px;
}

.banner__corner--br {
  right: calc(var(--cut) + 6px);
  bottom: 14px;
  border-right-width: 4px;
  border-bottom-width: 4px;
}

/* ---------- texto + ficha ---------- */
.detail {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(280px, 0.8fr);
  gap: 28px clamp(32px, 5vw, 72px);
  align-items: start;
  padding-top: clamp(28px, 4vw, 48px);
}

.detail__main {
  display: grid;
  justify-items: start;
  gap: 14px;
}

.detail__tag {
  font-size: clamp(1.25rem, 2vw, 1.6rem);
  font-weight: 600;
  line-height: 1.3;
}

.detail__p {
  max-width: 62ch;
  color: var(--mid);
  line-height: 1.7;
}

.detail__actions {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 18px;
  margin-top: 8px;
}

.detail__link {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  text-decoration: underline;
  text-underline-offset: 5px;
  text-decoration-thickness: 2px;
}

.detail--solo {
  grid-template-columns: 1fr;
}

/* prévia do trailer: imagem do addon com botão de play */
.teaser {
  position: relative;
  font: inherit;
  display: grid;
  place-items: center;
  width: 100%;
  aspect-ratio: 16 / 9;
  padding: 0;
  overflow: hidden;
  color: var(--hi);
  background: var(--panel);
  border: 0;
  border-radius: 4px;
  cursor: pointer;
  isolation: isolate;
}

.teaser img {
  position: absolute;
  inset: 0;
  z-index: -2;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 700ms cubic-bezier(0.2, 0.8, 0.2, 1);
}

.teaser::after {
  content: '';
  position: absolute;
  inset: 0;
  z-index: -1;
  background: rgb(20 15 28 / 0.45);
  transition: background-color 300ms ease;
}

.teaser:hover img {
  transform: scale(1.05);
}

.teaser:hover::after {
  background: rgb(20 15 28 / 0.25);
}

.teaser__play {
  display: grid;
  place-items: center;
  width: 74px;
  height: 74px;
  background: var(--tint);
  border-radius: 50%;
  box-shadow: 0 0 0 8px rgb(255 255 255 / 0.15);
  transition: transform 250ms cubic-bezier(0.3, 1.6, 0.5, 1), box-shadow 250ms ease;
}

.teaser:hover .teaser__play {
  transform: scale(1.1);
  box-shadow: 0 0 0 14px rgb(255 255 255 / 0.12);
}

.teaser__play svg {
  width: 30px;
  height: 30px;
  margin-left: 4px;
  fill: #1c1527;
}

.teaser__label {
  position: absolute;
  left: 14px;
  bottom: 12px;
  font-weight: 600;
  font-size: var(--step--1);
  text-shadow: 0 1px 8px rgb(0 0 0 / 0.8);
}

.block {
  padding-top: clamp(56px, 7vw, 96px);
}

.more {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: clamp(12px, 2vw, 22px);
}

@keyframes rise {
  from {
    opacity: 0;
    transform: translateY(16px);
  }
}

@media (max-width: 860px) {
  .detail {
    grid-template-columns: 1fr;
  }

  .banner {
    aspect-ratio: 16 / 10;
  }
}

@media (max-width: 520px) {
  .more {
    gap: 10px;
  }

  .more :deep(.pcard__name) {
    padding: 12px;
  }

  .more :deep(.pcard__name h3) {
    font-size: 1.15rem;
  }

  .more :deep(.pcard__arrow) {
    display: none;
  }
}
</style>
