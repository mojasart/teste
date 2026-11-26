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

      <div class="work__more">
        <RouterLink to="/projects" class="btn btn--purple">View all {{ projects.length }} projects</RouterLink>
      </div>
    </section>
  </template>

  <section class="wrap cta">
    <div v-reveal class="cta__box">
      <div class="cta__mark" aria-hidden="true"><BrandMark gap="var(--byte)" /></div>
      <div class="cta__text">
        <h2>Have an idea for Minecraft?</h2>
        <p>We build custom add-ons for brands, creators and servers.</p>
      </div>
      <RouterLink to="/contact" class="btn">Work with us</RouterLink>
    </div>
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
  aspect-ratio: 16 / 9;
  overflow: hidden;
}

.feature__img {
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
  font-size: clamp(2.2rem, 4vw, 3.4rem);
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

.work__more {
  display: flex;
  justify-content: center;
  margin-top: 64px;
}

/* ---------- chamada ---------- */
.cta {
  padding-bottom: clamp(72px, 9vw, 128px);
}

.cta__box {
  display: grid;
  grid-template-columns: auto 1fr auto;
  align-items: center;
  gap: 32px;
  padding: clamp(28px, 4vw, 48px);
  background: var(--byte);
  border-radius: 12px;
  box-shadow: 10px 10px 0 var(--byte-deep);
}

.cta__mark {
  width: 88px;
}

.cta__text {
  display: grid;
  gap: 6px;
}

.cta h2 {
  font-size: var(--step-3);
  text-shadow: 0.05em 0.06em 0 var(--byte-deep);
}

.cta p {
  font-size: var(--step-1);
  line-height: 1.4;
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
  .cta__box {
    grid-template-columns: 1fr;
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
