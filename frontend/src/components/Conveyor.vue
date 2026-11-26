<script setup>
import { computed } from 'vue'

// Esteira de fábrica: as capas dos projetos passam em loop.
const props = defineProps({ projects: { type: Array, required: true } })

const items = computed(() => {
  const withImage = props.projects.filter((p) => p.cover_image || p.banner_image)
  if (!withImage.length) return []
  // repete até ter itens suficientes para cobrir a tela, depois duplica para o loop sem emenda
  let base = [...withImage]
  while (base.length < 8) base = base.concat(withImage)
  return [...base, ...base]
})
const duration = computed(() => `${Math.max(30, items.value.length * 3.2)}s`)
</script>

<template>
  <div v-if="items.length" class="belt" :style="{ '--duration': duration }">
    <div class="belt__rail" aria-hidden="true" />
    <ul class="belt__track">
      <li v-for="(p, i) in items" :key="i" :aria-hidden="i >= items.length / 2">
        <RouterLink
          :to="`/projetos/${p.slug}`"
          class="belt__item"
          :tabindex="i >= items.length / 2 ? -1 : undefined"
          :style="{ '--accent': p.accent_color }"
        >
          <img :src="p.cover_image || p.banner_image" :alt="p.title" loading="lazy" />
        </RouterLink>
      </li>
    </ul>
    <div class="belt__rail" aria-hidden="true" />
  </div>
</template>

<style scoped>
.belt {
  position: relative;
  transform: rotate(-2deg);
  margin-inline: -40px;
}

.belt__rail {
  height: 14px;
  background:
    repeating-linear-gradient(90deg, var(--ink) 0 22px, #3b1d70 22px 30px);
  background-size: 30px 100%;
  animation: roll 0.9s linear infinite;
}

.belt__track {
  display: flex;
  gap: 18px;
  width: max-content;
  margin: 0;
  padding: 18px 0;
  list-style: none;
  background: var(--ink);
  animation: slide var(--duration) linear infinite;
}

.belt:hover .belt__track,
.belt:focus-within .belt__track,
.belt:hover .belt__rail {
  animation-play-state: paused;
}

.belt__item {
  display: block;
  width: clamp(200px, 22vw, 300px);
  aspect-ratio: 16 / 9;
  border-radius: 4px;
  overflow: hidden;
  box-shadow: 0 0 0 3px var(--ink), 0 0 0 6px var(--accent);
  transition: transform 160ms ease;
}

.belt__item:hover,
.belt__item:focus-visible {
  transform: translateY(-6px) scale(1.04);
}

.belt__item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

@keyframes slide {
  to {
    transform: translateX(-50%);
  }
}

@keyframes roll {
  to {
    background-position: -30px 0;
  }
}

@media (prefers-reduced-motion: reduce) {
  .belt__track {
    animation: none;
    overflow-x: auto;
    width: auto;
  }
}
</style>
