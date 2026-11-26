<script setup>
// Selo "Official Minecraft Partner".
// Para usar o selo oficial da Mojang: salve o arquivo do kit de parceiro como
// frontend/src/assets/partner-badge.png (ou .svg/.webp) e rode o build. Sem o arquivo, usa o desenho abaixo.
const files = import.meta.glob('../assets/partner-badge.{png,svg,webp}', { eager: true, import: 'default' })
const official = Object.values(files)[0]
defineProps({ small: { type: Boolean, default: false } })
</script>

<template>
  <img v-if="official" :src="official" alt="Official Minecraft Partner" class="official" :class="{ 'official--small': small }" />
  <span v-else class="badge" :class="{ 'badge--small': small }">
    <svg viewBox="0 0 24 28" aria-hidden="true">
      <path d="M12 1 23 6v8c0 6.5-4.6 11.2-11 13C5.6 25.2 1 20.5 1 14V6z" fill="var(--brass)" />
      <path d="M12 4.2 20 7.8v6.1c0 4.9-3.3 8.6-8 10-4.7-1.4-8-5.1-8-10V7.8z" fill="var(--brass-deep)" />
      <path d="m7.5 13.6 3 3 6-6.2" fill="none" stroke="#fff" stroke-width="2.6" stroke-linecap="square" />
    </svg>
    Official Minecraft Partner
  </span>
</template>

<style scoped>
.official {
  height: 56px;
  width: auto;
}

.official--small {
  height: 40px;
}

.badge {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  font-weight: 700;
  font-size: var(--step--1);
  letter-spacing: 0.01em;
}

.badge svg {
  width: 22px;
  height: auto;
  flex: none;
}

.badge--small svg {
  width: 16px;
}
</style>
