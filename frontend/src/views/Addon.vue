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
const status = computed(() => (addon.value.marketplace ? 'Available on the Marketplace' : addon.value.badge || 'Premium add-on'))
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

      <div class="detail">
        <div class="detail__main">
          <p class="detail__tag">{{ addon.tagline }}</p>
          <p v-for="(p, n) in body" :key="n" class="detail__p">{{ p }}</p>
          <div class="detail__actions">
            <button v-if="addon.trailer" type="button" class="btn btn--accent" @click="trailer = addon.trailer">
              <svg viewBox="0 0 24 24" width="14" height="14" aria-hidden="true"><path d="M7 4l13 8-13 8z" fill="currentColor" /></svg>
              Watch Trailer
            </button>
            <a v-if="addon.marketplace" :href="addon.marketplace" target="_blank" rel="noopener" class="btn btn--light">Get it on the Marketplace</a>
            <a v-if="addon.gallery.length" href="#addon-gallery" class="detail__link">
              View Gallery
              <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 5v14M6 13l6 6 6-6" /></svg>
            </a>
          </div>
        </div>

        <dl class="facts">
          <div><dt>Type</dt><dd>Premium add-on</dd></div>
          <div><dt>Platform</dt><dd>Minecraft: Bedrock Edition</dd></div>
          <div><dt>Status</dt><dd>{{ status }}</dd></div>
          <div v-if="addon.gallery.length"><dt>Screenshots</dt><dd>{{ addon.gallery.length }}</dd></div>
        </dl>
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
  grid-template-columns: minmax(0, 1fr) 320px;
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

.facts {
  display: grid;
  gap: 0;
  margin: 0;
  background: var(--bg-2);
  border: 1px solid var(--panel-hi);
  border-top: 4px solid var(--tint);
  border-radius: 4px;
}

.facts div {
  display: grid;
  gap: 2px;
  padding: 14px 18px;
  border-bottom: 1px solid var(--panel);
}

.facts div:last-child {
  border-bottom: 0;
}

.facts dt {
  font-size: 0.8rem;
  color: var(--mid);
}

.facts dd {
  margin: 0;
  font-weight: 600;
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
