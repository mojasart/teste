<script setup>
// Engrenagens grandes e apagadas espalhadas pelo fundo, girando devagar.
import gear from '../assets/gear.svg'

const gears = [
  { top: '4%', left: '-9%', size: 520, speed: 120, dir: 1 },
  { top: '22%', right: '-12%', size: 640, speed: 160, dir: -1 },
  { top: '46%', left: '-14%', size: 600, speed: 140, dir: -1 },
  { top: '64%', right: '-8%', size: 460, speed: 110, dir: 1 },
  { top: '84%', left: '6%', size: 380, speed: 100, dir: 1 },
]
</script>

<template>
  <div class="gears" aria-hidden="true">
    <img
      v-for="(g, i) in gears"
      :key="i"
      :src="gear"
      alt=""
      class="gear"
      :style="{
        top: g.top,
        left: g.left,
        right: g.right,
        width: `${g.size}px`,
        animationDuration: `${g.speed}s`,
        animationDirection: g.dir > 0 ? 'normal' : 'reverse',
      }"
    />
  </div>
</template>

<style scoped>
.gears {
  position: absolute;
  inset: 0;
  z-index: -1;
  overflow: hidden;
  pointer-events: none;
}

.gear {
  position: absolute;
  height: auto;
  opacity: 0.08;
  animation: spin linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

@media (max-width: 700px) {
  .gear {
    width: 320px !important;
  }
}
</style>
