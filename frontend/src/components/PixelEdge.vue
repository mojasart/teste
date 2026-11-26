<script setup>
// Transição em pixels: a cor de cima se desfaz em quadradinhos sobre a de baixo.
// Com "animate", os pixels vão descendo e "comendo" a página até parar.
const props = defineProps({
  top: { type: String, default: 'var(--byte)' },
  bottom: { type: String, default: 'var(--night)' },
  seed: { type: Number, default: 11 },
  rows: { type: Number, default: 6 },
  animate: { type: Boolean, default: false },
})
const cell = 16
const cols = 160 // 2560px
let s = props.seed
const rand = () => ((s = (s * 9301 + 49297) % 233280) / 233280)
const cells = []
for (let r = 0; r < props.rows; r++) {
  const chance = 1 - (r + 0.6) / props.rows
  for (let c = 0; c < cols; c++) {
    if (rand() < chance * chance + 0.04) cells.push({ x: c * cell, y: r * cell, d: r * 110 + rand() * 260 })
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

.pixels--animate rect + rect {
  transform-box: fill-box;
  transform-origin: top;
  animation: drip 380ms steps(4, end) backwards;
}

@keyframes drip {
  from {
    opacity: 0;
    transform: translateY(-100%) scaleY(0.25);
  }
}

@media (max-width: 600px) {
  .pixels {
    max-height: 72px;
  }
}
</style>
