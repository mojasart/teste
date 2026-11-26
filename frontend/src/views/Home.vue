<script setup>
import { computed, onMounted, ref } from 'vue'
import { api, site } from '../api.js'
import HeroSlides from '../components/HeroSlides.vue'
import PremiumCard from '../components/PremiumCard.vue'
import GalleryRows from '../components/GalleryRows.vue'
import FreeCard from '../components/FreeCard.vue'
import SectionTitle from '../components/SectionTitle.vue'
import VideoModal from '../components/VideoModal.vue'

const addons = ref([])
const status = ref('loading')
const trailer = ref('')

onMounted(async () => {
  try {
    addons.value = await api('/addons')
    status.value = 'ok'
  } catch {
    status.value = 'error'
  }
})

const premium = computed(() => addons.value.filter((a) => a.category?.slug === 'premium'))
const free = computed(() => addons.value.filter((a) => a.category?.slug === 'free'))
const featured = computed(() => premium.value.find((a) => a.featured) || premium.value[0])

// topo: imagem principal + prints do addon em destaque
const slides = computed(() => {
  const f = featured.value
  if (!f) return []
  const first = f.banner_image ? [{ src: f.banner_image, alt: `${f.title} key art` }] : []
  return [...first, ...f.gallery.map((g) => ({ src: g.src, alt: g.alt }))].slice(0, 7)
})

// galeria: prints de todos os premium, intercalados
const gallery = computed(() => {
  const lists = premium.value.map((a) => a.gallery.map((g) => ({ ...g, title: a.title })))
  const out = []
  for (let n = 0; lists.some((l) => l[n]); n++) lists.forEach((l) => l[n] && out.push(l[n]))
  return out
})

const showAll = ref(false)
const freeShown = computed(() => (showAll.value ? free.value : free.value.slice(0, 12)))
const moreUrl = computed(() => site.settings?.free_more_url)
</script>

<template>
  <div v-if="status === 'loading'" class="loading" aria-live="polite">
    <span class="loading__bar"></span>
    <span class="visually-hidden">Loading</span>
  </div>

  <section v-else-if="status === 'error'" class="wrap state">
    <h1 class="display">Our add-ons could not be loaded.</h1>
    <p>Check your connection and refresh the page.</p>
  </section>

  <template v-else>
    <HeroSlides v-if="featured" :addon="featured" :slides="slides" @trailer="trailer = featured.trailer_url" />

    <section id="premium" class="wrap premium" aria-label="Premium Content">
      <h2 class="visually-hidden">Premium Content</h2>
      <div class="premium__grid">
        <PremiumCard v-for="(a, n) in premium" :key="a.id" v-reveal="n" :addon="a" :class="{ 'premium__mid': n % 3 === 1 }" />
      </div>
    </section>

    <section v-if="gallery.length" id="gallery" class="gallery" aria-labelledby="gallery-title">
      <div class="wrap"><SectionTitle id="gallery-title">Gallery</SectionTitle></div>
      <GalleryRows :items="gallery" />
    </section>

    <section v-if="free.length" id="free" class="wrap free" aria-labelledby="free-title">
      <SectionTitle id="free-title">Free Content</SectionTitle>
      <div class="free__grid">
        <FreeCard v-for="(a, n) in freeShown" :key="a.id" v-reveal="n % 3" :addon="a" />
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

    <VideoModal :src="trailer" :title="`${featured?.title} trailer`" @close="trailer = ''" />
  </template>
</template>

<style scoped>
.loading {
  display: grid;
  place-items: center;
  min-height: 60vh;
}

.loading__bar {
  width: 120px;
  height: 4px;
  border-radius: 2px;
  background: linear-gradient(90deg, transparent, var(--accent-hi), transparent) 0 0 / 50% 100% no-repeat var(--panel);
  animation: load 1s linear infinite;
}

@keyframes load {
  from {
    background-position: -100% 0;
  }
  to {
    background-position: 200% 0;
  }
}

.state {
  display: grid;
  gap: 12px;
  padding-block: 120px;
  color: var(--mid);
}

.state h1 {
  font-size: var(--step-3);
  color: var(--hi);
}

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
