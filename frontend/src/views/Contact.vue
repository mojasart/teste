<script setup>
import { site } from '../content.js'
import discord from '../assets/social/discord.svg'
import x from '../assets/social/x.svg'
import youtube from '../assets/social/youtube.png'

const s = site.social
const ways = [
  s.discord && {
    icon: discord,
    title: 'Discord',
    text: 'Support for our add-ons, news and the community. The fastest way to reach us.',
    action: 'Join our Discord',
    href: s.discord,
    main: true,
  },
  site.email && {
    title: 'Business',
    text: 'Partnerships, custom add-ons and press.',
    action: site.email,
    href: `mailto:${site.email}`,
  },
  s.x && { icon: x, title: 'X', text: 'Announcements and sneak peeks.', action: 'Follow us on X', href: s.x },
  s.youtube && { icon: youtube, title: 'YouTube', text: 'Trailers and showcases.', action: 'Watch on YouTube', href: s.youtube },
].filter(Boolean)
</script>

<template>
  <section class="wrap contact">
    <header class="contact__head">
      <h1 class="contact__title display">Contact</h1>
      <p>Questions about an add-on, partnerships or custom projects: pick the channel that fits and talk to the team.</p>
    </header>

    <div class="ways">
      <a
        v-for="(w, n) in ways"
        :key="w.title"
        v-reveal="n"
        :href="w.href"
        :target="w.href.startsWith('mailto:') ? undefined : '_blank'"
        rel="noopener"
        class="way"
        :class="{ 'way--main': w.main }"
      >
        <img v-if="w.icon" :src="w.icon" alt="" class="way__icon" />
        <h2 class="way__title display">{{ w.title }}</h2>
        <p class="way__text">{{ w.text }}</p>
        <span class="way__action">
          {{ w.action }}
          <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M7 17L17 7M9 7h8v8" /></svg>
        </span>
      </a>
    </div>
  </section>
</template>

<style scoped>
.contact {
  padding-top: clamp(40px, 7vw, 96px);
}

.contact__head {
  display: grid;
  gap: 14px;
  max-width: 56ch;
  margin-bottom: clamp(28px, 4vw, 48px);
  color: var(--mid);
  font-size: 1.08rem;
}

.contact__title {
  font-size: var(--step-4);
  line-height: 0.9;
  color: var(--hi);
}

.ways {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
}

.way {
  display: flex;
  flex-direction: column;
  gap: 10px;
  min-height: 220px;
  padding: clamp(20px, 2.6vw, 30px);
  color: var(--hi);
  text-decoration: none;
  background: var(--panel);
  border: 1px solid rgb(255 255 255 / 0.06);
  border-radius: 6px;
  transition: transform 220ms ease, border-color 220ms ease, background-color 220ms ease;
}

.way:hover,
.way:focus-visible {
  transform: translateY(-4px);
  border-color: var(--accent-hi);
  background: var(--panel-hi);
}

/* Discord ocupa a linha inteira: é o canal principal */
.way--main {
  grid-column: 1 / -1;
  min-height: 0;
  background: #5865f2;
  border-color: #5865f2;
}

.way--main:hover,
.way--main:focus-visible {
  background: #4752e0;
  border-color: #c7ccff;
}

.way--main .way__text {
  color: #e4e6ff;
}

.way__icon {
  width: auto;
  height: 34px;
  margin-bottom: 6px;
  align-self: flex-start;
}

.way__title {
  font-size: clamp(1.8rem, 3vw, 2.4rem);
  line-height: 1;
}

.way__text {
  max-width: 48ch;
  color: var(--mid);
}

.way__action {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  margin-top: auto;
  padding-top: 10px;
  font-weight: 600;
}

.way__action svg {
  width: 16px;
  height: 16px;
  fill: none;
  stroke: currentColor;
  stroke-width: 2.2;
  transition: transform 200ms ease;
}

.way:hover .way__action svg {
  transform: translate(2px, -2px);
}

@media (max-width: 800px) {
  .ways {
    grid-template-columns: 1fr;
  }

  .way {
    min-height: 0;
  }
}
</style>
