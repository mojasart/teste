<script setup>
// Cartão horizontal de um addon premium: arte de um lado, texto do outro.
defineProps({
  addon: { type: Object, required: true },
  flip: { type: Boolean, default: false },
})
</script>

<template>
  <RouterLink :to="`/addons/${addon.slug}`" class="row" :class="{ 'row--flip': flip }" :style="{ '--tint': addon.accent }">
    <div class="row__art">
      <img :src="addon.keyart" :alt="`${addon.title} key art`" loading="lazy" />
    </div>
    <div class="row__text">
      <span class="row__meta">{{ addon.badge || 'Premium add-on' }}</span>
      <h3 class="row__title display">{{ addon.title }}</h3>
      <p class="row__tag">{{ addon.tagline }}</p>
      <span class="row__go">
        Explore add-on
        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h13M12 6l6 6-6 6" /></svg>
      </span>
    </div>
  </RouterLink>
</template>

<style scoped>
.row {
  display: grid;
  grid-template-columns: minmax(0, 1.35fr) minmax(0, 1fr);
  align-items: center;
  overflow: hidden;
  color: var(--hi);
  text-decoration: none;
  background: var(--bg-2);
  border: 1px solid var(--panel-hi);
  border-left: 4px solid var(--tint);
  border-radius: 4px;
  transition: transform 260ms cubic-bezier(0.2, 0.8, 0.2, 1), border-color 260ms ease, box-shadow 260ms ease;
}

.row:hover,
.row:focus-visible {
  transform: translateY(-5px);
  border-color: var(--tint);
  box-shadow: 0 30px 60px -30px var(--tint);
}

.row__art {
  aspect-ratio: 16 / 9;
  overflow: hidden;
}

.row__art img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 700ms cubic-bezier(0.2, 0.8, 0.2, 1);
}

.row:hover .row__art img {
  transform: scale(1.05);
}

.row__text {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 10px;
  padding: clamp(20px, 3.4vw, 48px);
}

/* linhas pares: arte do outro lado (zigue-zague) */
.row--flip {
  grid-template-columns: minmax(0, 1fr) minmax(0, 1.35fr);
  border-left: 1px solid var(--panel-hi);
  border-right: 4px solid var(--tint);
}

.row--flip .row__art {
  order: 2;
}

.row__meta {
  font-size: 0.8rem;
  color: var(--mid);
}

.row__title {
  font-size: clamp(2.2rem, 4vw, 3.6rem);
  line-height: 0.92;
  text-transform: uppercase;
}

.row__tag {
  color: var(--mid);
}

.row__go {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding-top: 12px;
  font-weight: 600;
}

.row__go svg {
  width: 18px;
  height: 18px;
  fill: none;
  stroke: currentColor;
  stroke-width: 2.4;
  transition: transform 200ms ease;
}

.row:hover .row__go svg {
  transform: translateX(4px);
}

@media (max-width: 560px) {
  .row,
  .row--flip {
    grid-template-columns: 1fr;
  }

  .row--flip .row__art {
    order: 0;
  }
}
</style>
