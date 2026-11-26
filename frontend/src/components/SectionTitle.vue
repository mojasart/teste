<script setup>
// Título centralizado com linhas dos dois lados, que se estendem ao entrar na tela.
import { onMounted, ref } from 'vue'
defineProps({ id: { type: String, default: undefined } })
const el = ref(null)
const shown = ref(false)
onMounted(() => {
  if (!('IntersectionObserver' in window)) return (shown.value = true)
  const io = new IntersectionObserver(([e]) => {
    if (e.isIntersecting) {
      shown.value = true
      io.disconnect()
    }
  })
  io.observe(el.value)
})
</script>

<template>
  <div ref="el" class="stitle" :class="{ 'stitle--in': shown }">
    <span class="stitle__line" aria-hidden="true"></span>
    <h2 :id="id" class="stitle__text display"><slot /></h2>
    <span class="stitle__line" aria-hidden="true"></span>
  </div>
</template>

<style scoped>
.stitle {
  display: grid;
  grid-template-columns: 1fr auto 1fr;
  align-items: center;
  gap: clamp(14px, 2vw, 22px);
  margin-bottom: clamp(24px, 3.5vw, 40px);
}

.stitle__text {
  font-size: clamp(1.9rem, 3.4vw, 2.6rem);
  line-height: 1;
  text-align: center;
}

.stitle__line {
  height: 3px;
  background: var(--rule);
  transform: scaleX(0);
  transition: transform 900ms cubic-bezier(0.2, 0.8, 0.2, 1);
}

.stitle__line:first-child {
  transform-origin: right;
}

.stitle__line:last-child {
  transform-origin: left;
}

.stitle--in .stitle__line {
  transform: scaleX(1);
}
</style>
