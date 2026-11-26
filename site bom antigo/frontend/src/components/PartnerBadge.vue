<script setup>
// Selo oficial "Official Minecraft Partner" (arquivo original, fundo transparente).
import '@fontsource/pixelify-sans/500.css'
import badge from '../assets/partner-badge.webp'
defineProps({ small: { type: Boolean, default: false } })
</script>

<template>
  <span class="badge" :class="{ 'badge--small': small }">
    <img :src="badge" alt="Official Minecraft Partner badge" width="190" height="220" />
    <span class="badge__text">Official<br />Minecraft Partner</span>
  </span>
</template>

<style scoped>
.badge {
  display: inline-flex;
  align-items: center;
  gap: 14px;
}

.badge img {
  width: auto;
  height: 84px;
  filter: drop-shadow(3px 4px 0 rgb(0 0 0 / 0.25));
}

.badge__text {
  font-family: 'Pixelify Sans', var(--font);
  font-weight: 500;
  font-size: 1.3rem;
  line-height: 1.15;
  color: var(--white);
  text-shadow: 2px 2px 0 rgb(0 0 0 / 0.3);
}

.badge--small img {
  height: 56px;
}

.badge--small .badge__text {
  font-size: 1rem;
}
</style>
