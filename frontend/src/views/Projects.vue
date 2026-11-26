<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { api } from '../api.js'
import ProjectCard from '../components/ProjectCard.vue'

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

function pick(slug) {
  router.replace({ query: slug ? { tipo: slug } : {} })
}
</script>

<template>
  <section class="page wrap">
    <h1 class="page__title">Projetos</h1>

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
      <ProjectCard v-for="p in shown" :key="p.id" :project="p" />
    </div>
  </section>
</template>

<style scoped>
.page {
  padding-block: clamp(40px, 6vw, 80px) clamp(64px, 8vw, 112px);
}

.page__title {
  font-size: var(--step-4);
  font-stretch: 75%;
  color: var(--byte);
  text-shadow: 0.05em 0.06em 0 var(--line);
}

.filters {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 28px;
}

.chip {
  min-height: 42px;
  padding: 0 16px;
  font: inherit;
  font-weight: 700;
  color: var(--ink);
  background: var(--white);
  border: 2px solid var(--line);
  border-radius: 6px;
  cursor: pointer;
}

.chip[aria-pressed='true'] {
  background: var(--ink);
  border-color: var(--ink);
  color: var(--white);
}

.state {
  margin-top: 40px;
  color: var(--muted);
  font-size: var(--step-1);
}

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(min(100%, 320px), 1fr));
  gap: 40px 32px;
  margin-top: 40px;
}
</style>
