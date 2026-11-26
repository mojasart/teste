<script setup>
import { onBeforeUnmount, onMounted, ref } from 'vue'
// Marca da PurpleByte em SVG: quadro partido em 4 peças + engrenagem.
// Com "animate", as peças encaixam e a engrenagem trava girando 45°.
const props = defineProps({
  animate: { type: Boolean, default: false },
  gap: { type: String, default: 'var(--byte)' }, // cor do fundo atrás da marca
  ink: { type: String, default: '#fff' }, // cor da marca
  shade: { type: String, default: 'var(--byte-deep)' }, // sombra dura
  title: { type: String, default: 'PurpleByte Studios' },
  spin: { type: Boolean, default: false }, // engrenagem gira com a rolagem
})

const turn = ref(0)
let raf = 0
const onScroll = () => {
  cancelAnimationFrame(raf)
  raf = requestAnimationFrame(() => (turn.value = window.scrollY * 0.25))
}
onMounted(() => {
  if (props.spin && !matchMedia('(prefers-reduced-motion: reduce)').matches) {
    addEventListener('scroll', onScroll, { passive: true })
  }
})
onBeforeUnmount(() => removeEventListener('scroll', onScroll))

const uid = Math.random().toString(36).slice(2, 8)

function gearPath() {
  const c = 50
  const teeth = 8
  const ro = 31
  const ri = 24
  const pts = []
  for (let i = 0; i < teeth; i++) {
    const a = (i * 360) / teeth
    for (const [da, r] of [[-13, ri], [-8, ro], [8, ro], [13, ri]]) {
      const rad = ((a + da - 90) * Math.PI) / 180
      pts.push([c + r * Math.cos(rad), c + r * Math.sin(rad)])
    }
  }
  const star = []
  for (let i = 0; i < 16; i++) {
    const r = i % 2 ? 6.4 : 8.6
    const rad = ((i * 22.5 - 90) * Math.PI) / 180
    star.push([c + r * Math.cos(rad), c + r * Math.sin(rad)])
  }
  const d = (p) => 'M' + p.map(([x, y]) => `${x.toFixed(2)},${y.toFixed(2)}`).join('L') + 'Z'
  return d(pts) + d(star)
}

const gear = gearPath()
const frame = 'M13,13 H73 A14,14 0 0 1 87,27 V87 H27 A14,14 0 0 1 13,73 Z'
// peças em cata-vento, cortadas por raios a partir do centro
const T = '66,-20', R = '120,66', B = '34,120', L = '-20,34', C = '50,50'
const pieces = [
  { clip: `${C} ${L} -20,-20 ${T}`, from: [-10, -10] },
  { clip: `${C} ${T} 120,-20 ${R}`, from: [10, -10] },
  { clip: `${C} ${R} 120,120 ${B}`, from: [10, 10] },
  { clip: `${C} ${B} -20,120 ${L}`, from: [-10, 10] },
]
</script>

<template>
  <svg class="mark" :class="{ 'mark--animate': props.animate }" viewBox="0 0 100 100" role="img" :aria-label="title">
    <defs>
      <clipPath v-for="(p, i) in pieces" :id="`pb-${uid}-${i}`" :key="i">
        <polygon :points="p.clip" />
      </clipPath>
      <mask :id="`pb-${uid}-gaps`">
        <rect x="-10" y="-10" width="120" height="120" fill="#fff" />
        <g stroke="#000" stroke-width="3.2">
          <line x1="50" y1="50" x2="66" y2="-20" />
          <line x1="50" y1="50" x2="120" y2="66" />
          <line x1="50" y1="50" x2="34" y2="120" />
          <line x1="50" y1="50" x2="-20" y2="34" />
        </g>
      </mask>
    </defs>

    <g :mask="`url(#pb-${uid}-gaps)`">
      <g
        v-for="(p, i) in pieces"
        :key="i"
        class="mark__piece"
        :style="{ '--dx': p.from[0] + 'px', '--dy': p.from[1] + 'px', '--i': i }"
        :clip-path="`url(#pb-${uid}-${i})`"
      >
        <path :d="frame" fill="none" :stroke="shade" stroke-width="14" transform="translate(-2.5 3)" />
        <path :d="frame" fill="none" :stroke="ink" stroke-width="14" />
      </g>
    </g>

    <g class="mark__gear">
      <g transform="translate(-2.5 3)">
        <g class="mark__spin" :style="{ transform: `rotate(${turn}deg)` }">
          <path :d="gear" :fill="shade" fill-rule="evenodd" />
        </g>
      </g>
      <g class="mark__spin" :style="{ transform: `rotate(${turn}deg)` }">
        <path :d="gear" :fill="ink" fill-rule="evenodd" :stroke="gap" stroke-width="3" paint-order="stroke" />
      </g>
    </g>
  </svg>
</template>

<style scoped>
.mark {
  display: block;
  width: 100%;
  height: auto;
  overflow: visible;
}

.mark__gear,
.mark__spin {
  transform-box: view-box;
  transform-origin: 50px 50px;
}

.mark--animate .mark__piece {
  animation: snap 620ms cubic-bezier(0.2, 1.5, 0.4, 1) both;
  animation-delay: calc(var(--i) * 70ms + 120ms);
}

.mark--animate .mark__gear {
  animation: lock 900ms cubic-bezier(0.3, 1.6, 0.5, 1) 520ms both;
}

@keyframes snap {
  from {
    opacity: 0;
    transform: translate(var(--dx), var(--dy));
  }
}

@keyframes lock {
  from {
    transform: rotate(-45deg) scale(0.6);
    opacity: 0;
  }
  40% {
    opacity: 1;
  }
}
</style>
