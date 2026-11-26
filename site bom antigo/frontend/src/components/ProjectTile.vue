<script setup>
// Projeto como arte grande + legenda curta (sem caixa). Brilho na cor do addon ao passar o mouse.
defineProps({
  project: { type: Object, required: true },
  big: { type: Boolean, default: false },
})
</script>

<template>
  <RouterLink :to="`/projects/${project.slug}`" class="tile" :class="{ 'tile--big': big }" :style="{ '--accent': project.accent_color }">
    <div class="tile__media">
      <img :src="project.cover_image || project.banner_image" alt="" loading="lazy" />
    </div>
    <div class="tile__cap">
      <h3 class="tile__title">{{ project.title }}</h3>
      <p v-if="project.tagline" class="tile__tag">{{ project.tagline }}</p>
    </div>
  </RouterLink>
</template>

<style scoped>
.tile {
  display: grid;
  gap: 14px;
  align-content: start;
  color: var(--hi);
  text-decoration: none;
}

.tile__media {
  position: relative;
  aspect-ratio: 16 / 9;
  overflow: hidden;
  border-radius: 8px;
  background: var(--night-2);
  transition: transform 260ms cubic-bezier(0.2, 0.8, 0.2, 1), box-shadow 260ms ease;
}

.tile__media img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 600ms cubic-bezier(0.2, 0.8, 0.2, 1);
}

.tile:hover .tile__media,
.tile:focus-visible .tile__media {
  transform: translateY(-6px);
  box-shadow:
    0 0 0 2px var(--accent),
    0 24px 60px -18px var(--accent);
}

.tile:hover .tile__media img {
  transform: scale(1.05);
}

.tile:focus-visible {
  outline: none;
}

.tile__cap {
  display: grid;
  gap: 2px;
}

.tile__title {
  font-size: var(--step-1);
  font-stretch: 85%;
}

.tile--big .tile__title {
  font-size: var(--step-2);
}

.tile__tag {
  color: var(--mid);
  font-size: var(--step--1);
}

/* celular: arte ao lado do texto, em vez de em cima */
@media (max-width: 600px) {
  .tile,
  .tile--big {
    grid-template-columns: 46% minmax(0, 1fr);
    align-items: center;
    gap: 14px;
  }

  .tile__media {
    border-radius: 6px;
  }

  .tile__title,
  .tile--big .tile__title {
    font-size: 1.12rem;
    line-height: 1.1;
  }

  .tile__tag {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    font-size: 0.82rem;
    line-height: 1.35;
  }

  .tile:hover .tile__media,
  .tile:focus-visible .tile__media {
    transform: none;
  }
}
</style>
