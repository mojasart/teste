<script setup>
// Galeria da página do addon: imagem grande, setas, legenda e miniaturas.
import { nextTick, ref, watch } from 'vue'
import Lightbox from './Lightbox.vue'

const props = defineProps({ items: { type: Array, required: true } })
const i = ref(0)
const full = ref(-1)
const strip = ref(null)

const go = (d) => (i.value = (i.value + d + props.items.length) % props.items.length)

// mantém a miniatura ativa visível na faixa
watch(i, async () => {
  await nextTick()
  strip.value?.querySelector('[aria-current="true"]')?.scrollIntoView({ block: 'nearest', inline: 'center', behavior: 'smooth' })
})

let startX = 0
const touchStart = (e) => (startX = e.touches[0].clientX)
const touchEnd = (e) => {
  const dx = e.changedTouches[0].clientX - startX
  if (Math.abs(dx) > 50) go(dx < 0 ? 1 : -1)
}
</script>

<template>
  <div class="gv">
    <div class="gv__stage" @touchstart.passive="touchStart" @touchend.passive="touchEnd">
      <Transition name="fade" mode="out-in">
        <img :key="items[i].src" :src="items[i].src" :alt="items[i].alt" class="gv__img" />
      </Transition>
      <button type="button" class="gv__full" @click="full = i">
        <span class="visually-hidden">View full screen</span>
        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 9V4h5M20 9V4h-5M4 15v5h5M20 15v5h-5" /></svg>
      </button>
    </div>

    <div class="gv__bar">
      <button type="button" class="gv__arrow" @click="go(-1)">
        <span class="visually-hidden">Previous image</span>
        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M19 12H5M11 6l-6 6 6 6" /></svg>
      </button>
      <p class="gv__cap" aria-live="polite">
        <span>{{ i + 1 }} / {{ items.length }}</span>
        {{ items[i].alt }}
      </p>
      <button type="button" class="gv__arrow" @click="go(1)">
        <span class="visually-hidden">Next image</span>
        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6" /></svg>
      </button>
    </div>

    <ul ref="strip" class="gv__strip">
      <li v-for="(g, n) in items" :key="g.src">
        <button type="button" class="gv__thumb" :aria-current="n === i" @click="i = n">
          <img :src="g.thumb || g.src" alt="" loading="lazy" />
          <span class="visually-hidden">Show image {{ n + 1 }}</span>
        </button>
      </li>
    </ul>

    <Lightbox v-model:index="full" :items="items" />
  </div>
</template>

<style scoped>
.gv {
  display: grid;
  gap: 14px;
  max-width: 1000px;
  margin-inline: auto;
}

.gv__stage {
  position: relative;
  aspect-ratio: 16 / 9;
  overflow: hidden;
  background: var(--panel);
  border-radius: 4px;
}

.gv__img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 220ms ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.gv__full {
  position: absolute;
  right: 14px;
  bottom: 14px;
  display: grid;
  place-items: center;
  width: 40px;
  height: 40px;
  color: var(--hi);
  background: rgb(20 15 28 / 0.7);
  border: 0;
  border-radius: 4px;
  cursor: pointer;
}

.gv__full:hover,
.gv__arrow:hover {
  background: var(--accent);
}

.gv__full svg,
.gv__arrow svg {
  width: 20px;
  height: 20px;
  fill: none;
  stroke: currentColor;
  stroke-width: 2.2;
}

.gv__bar {
  display: grid;
  grid-template-columns: auto 1fr auto;
  align-items: center;
  gap: 16px;
}

.gv__arrow {
  display: grid;
  place-items: center;
  width: 40px;
  height: 40px;
  color: var(--hi);
  background: var(--panel);
  border: 1px solid var(--panel-hi);
  border-radius: 4px;
  cursor: pointer;
}

.gv__cap {
  display: grid;
  gap: 2px;
  text-align: center;
  font-size: var(--step--1);
}

.gv__cap span {
  color: var(--mid);
}

.gv__strip {
  display: flex;
  gap: 8px;
  margin: 0;
  padding: 2px 2px 8px;
  overflow-x: auto;
  list-style: none;
  scrollbar-width: thin;
  scrollbar-color: var(--panel-hi) transparent;
}

.gv__thumb {
  display: block;
  width: 150px;
  aspect-ratio: 16 / 9;
  padding: 0;
  overflow: hidden;
  background: var(--panel);
  border: 2px solid transparent;
  border-radius: 3px;
  opacity: 0.55;
  cursor: pointer;
  transition: opacity 200ms ease, border-color 200ms ease;
}

.gv__thumb:hover {
  opacity: 0.85;
}

.gv__thumb[aria-current='true'] {
  opacity: 1;
  border-color: var(--accent-hi);
}

.gv__thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

@media (max-width: 600px) {
  .gv__thumb {
    width: 96px;
  }
}
</style>
