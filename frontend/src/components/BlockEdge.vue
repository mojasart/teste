<script setup>
// Borda em "terreno de blocos": colunas de alturas diferentes, como o chão do Minecraft.
const props = defineProps({
  color: { type: String, default: 'var(--byte)' },
  shade: { type: String, default: 'var(--byte-deep)' },
  seed: { type: Number, default: 7 },
  up: { type: Boolean, default: false }, // blocos subindo (borda de cima de uma seção)
})

let s = props.seed
const rand = () => ((s = (s * 9301 + 49297) % 233280) / 233280)
// 64 colunas de 40px cobrem até 2560px de largura
const cols = Array.from({ length: 64 }, () => 1 + Math.floor(rand() * 3))
</script>

<template>
  <div class="edge" :class="{ 'edge--up': up }" aria-hidden="true" :style="{ '--c': color, '--s': shade }">
    <span v-for="(h, i) in cols" :key="i" :style="{ '--h': h }" />
  </div>
</template>

<style scoped>
.edge {
  --unit: 14px;
  display: flex;
  height: calc(var(--unit) * 3 + 6px);
  overflow: hidden;
  margin-top: -1px;
  pointer-events: none;
}

.edge span {
  flex: 0 0 40px;
  height: calc(var(--h) * var(--unit));
  background: var(--c);
  box-shadow: 0 6px 0 var(--s);
}

.edge--up {
  align-items: flex-end;
  margin-top: 0;
  margin-bottom: -1px;
}

.edge--up span {
  box-shadow: none;
}

@media (max-width: 600px) {
  .edge {
    --unit: 9px;
  }

  .edge span {
    flex-basis: 26px;
  }
}
</style>
