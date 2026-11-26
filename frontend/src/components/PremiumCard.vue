<script setup>
defineProps({ addon: { type: Object, required: true } })
</script>

<template>
  <RouterLink :to="`/addons/${addon.slug}`" class="pcard" :style="{ '--accent': addon.accent_color }">
    <div class="pcard__art">
      <img :src="addon.cover_image" :alt="`${addon.title} key art`" loading="lazy" />
    </div>
    <div class="pcard__name">
      <h3 class="display">{{ addon.title }}</h3>
      <svg class="pcard__arrow" viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h13M12 6l6 6-6 6" /></svg>
    </div>
  </RouterLink>
</template>

<style scoped>
.pcard {
  display: flex;
  flex-direction: column;
  overflow: hidden;
  color: var(--hi);
  text-decoration: none;
  background: var(--panel);
  border-radius: 6px;
  box-shadow: 0 24px 50px -24px rgb(0 0 0 / 0.8);
  transition: transform 320ms cubic-bezier(0.2, 0.8, 0.2, 1), box-shadow 320ms ease;
}

.pcard:hover,
.pcard:focus-visible {
  transform: translateY(-10px);
  box-shadow:
    0 0 0 2px var(--accent),
    0 34px 70px -26px var(--accent);
}

.pcard__art {
  aspect-ratio: 16 / 9;
  overflow: hidden;
}

.pcard__art img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 700ms cubic-bezier(0.2, 0.8, 0.2, 1);
}

.pcard:hover .pcard__art img {
  transform: scale(1.06);
}

.pcard__name {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: clamp(16px, 2vw, 22px) clamp(18px, 2.2vw, 26px);
  background: linear-gradient(180deg, var(--panel), var(--bg-2));
}

.pcard__name h3 {
  font-size: clamp(1.6rem, 2.6vw, 2.2rem);
  line-height: 1;
  text-transform: uppercase;
}

.pcard__arrow {
  flex: none;
  width: 24px;
  height: 24px;
  fill: none;
  stroke: currentColor;
  stroke-width: 2.4;
  opacity: 0;
  transform: translateX(-8px);
  transition: opacity 250ms ease, transform 250ms ease;
}

.pcard:hover .pcard__arrow {
  opacity: 1;
  transform: none;
}

@media (hover: none) {
  .pcard__arrow {
    opacity: 1;
    transform: none;
  }
}
</style>
