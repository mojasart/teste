<script setup>
import { computed, ref } from 'vue'
import { useRoute } from 'vue-router'
import { content, findAddon, paragraphs } from '../content.js'
import GalleryViewer from '../components/GalleryViewer.vue'
import PremiumCard from '../components/PremiumCard.vue'
import SectionTitle from '../components/SectionTitle.vue'
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

      <header class="top">
        <div class="top__art">
          <img :src="addon.keyart" :alt="`${addon.title} key art`" />
          <span v-if="addon.badge" class="badge">{{ addon.badge }}</span>
        </div>
        <div class="top__text">
          <h1 class="top__title display">{{ addon.title }}</h1>
          <div class="top__body">
            <p v-if="addon.tagline && !body.length">{{ addon.tagline }}</p>
            <p v-for="(p, n) in body" :key="n">{{ p }}</p>
          </div>
          <div class="top__actions">
            <button v-if="addon.trailer" type="button" class="btn btn--accent" @click="trailer = addon.trailer">
              <svg viewBox="0 0 24 24" width="14" height="14" aria-hidden="true"><path d="M7 4l13 8-13 8z" fill="currentColor" /></svg>
              Watch Trailer
            </button>
            <a v-if="addon.marketplace" :href="addon.marketplace" target="_blank" rel="noopener" class="btn btn--light">
              Get it on the Marketplace
            </a>
            <a v-if="addon.gallery.length" href="#addon-gallery" class="top__link">
              View Gallery
              <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 5v14M6 13l6 6 6-6" /></svg>
            </a>
          </div>
        </div>
      </header>

      <section v-if="addon.gallery.length" id="addon-gallery" class="block" aria-labelledby="g-title">
        <SectionTitle id="g-title">Gallery</SectionTitle>
        <GalleryViewer :items="addon.gallery" />
      </section>

      <section v-if="others.length" class="block" aria-labelledby="m-title">
        <SectionTitle id="m-title">More Add-ons</SectionTitle>
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
  padding-top: 24px;
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
.top__link svg {
  width: 16px;
  height: 16px;
  fill: none;
  stroke: currentColor;
  stroke-width: 2.2;
}

.top {
  display: grid;
  grid-template-columns: minmax(0, 1.15fr) minmax(0, 1fr);
  align-items: center;
  gap: clamp(24px, 4vw, 56px);
  margin-top: 18px;
}

.top__art {
  position: relative;
  overflow: hidden;
  border-radius: 4px;
  box-shadow: 0 40px 90px -40px var(--tint);
  animation: art 700ms cubic-bezier(0.2, 0.8, 0.2, 1) backwards;
}

.badge {
  position: absolute;
  top: 14px;
  right: 14px;
  padding: 6px 12px;
  font-family: var(--display);
  font-weight: 700;
  font-size: 1.05rem;
  letter-spacing: 0.02em;
  color: #1c1527;
  background: var(--brass);
  border-radius: 3px;
  box-shadow: 0 3px 0 var(--brass-deep);
}

.top__art img {
  width: 100%;
  aspect-ratio: 16 / 9;
  object-fit: cover;
}

@keyframes art {
  from {
    opacity: 0;
    transform: translateY(16px) scale(0.98);
  }
}

.top__text {
  display: grid;
  justify-items: start;
  gap: 16px;
  animation: art 700ms cubic-bezier(0.2, 0.8, 0.2, 1) 120ms backwards;
}

.top__title {
  font-size: clamp(2.6rem, 5vw, 4rem);
  line-height: 0.95;
}

.top__body {
  display: grid;
  gap: 0.8em;
  max-width: 52ch;
  color: var(--mid);
  line-height: 1.65;
}

.top__actions {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 18px;
  margin-top: 6px;
}

.top__link {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  text-decoration: underline;
  text-underline-offset: 5px;
  text-decoration-thickness: 2px;
}

.top__link:hover svg {
  animation: bob 600ms ease infinite alternate;
}

@keyframes bob {
  to {
    transform: translateY(3px);
  }
}

.block {
  padding-top: clamp(56px, 7vw, 96px);
}

.more {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: clamp(14px, 2vw, 24px);
  max-width: 900px;
  margin-inline: auto;
}

@media (max-width: 860px) {
  .top {
    grid-template-columns: 1fr;
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
    font-size: 1.2rem;
  }

  .more :deep(.pcard__arrow) {
    width: 18px;
  }
}
</style>
