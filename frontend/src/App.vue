<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import SiteHeader from './components/SiteHeader.vue'
import SiteFooter from './components/SiteFooter.vue'
import GearField from './components/GearField.vue'
import { loadSettings } from './api.js'

const route = useRoute()
const isAdmin = computed(() => route.path.startsWith('/admin'))
loadSettings()
</script>

<template>
  <a class="skip" href="#main">Skip to content</a>
  <div class="page" :class="{ 'page--site': !isAdmin }">
    <GearField v-if="!isAdmin" />
    <SiteHeader v-if="!isAdmin" />
    <main id="main">
      <RouterView />
    </main>
    <SiteFooter v-if="!isAdmin" />
  </div>
</template>

<style>
.skip {
  position: absolute;
  left: 12px;
  top: -60px;
  z-index: 100;
  padding: 10px 14px;
  background: var(--brass);
  color: var(--ink);
  font-weight: 600;
  border-radius: 4px;
}

.skip:focus {
  top: 12px;
}

.page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.page--site {
  position: relative;
  isolation: isolate;
  overflow-x: clip;
}

main {
  flex: 1;
}
</style>
