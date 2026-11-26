<script setup>
defineProps({ addon: { type: Object, required: true } })
</script>

<template>
  <component
    :is="addon.marketplace_url ? 'a' : 'div'"
    :href="addon.marketplace_url || undefined"
    :target="addon.marketplace_url ? '_blank' : undefined"
    :rel="addon.marketplace_url ? 'noopener' : undefined"
    class="fcard"
    :class="{ 'fcard--link': addon.marketplace_url }"
  >
    <img class="fcard__glow" :src="addon.cover_image" alt="" aria-hidden="true" />
    <span class="fcard__icon"><img :src="addon.cover_image" alt="" width="144" height="144" /></span>
    <span class="fcard__name">{{ addon.title }}</span>
    <svg v-if="addon.marketplace_url" class="fcard__go" viewBox="0 0 24 24" aria-hidden="true"><path d="M7 17L17 7M9 7h8v8" /></svg>
    <span v-if="addon.marketplace_url" class="visually-hidden">(opens the download page)</span>
  </component>
</template>

<style scoped>
.fcard {
  position: relative;
  display: flex;
  align-items: center;
  gap: 16px;
  min-height: 82px;
  padding: 14px 18px 14px 14px;
  overflow: hidden;
  isolation: isolate;
  color: var(--hi);
  text-decoration: none;
  background: var(--panel);
  border: 1px solid rgb(255 255 255 / 0.06);
  border-radius: 4px;
  transition: transform 220ms ease, border-color 220ms ease, background-color 220ms ease;
}

/* o próprio ícone, ampliado e desfocado, colore o fundo do cartão */
.fcard__glow {
  position: absolute;
  right: -10%;
  top: 50%;
  z-index: -1;
  width: 60%;
  height: auto;
  image-rendering: pixelated;
  opacity: 0.22;
  filter: blur(2px) saturate(1.2);
  transform: translateY(-50%) scale(1.6);
  mask-image: linear-gradient(90deg, transparent, #000 60%);
  transition: opacity 300ms ease, transform 600ms cubic-bezier(0.2, 0.8, 0.2, 1);
}

.fcard__icon {
  flex: none;
  display: grid;
  place-items: center;
  width: 52px;
  height: 52px;
  background: rgb(0 0 0 / 0.25);
  border-radius: 4px;
}

.fcard__icon img {
  width: 48px;
  height: 48px;
  image-rendering: pixelated;
  transition: transform 300ms cubic-bezier(0.3, 1.6, 0.5, 1);
}

.fcard__name {
  flex: 1;
  font-weight: 600;
}

.fcard__go {
  flex: none;
  width: 16px;
  height: 16px;
  fill: none;
  stroke: var(--mid);
  stroke-width: 2.2;
  transition: transform 200ms ease, stroke 200ms ease;
}

.fcard--link:hover,
.fcard--link:focus-visible {
  transform: translateY(-3px);
  background: var(--panel-hi);
  border-color: var(--accent-hi);
}

.fcard--link:hover .fcard__glow {
  opacity: 0.38;
  transform: translateY(-50%) scale(1.75);
}

.fcard--link:hover .fcard__icon img {
  transform: scale(1.12) rotate(-6deg);
}

.fcard--link:hover .fcard__go {
  stroke: var(--hi);
  transform: translate(2px, -2px);
}
</style>
