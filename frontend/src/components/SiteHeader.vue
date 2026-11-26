<script setup>
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import logo from '../assets/logo.webp'
import badge from '../assets/marketplace-partner.png'
import SocialIcons from './SocialIcons.vue'

const route = useRoute()
const open = ref(false)
const scrolled = ref(false)

watch(() => route.fullPath, () => (open.value = false))
watch(open, (v) => document.documentElement.classList.toggle('lock', v))

const onScroll = () => (scrolled.value = window.scrollY > 16)
const onKey = (e) => e.key === 'Escape' && (open.value = false)
onMounted(() => {
  addEventListener('scroll', onScroll, { passive: true })
  addEventListener('keydown', onKey)
  onScroll()
})
onBeforeUnmount(() => {
  removeEventListener('scroll', onScroll)
  removeEventListener('keydown', onKey)
  document.documentElement.classList.remove('lock')
})

const links = [
  { to: { path: '/', hash: '#premium' }, label: 'Premium Content' },
  { to: { path: '/', hash: '#gallery' }, label: 'Gallery' },
  { to: { path: '/', hash: '#free' }, label: 'Free Content' },
  { to: { path: '/contact' }, label: 'Contact' },
]
const isActive = (l) => {
  const path = route.path.replace(/(.)\/$/, '$1') // endereços abertos direto vêm com barra no fim
  return l.to.hash ? path === '/' && route.hash === l.to.hash : path === l.to.path
}
</script>

<template>
  <header class="header" :class="{ 'header--scrolled': scrolled }">
    <div class="wrap header__bar">
      <RouterLink to="/" class="header__logo" aria-label="PurpleByte Studios home">
        <img :src="logo" alt="PurpleByte Studios" width="500" height="182" />
      </RouterLink>

      <nav class="nav" aria-label="Main">
        <RouterLink v-for="l in links" :key="l.label" :to="l.to" class="nav__link" :class="{ 'is-active': isActive(l) }">
          {{ l.label }}
        </RouterLink>
      </nav>

      <img class="header__badge" :src="badge" alt="Official Minecraft Partner" width="250" height="289" />

      <button class="header__menu" type="button" :aria-expanded="open" aria-controls="drawer" @click="open = true">
        <span class="visually-hidden">Open menu</span>
        <svg viewBox="0 0 24 24" width="28" height="28" aria-hidden="true">
          <path d="M3 7h18M3 13h18M9 19h12" stroke="currentColor" stroke-width="2.4" />
        </svg>
      </button>
    </div>
  </header>

  <div class="drawer" :class="{ 'drawer--open': open }" :inert="!open">
    <button class="drawer__shade" type="button" tabindex="-1" aria-hidden="true" @click="open = false"></button>
    <div id="drawer" class="drawer__panel" role="dialog" aria-modal="true" aria-label="Menu">
      <div class="drawer__top">
        <img :src="logo" alt="" class="drawer__logo" />
        <button class="drawer__close" type="button" @click="open = false">
          <span class="visually-hidden">Close menu</span>
          <svg viewBox="0 0 24 24" width="22" height="22" aria-hidden="true">
            <path d="M5 5l14 14M19 5L5 19" stroke="currentColor" stroke-width="2.6" />
          </svg>
        </button>
      </div>
      <nav class="drawer__nav" aria-label="Mobile">
        <RouterLink v-for="l in links" :key="l.label" :to="l.to" class="drawer__link display">{{ l.label }}</RouterLink>
      </nav>
      <div class="drawer__foot">
        <img :src="badge" alt="Official Minecraft Partner" class="drawer__badge" />
        <SocialIcons small />
      </div>
    </div>
  </div>
</template>

<style scoped>
.header {
  position: sticky;
  top: 0;
  z-index: 40;
  background: var(--header);
  border-bottom: 1px solid rgb(255 255 255 / 0.06);
  transition: background-color 250ms ease;
}

.header--scrolled {
  background: rgb(31 24 41 / 0.82);
  -webkit-backdrop-filter: blur(14px) saturate(1.3);
  backdrop-filter: blur(14px) saturate(1.3);
}

.header__bar {
  display: grid;
  grid-template-columns: 1fr auto 1fr;
  align-items: center;
  gap: 24px;
  min-height: var(--header-h);
}

.header__logo img {
  width: auto;
  height: 46px;
}

.nav {
  display: flex;
  gap: clamp(14px, 2.4vw, 34px);
}

.nav__link {
  position: relative;
  padding: 8px 0;
  font-weight: 600;
  font-size: 1.05rem;
  text-decoration: none;
  white-space: nowrap;
}

.nav__link::after {
  content: '';
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 3px;
  background: var(--accent-hi);
  transform: scaleX(0);
  transition: transform 220ms cubic-bezier(0.2, 0.8, 0.2, 1);
}

.nav__link:hover::after,
.nav__link:focus-visible::after,
.nav__link.is-active::after {
  transform: scaleX(1);
}

.header__badge {
  justify-self: end;
  width: auto;
  height: 58px;
  transition: transform 300ms cubic-bezier(0.3, 1.6, 0.5, 1);
}

.header__badge:hover {
  transform: rotate(-8deg) scale(1.06);
}

.header__menu {
  display: none;
  place-items: center;
  width: 46px;
  height: 46px;
  color: var(--hi);
  background: transparent;
  border: 0;
  cursor: pointer;
}

/* ---------- gaveta (celular) ---------- */
.drawer {
  position: fixed;
  inset: 0;
  z-index: 60;
  visibility: hidden;
  pointer-events: none;
  transition: visibility 0s 300ms;
}

.drawer--open {
  visibility: visible;
  pointer-events: auto;
  transition: visibility 0s;
}

.drawer__shade {
  position: absolute;
  inset: 0;
  border: 0;
  background: rgb(10 6 16 / 0.7);
  opacity: 0;
  transition: opacity 300ms ease;
}

.drawer--open .drawer__shade {
  opacity: 1;
}

.drawer__panel {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  display: flex;
  flex-direction: column;
  width: min(86vw, 360px);
  padding: calc(16px + env(safe-area-inset-top, 0px)) 22px calc(24px + env(safe-area-inset-bottom, 0px));
  background: var(--header);
  border-left: 1px solid var(--panel-hi);
  transform: translateX(102%);
  transition: transform 320ms cubic-bezier(0.2, 0.9, 0.2, 1);
}

.drawer--open .drawer__panel {
  transform: none;
}

.drawer__top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 28px;
}

.drawer__logo {
  height: 40px;
  width: auto;
}

.drawer__close {
  display: grid;
  place-items: center;
  width: 44px;
  height: 44px;
  color: var(--hi);
  background: var(--panel);
  border: 0;
  border-radius: 6px;
  cursor: pointer;
}

.drawer__nav {
  display: grid;
}

.drawer__link {
  padding: 14px 4px;
  font-size: 2rem;
  line-height: 1;
  text-transform: uppercase;
  text-decoration: none;
  border-bottom: 1px solid var(--panel);
  opacity: 0;
  transform: translateX(20px);
  transition: opacity 250ms ease, transform 250ms ease, color 150ms ease;
}

.drawer__link:hover {
  color: var(--accent-hi);
}

.drawer--open .drawer__link {
  opacity: 1;
  transform: none;
}

.drawer--open .drawer__link:nth-child(2) { transition-delay: 40ms; }
.drawer--open .drawer__link:nth-child(3) { transition-delay: 80ms; }
.drawer--open .drawer__link:nth-child(4) { transition-delay: 120ms; }

.drawer__foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin-top: auto;
}

.drawer__badge {
  height: 64px;
  width: auto;
}

@media (max-width: 900px) {
  .header__bar {
    grid-template-columns: 1fr auto auto;
    gap: 12px;
  }

  .nav {
    display: none;
  }

  .header__menu {
    display: grid;
  }

  .header__badge {
    height: 50px;
  }
}

@media (max-width: 600px) {
  :global(:root) {
    --header-h: 66px;
  }

  .header__logo img {
    height: 38px;
  }

  .header__badge {
    height: 44px;
  }
}
</style>
