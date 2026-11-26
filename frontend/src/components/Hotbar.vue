<script setup>
// Addons grátis como a hotbar do Minecraft: até 10 slots numerados, slot escolhido com
// moldura branca e o nome do item em cima da barra. Teclas 1–0 escolhem o slot.
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'

const props = defineProps({ items: { type: Array, required: true } })
const slots = computed(() => props.items.slice(0, 10))
const selected = ref(0)
const nameKey = ref(0) // reinicia a animação do nome a cada troca
const bar = ref(null)

function select(i, scroll = false) {
  if (i === selected.value) return
  selected.value = i
  nameKey.value++
  if (scroll) bar.value?.children[i]?.scrollIntoView({ block: 'nearest', inline: 'center', behavior: 'smooth' })
}

// só reage às teclas quando a hotbar está visível na tela
let visible = false
let io
function onKey(e) {
  if (!visible || e.ctrlKey || e.metaKey || e.altKey || /input|textarea/i.test(e.target.tagName)) return
  const n = e.key === '0' ? 9 : Number(e.key) - 1
  if (Number.isInteger(n) && n >= 0 && n < slots.value.length) select(n, true)
}
onMounted(() => {
  addEventListener('keydown', onKey)
  io = new IntersectionObserver(([e]) => (visible = e.isIntersecting))
  io.observe(bar.value)
})
onBeforeUnmount(() => {
  removeEventListener('keydown', onKey)
  io?.disconnect()
})
</script>

<template>
  <div class="hb">
    <p :key="nameKey" class="hb__name" aria-live="polite">{{ slots[selected]?.title }}</p>

    <ol ref="bar" class="hb__bar">
      <li v-for="(a, n) in slots" :key="a.slug">
        <a
          :href="a.link"
          target="_blank"
          rel="noopener"
          class="hb__slot"
          :class="{ 'is-on': n === selected }"
          @mouseenter="select(n)"
          @focus="select(n)"
        >
          <img :src="a.icon" alt="" width="144" height="144" class="hb__icon" />
          <span class="hb__num" aria-hidden="true">{{ (n + 1) % 10 }}</span>
          <span class="visually-hidden">{{ a.title }}, free add-on (opens the download page)</span>
        </a>
      </li>
    </ol>

    <p class="hb__hint">
      <span class="hb__keys" aria-hidden="true">1–{{ slots.length % 10 }}</span>
      Hover, tap or press a number to pick an add-on. Click to download.
    </p>
  </div>
</template>

<style scoped>
.hb {
  display: grid;
  justify-items: center;
  gap: 14px;
}

/* nome do item acima da barra, como no jogo: aparece e some devagar */
.hb__name {
  min-height: 1.6em;
  font-family: 'Pixelify Sans', var(--font);
  font-size: clamp(1.2rem, 2.2vw, 1.6rem);
  color: #fff;
  text-shadow: 3px 3px 0 #3f3f3f;
  animation: name 2600ms ease forwards;
}

@keyframes name {
  0%,
  70% {
    opacity: 1;
  }
  100% {
    opacity: 0.55;
  }
}

.hb__bar {
  --slot: clamp(64px, 7.4vw, 92px);
  display: flex;
  max-width: 100%;
  margin: 0;
  padding: 4px;
  overflow-x: auto;
  list-style: none;
  scroll-snap-type: x mandatory;
  scrollbar-width: none;
  background: rgb(10 7 15 / 0.75);
  border: 4px solid #0d0a12;
  box-shadow: inset 0 0 0 3px #4b4256;
}

.hb__bar::-webkit-scrollbar {
  display: none;
}

.hb__bar li {
  flex: none;
  scroll-snap-align: center;
}

.hb__slot {
  position: relative;
  display: grid;
  place-items: center;
  width: var(--slot);
  height: var(--slot);
  border: 3px solid #4b4256;
  border-right-width: 0;
  background: rgb(139 128 150 / 0.18);
  transition: background-color 120ms ease;
}

.hb__bar li:last-child .hb__slot {
  border-right-width: 3px;
}

.hb__slot:hover {
  background: rgb(139 128 150 / 0.32);
}

/* slot escolhido: moldura branca grossa, um pouco maior que o slot */
.hb__slot.is-on::after {
  content: '';
  position: absolute;
  inset: -7px;
  z-index: 2;
  border: 4px solid #f2f2f2;
  box-shadow: 0 0 0 2px #0d0a12, inset 0 0 0 2px #0d0a12;
  pointer-events: none;
}

.hb__slot:focus-visible {
  outline: none;
}

.hb__slot:focus-visible::after {
  border-color: var(--brass);
}

.hb__icon {
  width: 64%;
  height: auto;
  image-rendering: pixelated;
  filter: drop-shadow(3px 3px 0 rgb(0 0 0 / 0.45));
  transition: transform 200ms cubic-bezier(0.3, 1.6, 0.5, 1);
}

.hb__slot.is-on .hb__icon {
  transform: scale(1.1);
}

/* número da quantidade, no canto como no jogo */
.hb__num {
  position: absolute;
  right: 5px;
  bottom: 1px;
  font-family: 'Pixelify Sans', var(--font);
  font-size: clamp(1rem, 1.6vw, 1.3rem);
  line-height: 1;
  color: #fff;
  text-shadow: 2px 2px 0 #3f3f3f;
  pointer-events: none;
}

.hb__hint {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: var(--step--1);
  color: var(--mid);
  text-align: center;
}

.hb__keys {
  padding: 2px 8px;
  font-family: 'Pixelify Sans', var(--font);
  color: var(--hi);
  background: var(--panel);
  border: 1px solid var(--panel-hi);
  border-bottom-width: 3px;
  border-radius: 4px;
}

@media (hover: none), (max-width: 600px) {
  .hb__keys {
    display: none;
  }
}
</style>
