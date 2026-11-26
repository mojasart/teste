<script setup>
defineProps({
  project: { type: Object, required: true },
  wide: { type: Boolean, default: false },
})
</script>

<template>
  <article class="card lift" :class="{ 'card--wide': wide }" :style="{ '--lift-color': project.accent_color }">
    <RouterLink :to="`/projetos/${project.slug}`" class="card__inner chamfer">
      <div class="card__media">
        <img
          v-if="project.cover_image || project.banner_image"
          :src="wide ? project.banner_image || project.cover_image : project.cover_image || project.banner_image"
          :alt="''"
          loading="lazy"
        />
      </div>
      <div class="card__body">
        <h3 class="card__title">{{ project.title }}</h3>
        <p v-if="project.tagline" class="card__tagline">{{ project.tagline }}</p>
        <p v-if="project.category" class="card__cat">{{ project.category.name }}</p>
      </div>
    </RouterLink>
  </article>
</template>

<style scoped>
.card {
  --lift: 8px;
  transition: filter 120ms ease, transform 120ms ease;
}

.card:hover,
.card:focus-within {
  --lift: 12px;
  transform: translate(-3px, -3px);
}

.card__inner {
  display: flex;
  flex-direction: column;
  height: 100%;
  background: var(--white);
  text-decoration: none;
  color: var(--ink);
}

.card__inner:focus-visible {
  outline: none;
}

.card:focus-within {
  outline: 3px solid var(--brass);
  outline-offset: 6px;
}

.card__media {
  aspect-ratio: 16 / 9;
  background: var(--ink);
  overflow: hidden;
}

.card__media img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 400ms cubic-bezier(0.2, 0.8, 0.2, 1);
}

.card:hover .card__media img {
  transform: scale(1.06);
}

.card__body {
  display: grid;
  gap: 6px;
  padding: 18px 22px 24px;
}

.card__title {
  font-size: var(--step-2);
}

.card__tagline {
  color: var(--muted);
}

.card__cat {
  font-size: var(--step--1);
  font-weight: 700;
  color: var(--byte-deep);
}

/* destaque: imagem e texto lado a lado */
@media (min-width: 860px) {
  .card--wide .card__inner {
    display: grid;
    grid-template-columns: 2.2fr 1fr;
  }

  .card--wide .card__media {
    aspect-ratio: auto;
    min-height: 340px;
  }

  .card--wide .card__body {
    align-content: end;
    padding: 32px;
  }

  .card--wide .card__title {
    font-size: var(--step-3);
  }
}
</style>
