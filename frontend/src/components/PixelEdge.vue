<script setup>
// Transição em pixels: a cor de cima se desfaz em quadradinhos sobre a de baixo.
// Com "animate", os pixels vão aparecendo um a um, descendo e "comendo" a página até parar.
const props = defineProps({
  top: { type: String, default: 'var(--byte)' },
  bottom: { type: String, default: 'var(--night)' },
  seed: { type: Number, default: 11 },
  rows: { type: Number, default: 6 },
  animate: { type: Boolean, default: false },
  spread: { type: Number, default: 2.2 },
})
const cell = 16
const cols = 160 // 2560px
let s = props.seed
const rand = () => ((s = (s * 9301 + 49297) % 233280) / 233280)
const cells = []
for (let r = 0; r < props.rows; r++) {
  const t = (r + 0.5) / props.rows
  // denso em cima, rarefeito embaixo; "spread" estica a cauda de pixels soltos
  const chance = Math.pow(1 - t, props.spread) + 0.02
  for (let c = 0; c < cols; c++) {
    if (rand() < chance) cells.push({ x: c * cell, y: r * cell, d: Math.round(r * 85 + rand() * 600) })
  }
}
</script>

<template>
  <svg
    class="pixels"
    :class="{ 'pixels--animate': animate }"
    :style="{ height: `${rows * cell}px` }"
    :viewBox="`0 0 ${cols * cell} ${rows * cell}`"
    preserveAspectRatio="xMidYMin slice"
    shape-rendering="crispEdges"
    aria-hidden="true"
  >
    <rect :width="cols * cell" :height="rows * cell" :fill="bottom" />
    <rect
      v-for="(c, i) in cells"
      :key="i"
      :x="c.x"
      :y="c.y"
      :width="cell"
      :height="cell"
      :fill="top"
      :style="animate ? { animationDelay: `${c.d}ms` } : undefined"
    />
  </svg>
</template>

<style scoped>
.pixels {
  display: block;
  width: 100%;
  margin-top: -1px;
}

/* cada pixel "acende" de uma vez, sem deslizar */
.pixels--animate rect + rect {
  animation: pop 1ms step-start backwards;
}

@keyframes pop {
  from {
    opacity: 0;
  }
}

@media (max-width: 600px) {
  .pixels {
    max-height: 200px;
  }
}
</style>
