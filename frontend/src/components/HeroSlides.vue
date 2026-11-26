<script setup>
// Topo da home: prints do addon em destaque trocando sozinhos (com zoom lento).
import { onBeforeUnmount, onMounted, ref } from 'vue'

const props = defineProps({
  addon: { type: Object, required: true },
  slides: { type: Array, required: true }, // [{ src, alt }]
})
const emit = defineEmits(['trailer'])

const i = ref(0)
const playing = ref(true)
let timer = 0
const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches

function start() {
  clearInterval(timer)
  if (playing.value && props.slides.length > 1) timer = setInterval(() => (i.value = (i.value + 1) % props.slides.length), 6000)
}
function toggle() {
  playing.value = !playing.value
  start()
}
onMounted(() => {
  if (reduce) playing.value = false
  start()
})
onBeforeUnmount(() => clearInterval(timer))
</script>

<template>
  <section class="hero" aria-label="Featured add-on">
    <div class="hero__slides" :class="{ 'hero__slides--paused': !playing }">
      <img
        v-for="(s, n) in slides"
        :key="s.src"
        :src="s.src"
        :alt="n === i ? s.alt : ''"
        class="hero__img"
        :class="{ 'is-on': n === i }"
        :loading="n === 0 ? 'eager' : 'lazy'"
        :fetchpriority="n === 0 ? 'high' : undefined"
      />
    </div>

    <div class="wrap hero__content">
      <span v-if="addon.badge" class="hero__badge display">{{ addon.badge }}</span>
      <h1 class="hero__title">{{ addon.title }} Add-On</h1>
      <p class="hero__tag">{{ addon.tagline }}</p>
      <div class="hero__actions">
        <button v-if="addon.trailer" type="button" class="btn btn--light" @click="emit('trailer')">
          <svg viewBox="0 0 24 24" width="16" height="16" aria-hidden="true"><path d="M7 4l13 8-13 8z" fill="currentColor" /></svg>
          Watch Trailer
        </button>
        <RouterLink :to="`/addons/${addon.slug}`" class="btn btn--ghost hero__more">View add-on</RouterLink>
      </div>
    </div>

    <div class="wrap hero__controls">
      <div class="hero__dots" role="group" aria-label="Choose image">
        <button
          v-for="(s, n) in slides"
          :key="s.src"
          type="button"
          class="hero__dot"
          :aria-pressed="n === i"
          @click="(i = n), start()"
        >
          <span class="visually-hidden">Image {{ n + 1 }}</span>
        </button>
      </div>
      <button v-if="slides.length > 1" type="button" class="hero__pause" @click="toggle">
        <span class="visually-hidden">{{ playing ? 'Pause slideshow' : 'Play slideshow' }}</span>
        <svg v-if="playing" viewBox="0 0 24 24" aria-hidden="true"><path d="M7 5h3.5v14H7zM13.5 5H17v14h-3.5z" /></svg>
        <svg v-else viewBox="0 0 24 24" aria-hidden="true"><path d="M8 5l11 7-11 7z" /></svg>
      </button>
    </div>
  </section>
</template>

<style scoped>
.hero {
  position: relative;
  display: grid;
  align-content: end;
  min-height: clamp(460px, 72vh, 760px);
  padding-bottom: clamp(120px, 14vw, 190px);
  overflow: hidden;
  isolation: isolate;
}

.hero__slides {
  position: absolute;
  inset: 0;
  z-index: -2;
}

.hero__img {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  opacity: 0;
  transform: scale(1.08);
  transition: opacity 1200ms ease, transform 7000ms linear;
}

.hero__img.is-on {
  opacity: 1;
  transform: scale(1);
}

.hero__slides--paused .hero__img {
  transition: opacity 600ms ease;
}

.hero::after {
  content: '';
  position: absolute;
  inset: 0;
  z-index: -1;
  background:
    linear-gradient(90deg, rgb(20 15 28 / 0.75) 0%, rgb(20 15 28 / 0.25) 45%, transparent 70%),
    linear-gradient(0deg, var(--bg) 0%, rgb(28 23 36 / 0.65) 22%, transparent 55%);
}

.hero__content {
  display: grid;
  justify-items: start;
  gap: 10px;
}

.hero__badge {
  padding: 4px 10px;
  font-size: 1rem;
  letter-spacing: 0.02em;
  color: #1c1527;
  background: var(--brass);
  border-radius: 3px;
  box-shadow: 0 3px 0 var(--brass-deep);
  animation: up 800ms cubic-bezier(0.2, 0.8, 0.2, 1) 60ms backwards;
}

.hero__title {
  font-family: var(--font);
  font-weight: 600;
  font-size: clamp(2.2rem, 4.6vw, 3.6rem);
  line-height: 1.05;
  text-shadow: 0 2px 18px rgb(0 0 0 / 0.5);
  animation: up 800ms cubic-bezier(0.2, 0.8, 0.2, 1) 150ms backwards;
}

.hero__tag {
  max-width: 44ch;
  font-size: clamp(1rem, 1.5vw, 1.2rem);
  text-shadow: 0 1px 10px rgb(0 0 0 / 0.6);
  animation: up 800ms cubic-bezier(0.2, 0.8, 0.2, 1) 280ms backwards;
}

.hero__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-top: 14px;
  animation: up 800ms cubic-bezier(0.2, 0.8, 0.2, 1) 400ms backwards;
}

.hero__more {
  color: var(--hi);
}

@keyframes up {
  from {
    opacity: 0;
    transform: translateY(18px);
  }
}

.hero__controls {
  position: absolute;
  left: 0;
  right: 0;
  /* acima da faixa onde os cartões premium sobem por cima do hero */
  bottom: clamp(104px, calc(12vw + 26px), 176px);
  margin-inline: auto;
  display: flex;
  justify-content: flex-end;
  align-items: center;
  gap: 16px;
  pointer-events: none;
}

.hero__dots {
  display: flex;
  gap: 6px;
  pointer-events: auto;
}

.hero__dot {
  width: 22px;
  height: 4px;
  padding: 0;
  border: 0;
  border-radius: 2px;
  background: rgb(255 255 255 / 0.35);
  cursor: pointer;
  transition: width 300ms ease, background-color 300ms ease;
}

.hero__dot[aria-pressed='true'] {
  width: 40px;
  background: var(--hi);
}

.hero__pause {
  display: grid;
  place-items: center;
  width: 40px;
  height: 40px;
  color: var(--hi);
  background: rgb(31 24 41 / 0.6);
  border: 1px solid rgb(255 255 255 / 0.18);
  border-radius: 50%;
  cursor: pointer;
  pointer-events: auto;
}

.hero__pause svg {
  width: 16px;
  height: 16px;
  fill: currentColor;
}

@media (max-width: 700px) {
  .hero {
    min-height: 440px;
    padding-bottom: 96px;
  }

  .hero__dots {
    display: none;
  }

  .hero__controls {
    bottom: auto;
    top: 16px;
  }
}
</style>
