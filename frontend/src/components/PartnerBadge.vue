<script setup>
// Selo "Official Minecraft Partner": hexágono oficial + texto em fonte pixelada.
import '@fontsource/pixelify-sans/500.css'
import hex from '../assets/partner-badge-hex.png'
defineProps({ small: { type: Boolean, default: false } })
</script>

<template>
  <span class="badge" :class="{ 'badge--small': small }">
    <img :src="hex" alt="" width="198" height="183" />
    <span>Official Minecraft Partner</span>
  </span>
</template>

<style scoped>
.badge {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  font-family: 'Pixelify Sans', var(--font);
  font-weight: 500;
  font-size: 1.15rem;
  color: var(--white);
  text-shadow: 2px 2px 0 rgb(0 0 0 / 0.35);
}

.badge img {
  width: auto;
  height: 52px;
}

.badge--small {
  font-size: 1rem;
}

.badge--small img {
  height: 40px;
}
</style>
