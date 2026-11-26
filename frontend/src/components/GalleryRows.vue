<script setup>
// Faixas de prints correndo em sentidos alternados; tocar abre em tela cheia.
import { computed, ref } from 'vue'
import Lightbox from './Lightbox.vue'

const props = defineProps({ items: { type: Array, required: true } }) // [{ src, thumb, alt }]
const playing = ref(!matchMedia('(prefers-reduced-motion: reduce)').matches)
const open = ref(-1)

// distribui em 3 faixas e repete cada uma para o loop não ter emenda
const rows = computed(() => {
  const r = [[], [], []]
  props.items.forEach((it, n) => r[n % 3].push({ ...it, n }))
  return r.filter((x) => x.length).map((x) => {
    let base = [...x]
    while (base.length < 6) base = base.concat(x)
    return [...base, ...base]
  })
})
</script>

<template>
  <div class="grows" :class="{ 'grows--paused': !playing }">
    <button type="button" class="grows__pause" @click="playing = !playing">
      <span class="visually-hidden">{{ playing ? 'Pause gallery' : 'Play gallery' }}</span>
      <svg v-if="playing" viewBox="0 0 24 24" aria-hidden="true"><path d="M7 5h3.5v14H7zM13.5 5H17v14h-3.5z" /></svg>
      <svg v-else viewBox="0 0 24 24" aria-hidden="true"><path d="M8 5l11 7-11 7z" /></svg>
    </button>

    <div class="belt">
    <span class="belt__rail" aria-hidden="true"></span>
    <div v-for="(row, r) in rows" :key="r" class="grows__row" :class="{ 'grows__row--rev': r % 2 }">
      <ul class="grows__track" :style="{ animationDuration: `${row.length * 4.5}s` }">
        <li v-for="(it, k) in row" :key="k" :aria-hidden="k >= row.length / 2">
          <button type="button" class="grows__item" :tabindex="k >= row.length / 2 ? -1 : 0" @click="open = it.n">
            <img :src="it.thumb || it.src" :alt="it.alt" loading="lazy" />
            <span class="grows__label">{{ it.title }}</span>
          </button>
        </li>
      </ul>
    </div>
    <span class="belt__rail belt__rail--rev" aria-hidden="true"></span>
    </div>

    <Lightbox v-model:index="open" :items="items" />
  </div>
</template>

<style scoped>
.grows {
  position: relative;
  padding-block: 22px;
}

.grows .belt {
  overflow: hidden;
}

.grows__pause {
  position: absolute;
  right: max(var(--gutter), calc((100vw - var(--max)) / 2 + var(--gutter)));
  top: -40px;
  z-index: 2;
  display: grid;
  place-items: center;
  width: 36px;
  height: 36px;
  color: var(--hi);
  background: transparent;
  border: 0;
  cursor: pointer;
}

.grows__pause svg {
  width: 18px;
  height: 18px;
  fill: currentColor;
}

/* esteira de fábrica: faixa inclinada com trilhos correndo em cima e embaixo */
.belt {
  display: grid;
  gap: 10px;
  margin-inline: -4vw;
  padding-block: 4px;
  background: #140f1c;
  transform: rotate(-2deg);
}

.belt__rail {
  height: 12px;
  background: repeating-linear-gradient(90deg, #3a2d4d 0 20px, #251b33 20px 28px);
  background-size: 28px 100%;
  animation: rail 0.8s linear infinite;
}

.belt__rail--rev {
  animation-direction: reverse;
}

.grows--paused .belt__rail {
  animation-play-state: paused;
}

@keyframes rail {
  to {
    background-position: -28px 0;
  }
}

.grows__row {
  overflow: hidden;
}

.grows__track {
  display: flex;
  gap: 10px;
  width: max-content;
  margin: 0;
  padding: 0;
  list-style: none;
  animation: slide linear infinite;
}

.grows__row--rev .grows__track {
  animation-direction: reverse;
}

.grows--paused .grows__track,
.grows__row:hover .grows__track {
  animation-play-state: paused;
}

.grows__item {
  position: relative;
  display: block;
  width: clamp(220px, 20vw, 300px);
  aspect-ratio: 16 / 9;
  padding: 0;
  overflow: hidden;
  border: 0;
  background: var(--panel);
  cursor: zoom-in;
}

.grows__item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 500ms cubic-bezier(0.2, 0.8, 0.2, 1), filter 300ms ease;
}

.grows__label {
  position: absolute;
  left: 10px;
  bottom: 8px;
  padding: 3px 8px;
  font-size: 0.8rem;
  font-weight: 600;
  color: var(--hi);
  background: rgb(20 15 28 / 0.8);
  border-radius: 3px;
  opacity: 0;
  transform: translateY(6px);
  transition: opacity 200ms ease, transform 200ms ease;
}

.grows__item:hover img,
.grows__item:focus-visible img {
  transform: scale(1.07);
}

.grows__item:hover .grows__label,
.grows__item:focus-visible .grows__label {
  opacity: 1;
  transform: none;
}

@keyframes slide {
  to {
    transform: translateX(-50%);
  }
}

@media (max-width: 700px) {
  .grows__item {
    width: 200px;
  }

  .grows__pause {
    top: 8px;
    right: 8px;
    z-index: 2;
    background: rgb(20 15 28 / 0.75);
    border-radius: 50%;
  }
}
</style>
