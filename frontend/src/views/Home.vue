<script setup>
import { computed, onMounted, ref } from 'vue'
import { api, site } from '../api.js'
import BrandMark from '../components/BrandMark.vue'
import ProjectCard from '../components/ProjectCard.vue'

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
const rest = computed(() => projects.value.filter((p) => p !== featured.value).slice(0, 6))
const s = computed(() => site.settings || {})
const stats = computed(() =>
  [
    [s.value.stat_downloads, 'downloads'],
    [s.value.stat_projects, 'projetos lançados'],
    [s.value.stat_years, 'anos criando'],
  ].filter(([v]) => v)
)
</script>

<template>
  <section class="hero">
    <div class="wrap hero__grid">
      <div class="hero__text">
        <h1 class="hero__title">{{ s.hero_title || 'Criamos mundos para Minecraft.' }}</h1>
        <p class="hero__sub">{{ s.hero_subtitle }}</p>
        <div class="hero__actions">
          <RouterLink to="/projetos" class="btn">Ver projetos</RouterLink>
          <RouterLink to="/contato" class="btn btn--ghost">Falar com o estúdio</RouterLink>
        </div>
      </div>
      <div class="hero__mark" aria-hidden="true">
        <BrandMark animate />
      </div>
    </div>
  </section>

  <section v-if="stats.length" class="stats" aria-label="Números do estúdio">
    <dl class="wrap stats__row">
      <div v-for="[value, label] in stats" :key="label">
        <dt>{{ label }}</dt>
        <dd>{{ value }}</dd>
      </div>
    </dl>
  </section>

  <section class="work wrap" aria-labelledby="titulo-projetos">
    <div class="work__head">
      <h2 id="titulo-projetos">Projetos</h2>
      <RouterLink v-if="projects.length > 1" to="/projetos" class="work__all">Ver todos</RouterLink>
    </div>

    <p v-if="loading" class="work__state">Carregando projetos…</p>
    <p v-else-if="failed" class="work__state">Não deu para carregar os projetos agora. Recarregue a página.</p>
    <template v-else-if="featured">
      <ProjectCard :project="featured" wide />
      <div class="work__grid">
        <ProjectCard v-for="p in rest" :key="p.id" :project="p" />
        <div class="soon chamfer">
          <p class="soon__title">Mais projetos chegando</p>
          <p>Siga a gente para saber dos próximos lançamentos.</p>
        </div>
      </div>
    </template>
    <p v-else class="work__state">Os primeiros projetos aparecem aqui em breve.</p>
  </section>

  <section class="cta">
    <div class="wrap cta__inner">
      <h2>Tem uma ideia para o Minecraft?</h2>
      <p>Fazemos addons, mapas e experiências sob encomenda para marcas e criadores.</p>
      <RouterLink to="/contato" class="btn">Falar com o estúdio</RouterLink>
    </div>
  </section>
</template>

<style scoped>
.hero {
  background: var(--byte);
  color: var(--white);
  padding: clamp(32px, 6vw, 72px) 0 clamp(56px, 9vw, 112px);
  overflow: hidden;
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

.hero__mark {
  max-width: 440px;
  justify-self: end;
  width: 100%;
}

.stats {
  background: var(--ink);
  color: var(--white);
}

.stats__row {
  display: flex;
  flex-wrap: wrap;
  gap: 16px 56px;
  margin: 0 auto;
  padding-block: 28px;
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
  color: #d9cdf5;
}

.work {
  padding-block: clamp(56px, 8vw, 96px);
}

.work__head {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  margin-bottom: 32px;
}

.work__head h2 {
  font-size: var(--step-3);
}

.work__all {
  font-weight: 700;
  color: var(--byte-deep);
}

.work__state {
  color: var(--muted);
  font-size: var(--step-1);
}

.work__grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(min(100%, 320px), 1fr));
  gap: 40px 32px;
  margin-top: 48px;
}

.soon {
  display: grid;
  align-content: center;
  gap: 8px;
  min-height: 220px;
  padding: 28px;
  border: 3px dashed var(--line);
  color: var(--muted);
  clip-path: none;
  border-radius: 0;
}

.soon__title {
  font-weight: 800;
  font-stretch: 80%;
  font-size: var(--step-1);
  color: var(--ink);
}

.cta {
  background: var(--byte);
  color: var(--white);
}

.cta__inner {
  display: grid;
  justify-items: start;
  gap: 16px;
  padding-block: clamp(48px, 7vw, 88px);
}

.cta h2 {
  font-size: var(--step-3);
  text-shadow: 0.05em 0.06em 0 var(--byte-deep);
}

.cta p {
  max-width: 52ch;
  font-size: var(--step-1);
  line-height: 1.4;
  margin-bottom: 12px;
}

@media (max-width: 760px) {
  .hero__grid {
    grid-template-columns: 1fr;
  }

  .hero__mark {
    order: -1;
    max-width: 150px;
    justify-self: start;
  }
}
</style>
