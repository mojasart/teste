<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import SectionTitle from './SectionTitle.vue'
import SocialIcons from './SocialIcons.vue'
const year = new Date().getFullYear()
// a página de contato já lista as redes
const route = useRoute()
const showSocial = computed(() => route.path.replace(/\/$/, '') !== '/contact')
</script>

<template>
  <footer class="footer">
    <section v-if="showSocial" class="wrap" aria-labelledby="social-title">
      <SectionTitle id="social-title">Social</SectionTitle>
      <SocialIcons />
    </section>
    <p class="footer__legal wrap">
      © {{ year }} PurpleByte LLC. Minecraft is a trademark of Mojang Studios and Microsoft.
    </p>
  </footer>
</template>

<style scoped>
.footer {
  padding-block: clamp(48px, 6vw, 80px) 28px;
}

.footer__legal {
  margin-top: clamp(40px, 5vw, 60px);
  text-align: center;
  font-size: var(--step--1);
  color: var(--mid);
}
</style>
