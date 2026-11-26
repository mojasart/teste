<script setup>
import { computed, ref } from 'vue'
import { content, site } from '../content.js'
import FeatureHero from '../components/FeatureHero.vue'
import AddonRow from '../components/AddonRow.vue'
import GalleryRows from '../components/GalleryRows.vue'
import Hotbar from '../components/Hotbar.vue'
import SectionHead from '../components/SectionHead.vue'
import VideoModal from '../components/VideoModal.vue'

const premium = content.premium
const featured = premium.find((a) => a.featured) || premium[0]
const others = premium.filter((a) => a !== featured)
const free = content.free
const trailer = ref(null) // addon cujo trailer está aberto

// galeria: prints de todos os premium, intercalados
const gallery = (() => {
  const lists = premium.map((a) => a.gallery.map((g) => ({ ...g, title: a.title })))
  const out = []
  for (let n = 0; lists.some((l) => l[n]); n++) lists.forEach((l) => l[n] && out.push(l[n]))
  return out
})()

const shots = computed(() => gallery.length)
</script>

<template>
  <FeatureHero :addon="featured" @trailer="trailer = $event" />

  <section v-if="others.length" id="premium" class="wrap premium" aria-labelledby="premium-title">
    <SectionHead id="premium-title">Featured Add-ons</SectionHead>
    <div class="premium__list">
      <AddonRow v-for="(a, n) in others" :key="a.slug" v-reveal :addon="a" :flip="n % 2 === 1" />
    </div>
  </section>

  <section v-if="gallery.length" id="gallery" class="gallery" aria-labelledby="gallery-title">
    <div class="wrap">
      <SectionHead id="gallery-title">Gallery</SectionHead>
      <p class="lead">{{ shots }} screenshots from our premium add-ons. Tap one to see it full screen.</p>
    </div>
    <GalleryRows :items="gallery" />
  </section>

  <section v-if="free.length" id="free" class="wrap free" aria-labelledby="free-title">
    <SectionHead id="free-title">
      Free Content
      <template #side>
        <a :href="site.freeMoreUrl" target="_blank" rel="noopener" class="btn btn--accent btn--small">
          More
          <svg viewBox="0 0 24 24" width="14" height="14" aria-hidden="true"><path d="M7 17L17 7M9 7h8v8" fill="none" stroke="currentColor" stroke-width="2.4" /></svg>
        </a>
      </template>
    </SectionHead>
    <p class="lead">Free add-ons made by our team. Pick one to download it, or see them all with More.</p>
    <Hotbar :items="free" />
  </section>

  <VideoModal :src="trailer?.trailer || ''" :title="`${trailer?.title} trailer`" @close="trailer = null" />
</template>

<style scoped>
.premium {
  padding-top: clamp(32px, 4vw, 56px);
}

.gallery,
.free {
  padding-top: clamp(64px, 8vw, 110px);
}

.premium__list {
  display: grid;
  gap: clamp(14px, 2vw, 24px);
}

.lead {
  max-width: 56ch;
  margin: -12px 0 clamp(18px, 2.4vw, 28px);
  color: var(--mid);
}

@media (max-width: 560px) {
  .free :deep(.shead) {
    flex-wrap: wrap;
  }

  .free :deep(.shead__side) {
    order: 3;
    width: 100%;
  }
}
</style>
