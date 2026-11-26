<script setup>
import { site } from '../content.js'
import x from '../assets/social/x.svg'
import discord from '../assets/social/discord.svg'
import youtube from '../assets/social/youtube.png'
import vatonage from '../assets/social/vatonage-mark.webp'

// logos oficiais de cada marca; só aparecem os que têm link no painel
const props = defineProps({ small: { type: Boolean, default: false } })
const s = site.social
const links = [
  ['X', x, s.x],
  ['Discord', discord, s.discord],
  ['YouTube', youtube, s.youtube],
  ['Vatonage', vatonage, s.vatonage],
].filter(([, , url]) => url)
</script>

<template>
  <nav v-if="links.length" class="social" :class="{ 'social--small': props.small }" aria-label="Social media">
    <a v-for="[name, icon, url] in links" :key="name" :href="url" target="_blank" rel="noopener" class="social__link">
      <img :src="icon" :alt="name" />
    </a>
  </nav>
</template>

<style scoped>
.social {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  align-items: center;
  gap: clamp(28px, 5vw, 56px);
}

.social__link {
  display: grid;
  place-items: center;
  width: 64px;
  height: 64px;
  transition: transform 220ms cubic-bezier(0.3, 1.6, 0.5, 1), filter 220ms ease;
}

.social__link img {
  max-width: 100%;
  max-height: 52px;
  width: auto;
  height: auto;
}

.social__link:hover,
.social__link:focus-visible {
  transform: translateY(-5px) scale(1.08);
  filter: drop-shadow(0 8px 18px rgb(148 104 214 / 0.55));
}

.social--small {
  gap: 14px;
}

.social--small .social__link {
  width: 36px;
  height: 36px;
}

.social--small .social__link img {
  max-height: 26px;
}
</style>
