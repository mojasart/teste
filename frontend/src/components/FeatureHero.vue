<script setup>
// Topo da home: um addon em destaque numa "tela" chanfrada, com as imagens dele passando.
// As miniaturas mostram qual imagem está na tela; a barra embaixo da ativa marca o tempo.
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'

const props = defineProps({ addon: { type: Object, required: true } })
const emit = defineEmits(['trailer'])

const DURATION = 5500
const shots = [
  ...(props.addon.hero ? [{ src: props.addon.hero, thumb: props.addon.hero, alt: `${props.addon.title} key art` }] : []),
  ...props.addon.gallery,
].slice(0, 6)
const i = ref(0)
const hold = ref(false)
const cycle = ref(0)
const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches

let timer = 0
function schedule() {
  clearTimeout(timer)
  if (reduce || hold.value || shots.length < 2) return
  timer = setTimeout(() => go((i.value + 1) % shots.length), DURATION)
}
function go(n) {
  i.value = n
  cycle.value++
  schedule()
}
watch(hold, schedule)
onMounted(schedule)
onBeforeUnmount(() => clearTimeout(timer))
</script>

<template>
  <section
    class="wrap fh"
    aria-label="Featured add-on"
    @mouseenter="hold = true"
    @mouseleave="hold = false"
    @focusin="hold = true"
    @focusout="hold = false"
  >
    <div class="screen" :style="{ '--tint': addon.accent }">
      <img
        v-for="(s, n) in shots"
        :key="s.src"
        :src="s.src"
        :alt="n === i ? s.alt : ''"
        class="screen__img"
        :class="{ 'is-on': n === i }"
        :fetchpriority="n === 0 ? 'high' : undefined"
        :loading="n === 0 ? 'eager' : 'lazy'"
      />

      <!-- clicar em qualquer parte da imagem abre a página do addon -->
      <RouterLink :to="`/addons/${addon.slug}`" class="screen__link" tabindex="-1" aria-hidden="true"></RouterLink>

      <div class="screen__info">
        <span v-if="addon.badge" class="screen__badge display">{{ addon.badge }}</span>
        <h1 class="screen__title display">{{ addon.title }}</h1>
        <p class="screen__tag">{{ addon.tagline }}</p>
        <div class="screen__actions">
          <button v-if="addon.trailer" type="button" class="btn btn--light" @click="emit('trailer', addon)">
            <svg viewBox="0 0 24 24" width="15" height="15" aria-hidden="true"><path d="M7 4l13 8-13 8z" fill="currentColor" /></svg>
            Watch Trailer
          </button>
          <RouterLink :to="`/addons/${addon.slug}`" class="btn btn--ghost screen__more">Explore add-on</RouterLink>
        </div>
      </div>

      <ol v-if="shots.length > 1" class="thumbs" aria-label="Choose image">
        <li v-for="(s, n) in shots" :key="s.src">
          <button type="button" class="thumb" :class="{ 'is-on': n === i, 'is-hold': hold || reduce }" :aria-pressed="n === i" @click="go(n)">
            <img :src="s.thumb || s.src" alt="" loading="lazy" />
            <span class="visually-hidden">Image {{ n + 1 }}</span>
            <span class="thumb__bar" aria-hidden="true"><span :key="cycle" class="thumb__fill" :style="{ animationDuration: `${DURATION}ms` }"></span></span>
          </button>
        </li>
      </ol>

      <span class="screen__corner screen__corner--tl" aria-hidden="true"></span>
      <span class="screen__corner screen__corner--br" aria-hidden="true"></span>
    </div>
  </section>
</template>

<style scoped>
.fh {
  padding-top: clamp(18px, 3vw, 34px);
}

.screen {
  --cut: clamp(18px, 2.4vw, 32px);
  position: relative;
  display: grid;
  align-items: end;
  min-height: clamp(440px, 70vh, 700px);
  overflow: hidden;
  isolation: isolate;
  background: var(--panel);
  clip-path: polygon(var(--cut) 0, 100% 0, 100% calc(100% - var(--cut)), calc(100% - var(--cut)) 100%, 0 100%, 0 var(--cut));
}

.screen__img {
  position: absolute;
  inset: 0;
  z-index: -2;
  width: 100%;
  height: 100%;
  object-fit: cover;
  opacity: 0;
  transform: scale(1.07);
  transition: opacity 1100ms ease, transform 7000ms linear;
}

.screen__img.is-on {
  opacity: 1;
  transform: scale(1);
}

.screen::after {
  content: '';
  position: absolute;
  inset: 0;
  z-index: -1;
  background:
    linear-gradient(0deg, rgb(20 15 28 / 0.92) 0%, rgb(20 15 28 / 0.4) 40%, transparent 68%),
    linear-gradient(90deg, rgb(20 15 28 / 0.6), transparent 55%);
}

.screen__link {
  position: absolute;
  inset: 0;
  z-index: 0;
  cursor: pointer;
}

.screen__info {
  position: relative;
  z-index: 1;
  justify-self: start;
  display: grid;
  justify-items: start;
  gap: 10px;
  max-width: 640px;
  padding: clamp(22px, 3.6vw, 52px);
}

.screen__badge {
  padding: 4px 10px;
  font-size: 1rem;
  letter-spacing: 0.02em;
  color: #1c1527;
  background: var(--brass);
  border-radius: 3px;
  box-shadow: 0 3px 0 var(--brass-deep);
}

.screen__title {
  font-size: clamp(3.2rem, 9vw, 7.2rem);
  line-height: 0.84;
  text-transform: uppercase;
  text-shadow: 0 4px 0 rgb(0 0 0 / 0.35), 0 0 40px rgb(0 0 0 / 0.4);
}

.screen__tag {
  max-width: 40ch;
  font-size: clamp(1rem, 1.5vw, 1.25rem);
  color: #e6def2;
}

.screen__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-top: 10px;
}

.screen__more {
  color: var(--hi);
}

/* miniaturas das imagens do addon, no canto inferior direito */
.thumbs {
  position: absolute;
  z-index: 1;
  right: calc(var(--cut) + clamp(14px, 2vw, 28px));
  bottom: clamp(22px, 3vw, 40px);
  display: flex;
  gap: 8px;
  margin: 0;
  padding: 0;
  list-style: none;
}

.thumb {
  position: relative;
  display: block;
  width: clamp(64px, 7vw, 96px);
  aspect-ratio: 16 / 9;
  padding: 0;
  overflow: hidden;
  background: var(--panel);
  border: 2px solid rgb(255 255 255 / 0.25);
  border-radius: 3px;
  cursor: pointer;
  opacity: 0.7;
  transition: opacity 200ms ease, border-color 200ms ease, transform 200ms ease;
}

.thumb:hover {
  opacity: 1;
  transform: translateY(-3px);
}

.thumb.is-on {
  opacity: 1;
  border-color: var(--tint);
}

.thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.thumb__bar {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 3px;
  background: rgb(0 0 0 / 0.4);
}

.thumb__fill {
  display: block;
  height: 100%;
  background: var(--tint);
  transform: scaleX(0);
  transform-origin: left;
}

.thumb.is-on .thumb__fill {
  animation: fill linear forwards;
}

.thumb.is-on.is-hold .thumb__fill {
  animation-play-state: paused;
}

@keyframes fill {
  to {
    transform: scaleX(1);
  }
}

.screen__corner {
  position: absolute;
  width: 34px;
  height: 34px;
  border: 0 solid var(--tint);
}

.screen__corner--tl {
  top: 14px;
  left: calc(var(--cut) + 6px);
  border-top-width: 4px;
  border-left-width: 4px;
}

.screen__corner--br {
  right: calc(var(--cut) + 6px);
  bottom: 14px;
  border-right-width: 4px;
  border-bottom-width: 4px;
}

/* telas menores: miniaturas saem de cima do texto e viram uma linha no topo */
@media (max-width: 1000px) {
  .thumbs {
    top: 16px;
    bottom: auto;
    right: 16px;
  }

  .thumb {
    width: 58px;
  }

  .screen__corner {
    display: none;
  }
}

@media (max-width: 560px) {
  .screen {
    min-height: 460px;
  }

  .thumbs {
    left: 16px;
    right: 16px;
    justify-content: flex-end;
    gap: 5px;
  }

  .thumb {
    width: 46px;
  }
}
</style>
