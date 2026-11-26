<script setup>
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import logo from '../assets/logo-horizontal.png'
import SocialIcons from './SocialIcons.vue'

const open = ref(false)
const route = useRoute()
watch(() => route.fullPath, () => (open.value = false))
// trava a rolagem da página enquanto a gaveta está aberta
watch(open, (v) => document.documentElement.classList.toggle('drawer-open', v))

const onKey = (e) => {
  if (e.key === 'Escape') open.value = false
}
onMounted(() => addEventListener('keydown', onKey))
onBeforeUnmount(() => {
  removeEventListener('keydown', onKey)
  document.documentElement.classList.remove('drawer-open')
})

const links = [
  { to: '/projects', label: 'Projects' },
  { to: '/about', label: 'About' },
  { to: '/contact', label: 'Contact' },
]
</script>

<template>
  <header class="header">
    <div class="wrap header__bar">
      <RouterLink to="/" class="brand" aria-label="PurpleByte Studios home">
        <img class="brand__logo" :src="logo" alt="PurpleByte Studios" width="656" height="241" />
      </RouterLink>

      <nav class="nav" aria-label="Main">
        <RouterLink v-for="l in links" :key="l.to" :to="l.to" class="nav__link">{{ l.label }}</RouterLink>
      </nav>

      <button
        class="header__toggle"
        type="button"
        :aria-expanded="open"
        aria-controls="drawer"
        @click="open = true"
      >
        <span class="visually-hidden">Open menu</span>
        <svg viewBox="0 0 24 24" width="26" height="26" aria-hidden="true">
          <path d="M3 6h18M3 12h18M3 18h18" stroke="currentColor" stroke-width="3" />
        </svg>
      </button>
    </div>

    <!-- gaveta lateral (celular) -->
    <div class="drawer" :class="{ 'drawer--open': open }" :inert="!open">
      <button class="drawer__backdrop" type="button" tabindex="-1" aria-hidden="true" @click="open = false"></button>
      <div id="drawer" class="drawer__panel" role="dialog" aria-modal="true" aria-label="Menu">
        <div class="drawer__top">
          <img class="brand__logo" :src="logo" alt="" width="656" height="241" />
          <button class="drawer__close" type="button" @click="open = false">
            <span class="visually-hidden">Close menu</span>
            <svg viewBox="0 0 24 24" width="24" height="24" aria-hidden="true">
              <path d="M5 5l14 14M19 5L5 19" stroke="currentColor" stroke-width="3" />
            </svg>
          </button>
        </div>
        <nav class="drawer__nav" aria-label="Mobile">
          <RouterLink to="/" class="drawer__link">Home</RouterLink>
          <RouterLink v-for="l in links" :key="l.to" :to="l.to" class="drawer__link">{{ l.label }}</RouterLink>
        </nav>
        <div class="drawer__bottom">
          <RouterLink to="/contact" class="btn">Work with us</RouterLink>
          <SocialIcons />
        </div>
      </div>
    </div>
  </header>
</template>

<style scoped>
.header {
  background: var(--byte);
  color: var(--white);
  position: relative;
  z-index: 20;
}

.header__bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-height: 76px;
}

.brand {
  display: flex;
  align-items: center;
}

.brand__logo {
  width: auto;
  height: 44px;
}

.nav {
  display: flex;
  gap: 6px;
}

.nav__link {
  position: relative;
  isolation: isolate;
  padding: 10px 14px;
  font-weight: 700;
  text-decoration: none;
  transition: color 160ms steps(2, end);
}

/* hover: um bloco branco "enche" de baixo pra cima em degraus de pixel */
.nav__link::before {
  content: '';
  position: absolute;
  inset: 0;
  z-index: -1;
  background: var(--white);
  border-radius: 6px;
  box-shadow: 4px 4px 0 var(--byte-deep);
  transform: scaleY(0);
  transform-origin: bottom;
  transition: transform 200ms steps(4, end);
}

.nav__link:hover,
.nav__link:focus-visible,
.nav__link.router-link-active {
  color: var(--byte-deep);
}

.nav__link:hover::before,
.nav__link:focus-visible::before,
.nav__link.router-link-active::before {
  transform: scaleY(1);
}

.header__toggle {
  display: none;
  width: 48px;
  height: 48px;
  place-items: center;
  color: inherit;
  background: transparent;
  border: 0;
  border-radius: 8px;
  cursor: pointer;
}

/* ---------- gaveta ---------- */
.drawer {
  position: fixed;
  inset: 0;
  z-index: 50;
  pointer-events: none;
  visibility: hidden;
  transition: visibility 0s 300ms;
}

.drawer--open {
  pointer-events: auto;
  visibility: visible;
  transition: visibility 0s;
}

.drawer__backdrop {
  position: absolute;
  inset: 0;
  border: 0;
  background: rgb(18 9 35 / 0.7);
  opacity: 0;
  transition: opacity 300ms ease;
}

.drawer--open .drawer__backdrop {
  opacity: 1;
}

.drawer__panel {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  display: flex;
  flex-direction: column;
  width: min(84vw, 340px);
  padding: calc(16px + env(safe-area-inset-top, 0px)) 20px calc(24px + env(safe-area-inset-bottom, 0px));
  background: var(--byte);
  box-shadow: -8px 0 0 var(--byte-deep);
  transform: translateX(105%);
  transition: transform 320ms cubic-bezier(0.2, 0.9, 0.2, 1);
}

.drawer--open .drawer__panel {
  transform: none;
}

.drawer__top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-height: 44px;
  margin-bottom: 32px;
}

.drawer__close {
  display: grid;
  place-items: center;
  width: 44px;
  height: 44px;
  color: var(--white);
  background: var(--byte-deep);
  border: 0;
  border-radius: 8px;
  cursor: pointer;
}

.drawer__nav {
  display: grid;
  gap: 6px;
}

.drawer__link {
  padding: 12px 14px;
  font-size: 1.9rem;
  font-weight: 800;
  font-stretch: 78%;
  line-height: 1;
  color: var(--white);
  text-decoration: none;
  border-radius: 8px;
  opacity: 0;
  transform: translateX(24px);
  transition: opacity 250ms ease, transform 250ms ease, background 150ms ease;
}

.drawer--open .drawer__link {
  opacity: 1;
  transform: none;
}

.drawer--open .drawer__link:nth-child(2) { transition-delay: 40ms; }
.drawer--open .drawer__link:nth-child(3) { transition-delay: 80ms; }
.drawer--open .drawer__link:nth-child(4) { transition-delay: 120ms; }

.drawer__link.router-link-exact-active {
  color: var(--byte-deep);
  background: var(--white);
  box-shadow: 4px 4px 0 var(--byte-deep);
}

.drawer__bottom {
  display: grid;
  gap: 20px;
  justify-items: start;
  margin-top: auto;
}

.drawer__bottom :deep(.social__link) {
  background: var(--byte-deep);
  border-color: var(--byte-deep);
}

@media (max-width: 680px) {
  .header__bar {
    min-height: 64px;
  }

  .brand__logo {
    height: 38px;
  }

  .nav {
    display: none;
  }

  .header__toggle {
    display: grid;
  }
}
</style>
