<script setup>
// Transição em pixels: a cor de cima se desfaz em quadradinhos sobre a de baixo.
const props = defineProps({
  top: { type: String, default: 'var(--byte)' },
  bottom: { type: String, default: 'var(--night)' },
  seed: { type: Number, default: 11 },
})
const cell = 16
const cols = 160 // 2560px
const rows = 6
let s = props.seed
const rand = () => ((s = (s * 9301 + 49297) % 233280) / 233280)
const cells = []
for (let r = 0; r < rows; r++) {
  const chance = 1 - (r + 0.6) / rows
  for (let c = 0; c < cols; c++) if (rand() < chance * chance + 0.04) cells.push([c * cell, r * cell])
}
</script>

<template>
  <svg class="pixels" :viewBox="`0 0 ${cols * cell} ${rows * cell}`" preserveAspectRatio="xMidYMin slice" aria-hidden="true">
    <rect :width="cols * cell" :height="rows * cell" :fill="bottom" />
    <rect v-for="([x, y], i) in cells" :key="i" :x="x" :y="y" :width="cell" :height="cell" :fill="top" />
  </svg>
</template>

<style scoped>
.pixels {
  display: block;
  width: 100%;
  height: 96px;
  margin-top: -1px;
}

@media (max-width: 600px) {
  .pixels {
    height: 64px;
  }
}
</style>
