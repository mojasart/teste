<script setup>
// Addons grátis como um inventário do Minecraft: slots com o ícone e tooltip no estilo do jogo.
import { computed } from 'vue'
const props = defineProps({ items: { type: Array, required: true } })
// completa a grade com slots vazios, como no jogo (múltiplo de 18 fecha em 9, 6 ou 3 colunas)
const empty = computed(() => (18 - (props.items.length % 18)) % 18)
</script>

<template>
  <ul class="inv" role="list">
    <li v-for="(a, n) in items" :key="a.slug" v-reveal="n % 6" class="inv__cell">
      <a :href="a.link" target="_blank" rel="noopener" class="slot">
        <span class="slot__box">
          <img :src="a.icon" alt="" width="144" height="144" class="slot__icon" />
        </span>
        <span class="slot__name">{{ a.title }}</span>
        <span class="tip" role="tooltip">
          <span class="tip__name">{{ a.title }}</span>
          <span class="tip__line">Free add-on</span>
          <span class="tip__line tip__line--go">Download ↗</span>
        </span>
      </a>
    </li>
    <li v-for="n in empty" :key="`e${n}`" class="inv__cell" aria-hidden="true">
      <span class="slot__box slot__box--empty"></span>
    </li>
  </ul>
</template>

<style scoped>
.inv {
  display: grid;
  grid-template-columns: repeat(9, minmax(0, 1fr));
  gap: 14px 10px;
  margin: 0;
  padding: clamp(14px, 2vw, 22px);
  list-style: none;
  background: #2a2036;
  border: 4px solid #120c1a;
  box-shadow:
    inset 4px 4px 0 #3e3150,
    inset -4px -4px 0 #1b1424;
}

.slot {
  position: relative;
  display: grid;
  justify-items: center;
  gap: 8px;
  color: var(--hi);
  text-decoration: none;
}

/* slot do jogo: borda escura em cima/esquerda, clara embaixo/direita */
.slot__box {
  display: grid;
  place-items: center;
  width: 100%;
  aspect-ratio: 1;
  background: #1a1222;
  box-shadow:
    inset 3px 3px 0 #0d0812,
    inset -3px -3px 0 #4a3a5e;
  transition: background-color 150ms ease;
}

.slot__box--empty {
  opacity: 0.6;
}

.slot__icon {
  width: 62%;
  height: auto;
  image-rendering: pixelated;
  filter: drop-shadow(3px 3px 0 rgb(0 0 0 / 0.45));
  transition: transform 220ms cubic-bezier(0.3, 1.6, 0.5, 1);
}

.slot__name {
  font-size: 0.82rem;
  font-weight: 600;
  line-height: 1.2;
  text-align: center;
  color: var(--mid);
  transition: color 150ms ease;
}

.slot:hover .slot__box,
.slot:focus-visible .slot__box {
  background: #5a4673;
}

.slot:hover .slot__icon,
.slot:focus-visible .slot__box--empty {
  opacity: 0.6;
}

.slot__icon {
  transform: scale(1.12) rotate(-4deg);
}

.slot:hover .slot__name,
.slot:focus-visible .slot__name {
  color: var(--hi);
}

.slot:focus-visible {
  outline: none;
}

.slot:focus-visible .slot__box {
  outline: 3px solid var(--brass);
  outline-offset: 2px;
}

/* tooltip igual à do jogo: fundo quase preto e moldura roxa em degradê */
.tip {
  position: absolute;
  left: 50%;
  bottom: calc(100% + 6px);
  z-index: 5;
  display: grid;
  gap: 2px;
  min-width: max-content;
  padding: 8px 12px;
  font-family: 'Pixelify Sans', var(--font);
  font-size: 0.9rem;
  line-height: 1.25;
  background: rgb(16 4 22 / 0.96);
  border: 2px solid transparent;
  border-image: linear-gradient(#5e1fd6, #2a0d63) 1;
  outline: 2px solid rgb(16 4 22 / 0.96);
  pointer-events: none;
  opacity: 0;
  transform: translate(-50%, 6px);
  transition: opacity 120ms ease, transform 120ms ease;
}

.tip__name {
  color: #fff;
  text-shadow: 2px 2px 0 #3f3f3f;
}

.tip__line {
  color: #a8a8a8;
}

.tip__line--go {
  color: #55ffff;
}

.slot:hover .tip,
.slot:focus-visible .tip {
  opacity: 1;
  transform: translate(-50%, 0);
}

@media (hover: none) {
  .tip {
    display: none;
  }
}

@media (max-width: 1000px) {
  .inv {
    grid-template-columns: repeat(6, minmax(0, 1fr));
  }
}

@media (max-width: 520px) {
  .inv {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    padding: 10px;
    gap: 12px 8px;
  }

  .slot__name {
    font-size: 0.75rem;
  }
}
</style>
