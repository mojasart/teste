<script setup>
// Topo da home no estilo de um launcher: tela com o addon escolhido e abas dos premium ao lado.
// As abas avançam sozinhas (a barra de cada uma mostra o tempo); mouse em cima pausa.
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'

const props = defineProps({ addons: { type: Array, required: true } })
const emit = defineEmits(['trailer'])

const DURATION = 8000
const active = ref(Math.max(0, props.addons.findIndex((a) => a.featured)))
const shot = ref(0) // imagem atual dentro do addon ativo
const hold = ref(false)
const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches
const cycle = ref(0) // reinicia a animação da barra

const current = computed(() => props.addons[active.value])
const shots = computed(() => {
  const a = current.value
  return [a.hero || a.keyart, ...a.gallery.slice(0, 3).map((g) => g.src)].filter(Boolean)
})

let tAddon = 0
let tShot = 0
function schedule() {
  clearTimeout(tAddon)
  clearInterval(tShot)
  if (reduce || hold.value) return
  tShot = setInterval(() => (shot.value = (shot.value + 1) % shots.value.length), DURATION / 3)
  tAddon = setTimeout(() => pick((active.value + 1) % props.addons.length), DURATION)
}
function pick(i) {
  active.value = i
  shot.value = 0
  cycle.value++
  schedule()
}
watch(hold, schedule)
onMounted(schedule)
onBeforeUnmount(() => {
  clearTimeout(tAddon)
  clearInterval(tShot)
})
</script>

<template>
  <section class="wrap launcher" aria-label="Premium add-ons" @mouseenter="hold = true" @mouseleave="hold = false" @focusin="hold = true" @focusout="hold = false">
    <div class="screen" :style="{ '--accent': current.accent }">
      <img
        v-for="(src, n) in shots"
        :key="current.slug + src"
        :src="src"
        alt=""
        class="screen__img"
        :class="{ 'is-on': n === shot }"
        :fetchpriority="n === 0 ? 'high' : undefined"
      />
      <Transition name="swap" mode="out-in">
        <div :key="current.slug" class="screen__info">
          <span v-if="current.badge" class="screen__badge display">{{ current.badge }}</span>
          <h1 class="screen__title display">{{ current.title }}</h1>
          <p class="screen__tag">{{ current.tagline }}</p>
          <div class="screen__actions">
            <button v-if="current.trailer" type="button" class="btn btn--light" @click="emit('trailer', current)">
              <svg viewBox="0 0 24 24" width="15" height="15" aria-hidden="true"><path d="M7 4l13 8-13 8z" fill="currentColor" /></svg>
              Watch Trailer
            </button>
            <RouterLink :to="`/addons/${current.slug}`" class="btn btn--ghost screen__more">Explore add-on</RouterLink>
          </div>
        </div>
      </Transition>
      <span class="screen__corner screen__corner--tl" aria-hidden="true"></span>
      <span class="screen__corner screen__corner--br" aria-hidden="true"></span>
    </div>

    <ul class="tabs" role="list">
      <li v-for="(a, n) in addons" :key="a.slug">
        <button
          type="button"
          class="tab"
          :class="{ 'tab--on': n === active, 'tab--hold': hold || reduce }"
          :aria-pressed="n === active"
          :style="{ '--accent': a.accent }"
          @click="pick(n)"
        >
          <img :src="a.keyart" alt="" class="tab__art" loading="lazy" />
          <span class="tab__text">
            <span class="tab__name display">{{ a.title }}</span>
            <span class="tab__meta">{{ a.badge || 'Premium add-on' }}</span>
          </span>
          <span class="tab__bar" aria-hidden="true">
            <span :key="cycle" class="tab__fill" :style="{ animationDuration: `${DURATION}ms` }"></span>
          </span>
        </button>
      </li>
    </ul>
  </section>
</template>

<style scoped>
.launcher {
  display: grid;
  grid-template-columns: minmax(0, 1fr) clamp(260px, 26vw, 340px);
  gap: clamp(10px, 1.4vw, 16px);
  padding-top: clamp(20px, 3vw, 36px);
}

/* ---------- tela ---------- */
.screen {
  --cut: clamp(18px, 2.4vw, 30px);
  position: relative;
  display: grid;
  align-items: end;
  min-height: clamp(420px, 62vh, 640px);
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
  transition: opacity 1100ms ease, transform 9000ms linear;
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
    linear-gradient(0deg, rgb(20 15 28 / 0.92) 0%, rgb(20 15 28 / 0.45) 38%, transparent 65%),
    linear-gradient(90deg, rgb(20 15 28 / 0.55), transparent 55%);
}

.screen__info {
  display: grid;
  justify-items: start;
  gap: 10px;
  padding: clamp(22px, 3.6vw, 48px);
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
  font-size: clamp(3rem, 8vw, 6.4rem);
  line-height: 0.86;
  text-transform: uppercase;
  text-shadow: 0 4px 0 rgb(0 0 0 / 0.35), 0 0 40px rgb(0 0 0 / 0.4);
}

.screen__tag {
  max-width: 40ch;
  font-size: clamp(1rem, 1.5vw, 1.2rem);
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

.swap-enter-active,
.swap-leave-active {
  transition: opacity 300ms ease, transform 300ms ease;
}

.swap-enter-from {
  opacity: 0;
  transform: translateY(16px);
}

.swap-leave-to {
  opacity: 0;
  transform: translateY(-8px);
}

/* cantos de "mira" na cor do addon */
.screen__corner {
  position: absolute;
  width: 34px;
  height: 34px;
  border: 0 solid var(--accent);
  transition: border-color 500ms ease;
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

/* ---------- abas ---------- */
.tabs {
  display: grid;
  grid-auto-rows: 1fr;
  gap: clamp(10px, 1.4vw, 16px);
  margin: 0;
  padding: 0;
  list-style: none;
}

.tab {
  position: relative;
  display: grid;
  grid-template-rows: 1fr auto;
  width: 100%;
  height: 100%;
  padding: 0;
  overflow: hidden;
  text-align: left;
  color: var(--hi);
  font: inherit;
  background: var(--bg-2);
  border: 1px solid var(--panel-hi);
  border-radius: 4px;
  cursor: pointer;
  transition: border-color 250ms ease, transform 250ms ease, background-color 250ms ease;
}

.tab:hover {
  transform: translateX(-4px);
  border-color: var(--accent);
}

.tab--on {
  background: var(--panel);
  border-color: var(--accent);
  box-shadow: inset 4px 0 0 var(--accent);
}

.tab__art {
  width: 100%;
  height: 100%;
  min-height: 0;
  object-fit: cover;
  opacity: 0.55;
  filter: saturate(0.7);
  transition: opacity 300ms ease, filter 300ms ease;
}

.tab--on .tab__art,
.tab:hover .tab__art {
  opacity: 1;
  filter: none;
}

.tab__text {
  display: grid;
  gap: 2px;
  padding: 10px 14px 14px;
}

.tab__name {
  font-size: clamp(1.3rem, 1.8vw, 1.6rem);
  line-height: 1;
  text-transform: uppercase;
}

.tab__meta {
  font-size: 0.8rem;
  color: var(--mid);
}

.tab__bar {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 4px;
  background: rgb(255 255 255 / 0.06);
}

.tab__fill {
  display: block;
  height: 100%;
  background: var(--accent);
  transform: scaleX(0);
  transform-origin: left;
}

.tab--on .tab__fill {
  animation: fill linear forwards;
}

.tab--on.tab--hold .tab__fill {
  animation-play-state: paused;
}

@keyframes fill {
  to {
    transform: scaleX(1);
  }
}

@media (max-width: 900px) {
  .launcher {
    grid-template-columns: 1fr;
  }

  .tabs {
    grid-template-columns: repeat(3, minmax(0, 1fr));
    grid-auto-rows: auto;
  }

  .tab:hover {
    transform: none;
  }

  .tab__art {
    aspect-ratio: 16 / 9;
    height: auto;
  }

  .tab--on {
    box-shadow: inset 0 -4px 0 var(--accent);
  }
}

@media (max-width: 560px) {
  .screen {
    min-height: 420px;
  }

  .tab__text {
    padding: 8px;
  }

  .tab__name {
    font-size: 1rem;
  }

  .tab__meta {
    display: none;
  }

  .screen__corner {
    width: 22px;
    height: 22px;
  }
}
</style>
