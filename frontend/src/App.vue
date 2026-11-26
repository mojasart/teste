<script setup>
import { computed, watchEffect } from 'vue'
import { useRoute } from 'vue-router'
import SiteHeader from './components/SiteHeader.vue'
import SiteFooter from './components/SiteFooter.vue'
import { loadSettings } from './api.js'

const route = useRoute()
const isAdmin = computed(() => route.path.startsWith('/admin'))
loadSettings()
watchEffect(() => document.body.classList.toggle('night', !isAdmin.value))
</script>

<template>
  <a class="skip" href="#conteudo">Pular para o conteúdo</a>
  <SiteHeader v-if="!isAdmin" />
  <main id="conteudo">
    <RouterView />
  </main>
  <SiteFooter v-if="!isAdmin" />
</template>

<style>
.skip {
  position: absolute;
  left: 12px;
  top: -60px;
  z-index: 50;
  padding: 10px 14px;
  background: var(--brass);
  color: var(--ink);
  font-weight: 700;
  border-radius: 6px;
}
.skip:focus {
  top: 12px;
}
#app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}
main {
  flex: 1;
}
</style>
