<script setup>
// Visualizador em tela cheia: setas, teclado (← → Esc) e deslizar no celular.
import { computed, onBeforeUnmount, ref, watch } from 'vue'

const props = defineProps({
  items: { type: Array, required: true }, // [{ src, alt, title? }]
  index: { type: Number, default: -1 }, // -1 = fechado
})
const emit = defineEmits(['update:index'])

const dlg = ref(null)
const current = computed(() => props.items[props.index])
const go = (d) => emit('update:index', (props.index + d + props.items.length) % props.items.length)
const close = () => emit('update:index', -1)

watch(
  () => props.index,
  (i) => {
    if (i >= 0 && !dlg.value?.open) dlg.value?.showModal()
    if (i < 0 && dlg.value?.open) dlg.value.close()
  }
)

const onKey = (e) => {
  if (props.index < 0) return
  if (e.key === 'ArrowRight') go(1)
  if (e.key === 'ArrowLeft') go(-1)
}
addEventListener('keydown', onKey)
onBeforeUnmount(() => removeEventListener('keydown', onKey))

let startX = 0
const touchStart = (e) => (startX = e.touches[0].clientX)
const touchEnd = (e) => {
  const dx = e.changedTouches[0].clientX - startX
  if (Math.abs(dx) > 50) go(dx < 0 ? 1 : -1)
}
</script>

<template>
  <dialog ref="dlg" class="lb" aria-label="Image viewer" @close="close" @click.self="close">
    <figure v-if="current" class="lb__fig" @touchstart.passive="touchStart" @touchend.passive="touchEnd">
      <img :key="current.src" :src="current.src" :alt="current.alt" class="lb__img" />
      <figcaption class="lb__cap">
        <span class="lb__count">{{ index + 1 }} / {{ items.length }}</span>
        <span>{{ current.alt }}</span>
      </figcaption>
    </figure>
    <button type="button" class="lb__btn lb__btn--prev" @click="go(-1)">
      <span class="visually-hidden">Previous image</span>
      <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M15 5l-7 7 7 7" /></svg>
    </button>
    <button type="button" class="lb__btn lb__btn--next" @click="go(1)">
      <span class="visually-hidden">Next image</span>
      <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9 5l7 7-7 7" /></svg>
    </button>
    <button type="button" class="lb__btn lb__btn--close" @click="close">
      <span class="visually-hidden">Close</span>
      <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 6l12 12M18 6L6 18" /></svg>
    </button>
  </dialog>
</template>

<style scoped>
.lb {
  width: 100vw;
  max-width: 100vw;
  height: 100dvh;
  max-height: 100dvh;
  margin: 0;
  padding: 0;
  border: 0;
  color: var(--hi);
  background: transparent;
}

.lb::backdrop {
  background: rgb(12 8 18 / 0.94);
}

.lb[open] {
  display: grid;
  place-items: center;
}

.lb__fig {
  display: grid;
  gap: 14px;
  justify-items: center;
  margin: 0;
  padding: 0 72px;
}

.lb__img {
  max-width: min(1400px, 100%);
  max-height: 80dvh;
  border-radius: 6px;
  animation: in 260ms ease;
}

@keyframes in {
  from {
    opacity: 0;
    transform: scale(0.98);
  }
}

.lb__cap {
  display: grid;
  gap: 2px;
  text-align: center;
  font-size: var(--step--1);
  color: var(--mid);
}

.lb__count {
  color: var(--hi);
}

.lb__btn {
  position: fixed;
  display: grid;
  place-items: center;
  width: 48px;
  height: 48px;
  color: var(--hi);
  background: rgb(43 34 56 / 0.85);
  border: 1px solid var(--panel-hi);
  border-radius: 6px;
  cursor: pointer;
}

.lb__btn:hover {
  background: var(--accent);
}

.lb__btn svg {
  width: 22px;
  height: 22px;
  fill: none;
  stroke: currentColor;
  stroke-width: 2.4;
}

.lb__btn--prev {
  left: 16px;
  top: 50%;
  translate: 0 -50%;
}

.lb__btn--next {
  right: 16px;
  top: 50%;
  translate: 0 -50%;
}

.lb__btn--close {
  top: calc(16px + env(safe-area-inset-top, 0px));
  right: 16px;
}

@media (max-width: 700px) {
  .lb__fig {
    padding: 0 12px;
  }

  .lb__btn--prev,
  .lb__btn--next {
    top: auto;
    bottom: calc(20px + env(safe-area-inset-bottom, 0px));
    translate: none;
  }
}
</style>
