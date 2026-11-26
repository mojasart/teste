<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { api } from '../api.js'
import ProjectTile from '../components/ProjectTile.vue'
import PixelEdge from '../components/PixelEdge.vue'

const route = useRoute()
const router = useRouter()
const projects = ref([])
const categories = ref([])
const loading = ref(true)
const failed = ref(false)

onMounted(async () => {
  try {
    ;[projects.value, categories.value] = await Promise.all([api('/addons'), api('/categories')])
  } catch {
    failed.value = true
  } finally {
    loading.value = false
  }
})

const active = computed(() => route.query.tipo || '')
const usedCategories = computed(() => categories.value.filter((c) => c.total > 0))
const shown = computed(() =>
  active.value ? projects.value.filter((p) => p.category?.slug === active.value) : projects.value
)

// os primeiros ficam grandes (2 por linha) para que nenhuma linha de 3 sobre incompleta
const bigCount = computed(() => {
  const n = shown.value.length
  if (n < 4) return n === 2 ? 2 : 0
  return { 0: 0, 1: 4, 2: 2 }[n % 3]
})

function pick(slug) {
  router.replace({ query: slug ? { tipo: slug } : {} })
}
</script>

<template>
  <section class="top">
    <div class="wrap top__inner">
      <h1 class="top__title">Projetos</h1>
      <p v-if="!loading && !failed" class="top__lead">
        {{ projects.length }} addons publicados no Minecraft Marketplace.
      </p>
    </div>
  </section>
  <PixelEdge :seed="5" />

  <section class="wrap list">
    <div v-if="usedCategories.length > 1" class="filters" role="group" aria-label="Filtrar por tipo">
      <button type="button" class="chip" :aria-pressed="!active" @click="pick('')">Todos</button>
      <button
        v-for="c in usedCategories"
        :key="c.slug"
        type="button"
        class="chip"
        :aria-pressed="active === c.slug"
        @click="pick(c.slug)"
      >
        {{ c.name }}
      </button>
    </div>

    <p v-if="loading" class="state">Carregando projetos…</p>
    <p v-else-if="failed" class="state">Não deu para carregar os projetos agora. Recarregue a página.</p>
    <p v-else-if="!shown.length" class="state">Nenhum projeto desse tipo ainda.</p>
    <div v-else class="grid">
      <ProjectTile
        v-for="(p, i) in shown"
        :key="p.id"
        v-reveal="i < bigCount ? i % 2 : (i - bigCount) % 3"
        :project="p"
        :big="i < bigCount"
        :class="i < bigCount ? 'span-6' : 'span-4'"
      />
    </div>
  </section>
</template>

<style scoped>
.top {
  background: var(--byte);
  color: var(--white);
}

.top__inner {
  display: flex;
  flex-wrap: wrap;
  align-items: end;
  justify-content: space-between;
  gap: 16px 48px;
  padding-block: clamp(40px, 6vw, 80px) 24px;
}

.top__title {
  font-size: var(--step-4);
  font-stretch: 75%;
  line-height: 0.9;
  text-shadow: 0.05em 0.06em 0 var(--byte-deep);
}

.top__lead {
  font-size: var(--step-1);
  max-width: 34ch;
}

.list {
  padding-block: clamp(32px, 5vw, 56px) clamp(72px, 9vw, 128px);
}

.filters {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 40px;
}

.chip {
  min-height: 42px;
  padding: 0 18px;
  font: inherit;
  font-weight: 700;
  color: var(--hi);
  background: var(--night-2);
  border: 1px solid var(--night-3);
  border-radius: 999px;
  cursor: pointer;
}

.chip[aria-pressed='true'] {
  background: var(--byte);
  border-color: var(--byte);
}

.state {
  color: var(--mid);
  font-size: var(--step-1);
}

.grid {
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

@media (max-width: 900px) {
  .span-6,
  .span-4 {
    grid-column: span 12;
  }
}
</style>
