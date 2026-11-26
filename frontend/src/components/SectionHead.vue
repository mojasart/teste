<script setup>
// Título de seção: alinhado à esquerda, régua em degraus de pixel e engrenagem que gira ao aparecer.
import { onMounted, ref } from 'vue'
import gear from '../assets/gear.svg'
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
  <div ref="el" class="shead" :class="{ 'shead--in': shown }">
    <h2 :id="id" class="shead__title display"><slot /></h2>
    <span class="shead__rule" aria-hidden="true">
      <span class="shead__steps"></span>
      <img :src="gear" alt="" class="shead__gear" />
    </span>
    <div v-if="$slots.side" class="shead__side"><slot name="side" /></div>
  </div>
</template>

<style scoped>
.shead {
  display: flex;
  align-items: center;
  gap: clamp(14px, 2vw, 24px);
  margin-bottom: clamp(22px, 3vw, 36px);
}

.shead__title {
  font-size: clamp(2.1rem, 4.4vw, 3.4rem);
  line-height: 0.9;
  text-transform: uppercase;
  letter-spacing: 0.01em;
}

.shead__rule {
  position: relative;
  flex: 1;
  display: flex;
  align-items: center;
  height: 28px;
}

/* régua em escada: três degraus de pixel até a linha */
.shead__steps {
  flex: 1;
  height: 12px;
  background:
    linear-gradient(var(--accent-hi) 0 0) 0 100% / 100% 4px no-repeat,
    linear-gradient(var(--accent-hi) 0 0) 0 0 / 8px 12px no-repeat,
    linear-gradient(var(--accent-hi) 0 0) 8px 4px / 8px 8px no-repeat;
  transform: scaleX(0);
  transform-origin: left;
  transition: transform 900ms cubic-bezier(0.2, 0.8, 0.2, 1);
}

.shead__gear {
  width: 28px;
  height: 28px;
  margin-left: 6px;
  filter: brightness(1.6);
  opacity: 0;
  transform: rotate(-180deg) scale(0.4);
  transition: transform 900ms cubic-bezier(0.3, 1.4, 0.5, 1) 300ms, opacity 300ms ease 300ms;
}

.shead--in .shead__steps {
  transform: scaleX(1);
}

.shead--in .shead__gear {
  opacity: 1;
  transform: none;
  animation: spin 14s linear 1.2s infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.shead__side {
  flex: none;
}

@media (max-width: 520px) {
  .shead__gear {
    width: 22px;
    height: 22px;
  }
}
</style>
