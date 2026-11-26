<script setup>
import { ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import logo from '../assets/logo-horizontal.png'

const open = ref(false)
const route = useRoute()
watch(() => route.fullPath, () => (open.value = false))

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

      <button
        class="header__toggle"
        type="button"
        :aria-expanded="open"
        aria-controls="menu-principal"
        @click="open = !open"
      >
        <span class="visually-hidden">{{ open ? 'Close menu' : 'Open menu' }}</span>
        <svg viewBox="0 0 24 24" width="26" height="26" aria-hidden="true">
          <path v-if="!open" d="M3 6h18M3 12h18M3 18h18" stroke="currentColor" stroke-width="3" />
          <path v-else d="M5 5l14 14M19 5L5 19" stroke="currentColor" stroke-width="3" />
        </svg>
      </button>

      <nav id="menu-principal" class="nav" :class="{ 'nav--open': open }" aria-label="Main">
        <RouterLink v-for="l in links" :key="l.to" :to="l.to" class="nav__link">{{ l.label }}</RouterLink>
      </nav>
    </div>
  </header>
</template>

<style scoped>
.header {
  background: var(--byte);
  color: var(--white);
  position: relative;
  z-index: 10;
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
  gap: 12px;
  text-decoration: none;
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
  border-radius: 6px;
  cursor: pointer;
}

@media (max-width: 680px) {
  .header__toggle {
    display: grid;
  }

  .nav {
    display: none;
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    flex-direction: column;
    padding: 8px var(--gutter) 20px;
    background: var(--byte);
    box-shadow: 0 6px 0 var(--byte-deep);
  }

  .nav--open {
    display: flex;
  }

  .nav__link {
    font-size: var(--step-1);
  }
}
</style>
