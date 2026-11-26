<script setup>
import { computed, ref } from 'vue'
import { content, site } from '../content.js'
import HeroSlides from '../components/HeroSlides.vue'
import PremiumCard from '../components/PremiumCard.vue'
import GalleryRows from '../components/GalleryRows.vue'
import FreeCard from '../components/FreeCard.vue'
import SectionTitle from '../components/SectionTitle.vue'
import VideoModal from '../components/VideoModal.vue'

const trailer = ref('')
const premium = content.premium
const free = content.free
const featured = premium.find((a) => a.featured) || premium[0]

// topo: imagem principal + prints do addon em destaque
const slides = [
  ...(featured.hero ? [{ src: featured.hero, alt: `${featured.title} key art` }] : []),
  ...featured.gallery.map((g) => ({ src: g.src, alt: g.alt })),
].slice(0, 7)

// galeria: prints de todos os premium, intercalados
const gallery = (() => {
  const lists = premium.map((a) => a.gallery.map((g) => ({ ...g, title: a.title })))
  const out = []
  for (let n = 0; lists.some((l) => l[n]); n++) lists.forEach((l) => l[n] && out.push(l[n]))
  return out
})()

const showAll = ref(false)
const freeShown = computed(() => (showAll.value ? free : free.slice(0, 12)))
const moreUrl = site.freeMoreUrl
</script>

<template>
    <HeroSlides v-if="featured" :addon="featured" :slides="slides" @trailer="trailer = featured.trailer" />

    <section id="premium" class="wrap premium" aria-label="Premium Content">
      <h2 class="visually-hidden">Premium Content</h2>
      <div class="premium__grid">
        <PremiumCard v-for="(a, n) in premium" :key="a.slug" v-reveal="n" :addon="a" :class="{ 'premium__mid': n % 3 === 1 }" />
      </div>
    </section>

    <section v-if="gallery.length" id="gallery" class="gallery" aria-labelledby="gallery-title">
      <div class="wrap"><SectionTitle id="gallery-title">Gallery</SectionTitle></div>
      <GalleryRows :items="gallery" />
    </section>

    <section v-if="free.length" id="free" class="wrap free" aria-labelledby="free-title">
      <SectionTitle id="free-title">Free Content</SectionTitle>
      <div class="free__grid">
        <FreeCard v-for="(a, n) in freeShown" :key="a.slug" v-reveal="n % 3" :addon="a" />
      </div>
      <div class="free__more">
        <button v-if="!showAll && free.length > 12" type="button" class="btn btn--accent" @click="showAll = true">
          Show more add-ons
        </button>
        <a v-else-if="moreUrl" :href="moreUrl" target="_blank" rel="noopener" class="btn btn--accent">
          Show more add-ons
          <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><path d="M7 17L17 7M9 7h8v8" fill="none" stroke="currentColor" stroke-width="2.2" /></svg>
        </a>
      </div>
    </section>

    <VideoModal :src="trailer" :title="`${featured.title} trailer`" @close="trailer = ''" />
</template>

<style scoped>
/* cartões premium sobem por cima do fim do hero */
.premium {
  position: relative;
  z-index: 2;
  margin-top: clamp(-150px, -12vw, -80px);
}

.premium__grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: clamp(14px, 1.6vw, 22px);
  align-items: start;
}

.premium__mid {
  margin-top: 22px;
}

.gallery {
  padding-top: clamp(64px, 8vw, 110px);
}

.free {
  padding-top: clamp(64px, 8vw, 110px);
}

.free__grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
}

.free__more {
  display: flex;
  justify-content: center;
  margin-top: 28px;
}

@media (max-width: 900px) {
  .free__grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .premium {
    margin-top: -64px;
  }

  .premium__grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 8px;
  }

  .premium__mid {
    margin-top: 10px;
  }

  .premium__grid :deep(.pcard__name) {
    padding: 10px;
  }

  .premium__grid :deep(.pcard__name h3) {
    font-size: 1.05rem;
  }

  .premium__grid :deep(.pcard__arrow) {
    display: none;
  }

  .free__grid {
    grid-template-columns: 1fr;
  }
}
</style>
