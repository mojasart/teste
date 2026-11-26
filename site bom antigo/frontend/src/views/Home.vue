<script setup>
import { computed, onMounted, ref } from 'vue'
import { api, site } from '../api.js'
import BrandMark from '../components/BrandMark.vue'
import ProjectTile from '../components/ProjectTile.vue'
import Conveyor from '../components/Conveyor.vue'
import PixelEdge from '../components/PixelEdge.vue'
import PartnerBadge from '../components/PartnerBadge.vue'

const projects = ref([])
const loading = ref(true)
const failed = ref(false)

onMounted(async () => {
  try {
    projects.value = await api('/addons')
  } catch {
    failed.value = true
  } finally {
    loading.value = false
  }
})

const featured = computed(() => projects.value.find((p) => p.featured) || projects.value[0])
const rest = computed(() => projects.value.filter((p) => p !== featured.value).slice(0, 8))
// artes usadas no bento do estúdio (escolhe por slug, cai pra qualquer uma se não achar)
const art = (slug, i) => {
  const p = projects.value.find((x) => x.slug === slug) || projects.value[i]
  return p ? p.cover_image || p.banner_image : ''
}
const discord = computed(() => site.settings?.social_discord)
const s = computed(() => site.settings || {})
const stats = computed(() =>
  [
    [s.value.stat_downloads, 'downloads'],
    [s.value.stat_projects, 'projects shipped'],
    [s.value.stat_years, 'years making Minecraft content'],
  ].filter(([v]) => v)
)
</script>

<template>
  <section class="hero">
    <div class="wrap hero__grid">
      <div class="hero__text">
        <h1 class="hero__title">{{ s.hero_title || 'We build worlds for Minecraft.' }}</h1>
        <p class="hero__sub">{{ s.hero_subtitle }}</p>
        <div class="hero__actions">
          <RouterLink to="/projects" class="btn">See our projects</RouterLink>
          <RouterLink to="/contact" class="btn btn--ghost">Work with us</RouterLink>
        </div>
        <PartnerBadge class="hero__badge" />
      </div>
      <div class="hero__mark" aria-hidden="true">
        <BrandMark animate spin />
      </div>
    </div>
    <Conveyor class="hero__belt" :projects="projects" />
  </section>
  <PixelEdge />

  <section v-if="stats.length" class="stats wrap" aria-label="Studio numbers">
    <dl class="stats__row">
      <div v-for="[value, label] in stats" :key="label">
        <dt>{{ label }}</dt>
        <dd>{{ value }}</dd>
      </div>
    </dl>
  </section>

  <p v-if="loading" class="wrap state">Loading projects…</p>
  <p v-else-if="failed" class="wrap state">Projects could not be loaded. Refresh the page to try again.</p>

  <template v-else-if="featured">
    <section class="wrap feature" aria-label="Featured release">
      <RouterLink v-reveal :to="`/projects/${featured.slug}`" class="feature__card" :style="{ '--accent': featured.accent_color }">
        <div class="feature__media">
          <img class="feature__img" :src="featured.cover_image || featured.banner_image" :alt="`${featured.title} key art`" />
        </div>
        <div class="feature__body">
          <div class="feature__text">
            <span class="pill">Featured release</span>
            <h2 class="feature__title">{{ featured.title }}</h2>
            <p v-if="featured.tagline" class="feature__tag">{{ featured.tagline }}</p>
          </div>
          <span class="btn">View project</span>
        </div>
      </RouterLink>
    </section>

    <section class="wrap work" aria-labelledby="projects-title">
      <header class="work__head">
        <h2 id="projects-title" class="work__title">Projects</h2>
        <p class="work__lead">
          {{ projects.length }} add-ons for Minecraft: Bedrock Edition, from machines and automation to magic and exploration.
        </p>
      </header>

      <div class="work__grid">
        <ProjectTile
          v-for="(p, i) in rest"
          :key="p.id"
          v-reveal="i < 2 ? i : (i - 2) % 3"
          :project="p"
          :big="i < 2"
          :class="i < 2 ? 'span-6' : 'span-4'"
        />
      </div>

    </section>
  </template>

  <!-- bento do estúdio: blocos de texto + artes -->
  <section v-if="projects.length" class="wrap studio" aria-label="About the studio">
    <div v-reveal="0" class="studio__block studio__block--purple">
      <h2>Made by players, for players</h2>
      <p>A team of builders, artists and developers making add-ons for Minecraft: Bedrock Edition. Every add-on is tested in our own worlds before it ships.</p>
      <RouterLink to="/about" class="btn btn--ghost">Who we are</RouterLink>
    </div>
    <RouterLink v-reveal="1" to="/projects/waystones" class="studio__art" aria-label="Waystones">
      <img :src="art('waystones', 0)" alt="" loading="lazy" />
    </RouterLink>
    <RouterLink v-reveal="0" to="/projects/basic-machinery" class="studio__art" aria-label="Basic Machinery">
      <img :src="art('basic-machinery', 1)" alt="" loading="lazy" />
    </RouterLink>
    <div v-reveal="1" class="studio__block studio__block--brass">
      <h2>Work with us</h2>
      <p>Custom add-ons, brand partnerships and collaborations for the Minecraft Marketplace.</p>
      <RouterLink to="/contact" class="btn btn--dark">Get in touch</RouterLink>
    </div>
  </section>

  <!-- fechamento: dois blocos grandes clicáveis -->
  <section class="wrap big">
    <RouterLink v-reveal="0" to="/projects" class="big__tile big__tile--purple">
      <span class="big__label">Explore all {{ projects.length || '' }} add-ons</span>
      <svg class="big__icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M4 12h14M13 6l6 6-6 6" /></svg>
    </RouterLink>
    <a v-if="discord" v-reveal="1" :href="discord" target="_blank" rel="noopener" class="big__tile big__tile--dark">
      <span class="big__label">Join our Discord</span>
      <svg class="big__icon big__icon--fill" viewBox="0 0 24 24" aria-hidden="true"><path d="M20.3 4.4A19.8 19.8 0 0 0 15.4 3l-.6 1.3a18.4 18.4 0 0 0-5.6 0L8.6 3a19.7 19.7 0 0 0-4.9 1.5C.6 9.1-.3 13.7.1 18.2a19.9 19.9 0 0 0 6 3l1.3-2.1a13 13 0 0 1-2-1l.5-.4a14.2 14.2 0 0 0 12.2 0l.5.4c-.6.4-1.3.7-2 1l1.3 2.1a19.8 19.8 0 0 0 6-3c.5-5.2-.9-9.7-3.6-13.8zM8 15.4c-1.2 0-2.2-1.1-2.2-2.4s1-2.4 2.2-2.4 2.2 1.1 2.2 2.4-1 2.4-2.2 2.4zm8 0c-1.2 0-2.2-1.1-2.2-2.4s1-2.4 2.2-2.4 2.2 1.1 2.2 2.4-1 2.4-2.2 2.4z" /></svg>
    </a>
    <RouterLink v-else v-reveal="1" to="/contact" class="big__tile big__tile--dark">
      <span class="big__label">Work with us</span>
      <svg class="big__icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M4 12h14M13 6l6 6-6 6" /></svg>
    </RouterLink>
  </section>
</template>

<style scoped>
.hero {
  background: var(--byte);
  color: var(--white);
  padding: clamp(32px, 6vw, 72px) 0 0;
  overflow: hidden;
}

.hero__belt {
  margin-top: clamp(48px, 7vw, 88px);
  margin-bottom: clamp(20px, 3vw, 36px);
}

.hero__grid {
  display: grid;
  grid-template-columns: 1.25fr 1fr;
  align-items: center;
  gap: clamp(24px, 5vw, 72px);
}

.hero__title {
  font-size: var(--step-4);
  font-stretch: 75%;
  line-height: 0.95;
  text-shadow: 0.05em 0.06em 0 var(--byte-deep);
  text-wrap: balance;
}

.hero__sub {
  margin-top: 24px;
  max-width: 38ch;
  font-size: var(--step-1);
  line-height: 1.4;
}

.hero__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  margin-top: 36px;
}

.hero__badge {
  margin-top: 28px;
}

.hero__mark {
  max-width: 440px;
  justify-self: end;
  width: 100%;
}

.state {
  padding-block: 64px;
  color: var(--mid);
  font-size: var(--step-1);
}

.stats__row {
  display: flex;
  flex-wrap: wrap;
  gap: 16px 64px;
  margin: 0;
  padding-block: 40px 8px;
}

.stats__row div {
  display: flex;
  flex-direction: column-reverse;
}

.stats dd {
  margin: 0;
  font-size: var(--step-3);
  font-weight: 800;
  font-stretch: 75%;
  line-height: 1;
  color: var(--brass);
}

.stats dt {
  color: var(--mid);
}

/* ---------- destaque ---------- */
.feature {
  padding-top: clamp(40px, 6vw, 72px);
}

.feature__card {
  display: grid;
  grid-template-columns: minmax(0, 1.45fr) minmax(0, 1fr);
  overflow: hidden;
  border-radius: 12px;
  color: var(--hi);
  text-decoration: none;
  background: var(--night-2);
  border: 1px solid var(--night-3);
  box-shadow: 0 40px 120px -50px var(--accent);
  transition: box-shadow 300ms ease, border-color 300ms ease;
}

.feature__card:hover {
  border-color: var(--accent);
  box-shadow: 0 40px 140px -40px var(--accent);
}

.feature__media {
  position: relative;
  min-height: 300px;
  overflow: hidden;
}

/* a arte preenche toda a altura do cartão, sem faixa vazia */
.feature__img {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 900ms cubic-bezier(0.2, 0.8, 0.2, 1);
}

.feature__card:hover .feature__img {
  transform: scale(1.03);
}

.feature__body {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  justify-content: center;
  gap: 28px;
  padding: clamp(24px, 4vw, 48px);
}

.feature__text {
  display: grid;
  justify-items: start;
  gap: 8px;
}

.feature__title {
  font-size: clamp(2rem, 3.4vw, 3rem);
  font-stretch: 75%;
  line-height: 1;
}

.feature__tag {
  color: var(--mid);
  font-size: var(--step-0);
}

/* ---------- projetos ---------- */
.work {
  padding-block: clamp(72px, 9vw, 128px) clamp(56px, 8vw, 96px);
}

.work__head {
  display: grid;
  grid-template-columns: auto minmax(0, 420px);
  justify-content: space-between;
  align-items: end;
  gap: 16px 48px;
  margin-bottom: 48px;
}

.work__title {
  font-size: var(--step-4);
  font-stretch: 75%;
  line-height: 0.9;
}

.work__lead {
  color: var(--mid);
  font-size: var(--step-1);
  line-height: 1.4;
}

.work__grid {
  display: grid;
  grid-template-columns: repeat(12, minmax(0, 1fr));
  gap: 48px 28px;
}

.span-6 {
  grid-column: span 6;
}

.span-4 {
  grid-column: span 4;
}

/* ---------- bento do estúdio ---------- */
.studio {
  display: grid;
  grid-template-columns: repeat(12, minmax(0, 1fr));
  gap: 20px;
  padding-bottom: 20px;
}

.studio > :nth-child(1),
.studio > :nth-child(4) {
  grid-column: span 5;
}

.studio > :nth-child(2),
.studio > :nth-child(3) {
  grid-column: span 7;
}

.studio__block {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 14px;
  padding: clamp(24px, 3.5vw, 40px);
  border-radius: 16px;
}

.studio__block h2 {
  font-size: clamp(1.8rem, 3.2vw, 2.6rem);
  font-stretch: 75%;
  line-height: 0.95;
  text-wrap: balance;
}

.studio__block p {
  max-width: 38ch;
  margin-bottom: auto;
  padding-bottom: 12px;
  font-size: 1.05rem;
  line-height: 1.45;
}

.studio__block--purple {
  color: var(--white);
  background: var(--byte);
  box-shadow: 6px 6px 0 var(--byte-deep);
}

.studio__block--purple h2 {
  text-shadow: 0.05em 0.06em 0 var(--byte-deep);
}

.studio__block--brass {
  color: var(--ink);
  background: var(--brass);
  box-shadow: 6px 6px 0 var(--brass-deep);
}

.btn--dark {
  --btn-bg: var(--ink);
  --btn-fg: var(--white);
  --btn-shadow: #0b0516;
}

.studio__art {
  display: block;
  min-height: 260px;
  overflow: hidden;
  border-radius: 16px;
  background: var(--night-2);
}

.studio__art img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 700ms cubic-bezier(0.2, 0.8, 0.2, 1);
}

.studio__art:hover img {
  transform: scale(1.05);
}

/* ---------- fechamento ---------- */
.big {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  padding-block: 20px clamp(48px, 6vw, 80px);
}

.big__tile {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  min-height: clamp(150px, 16vw, 210px);
  padding: clamp(22px, 3vw, 34px);
  border-radius: 16px;
  text-decoration: none;
  color: var(--white);
  transition: transform 160ms ease, box-shadow 160ms ease;
}

.big__tile--purple {
  background: var(--byte);
  box-shadow: 6px 6px 0 var(--byte-deep);
}

.big__tile--dark {
  background: #5865f2;
  box-shadow: 6px 6px 0 #3a43b5;
}

.big__tile:hover {
  transform: translate(-3px, -3px);
}

.big__tile--purple:hover {
  box-shadow: 9px 9px 0 var(--byte-deep);
}

.big__tile--dark:hover {
  box-shadow: 9px 9px 0 #3a43b5;
}

.big__label {
  max-width: 12ch;
  font-size: clamp(1.9rem, 3.6vw, 3rem);
  font-weight: 800;
  font-stretch: 75%;
  line-height: 0.95;
  text-shadow: 0.05em 0.06em 0 rgb(0 0 0 / 0.2);
}

.big__icon {
  flex: none;
  width: clamp(36px, 4vw, 52px);
  height: auto;
  fill: none;
  stroke: currentColor;
  stroke-width: 2.6;
  stroke-linecap: square;
  transition: transform 160ms ease;
}

.big__icon--fill {
  fill: currentColor;
  stroke: none;
}

.big__tile:hover .big__icon {
  transform: translateX(4px);
}

@media (max-width: 900px) {
  .span-6,
  .span-4 {
    grid-column: span 12;
  }

  .grid,
  .work__grid {
    gap: 20px;
  }

  .feature__card,
  .work__head,
  .big {
    grid-template-columns: 1fr;
  }

  .studio > * {
    grid-column: span 12 !important;
  }

  .studio__art {
    min-height: 0;
    aspect-ratio: 16 / 9;
  }

  .feature__media {
    min-height: 0;
    aspect-ratio: 16 / 9;
  }
}

@media (max-width: 760px) {
  .hero__grid {
    grid-template-columns: 1fr;
  }

  .hero__badge {
  margin-top: 28px;
}

.hero__mark {
    order: -1;
    max-width: 150px;
    justify-self: start;
  }
}
</style>
