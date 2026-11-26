<script setup>
import { onMounted, ref } from 'vue'
import { api } from '../../api.js'

const list = ref([])
const loading = ref(true)
const error = ref('')

onMounted(async () => {
  try {
    list.value = await api('/admin/addons')
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <div class="head">
    <h1>Projetos</h1>
    <RouterLink to="/admin/projetos/novo" class="btn btn--purple">Novo projeto</RouterLink>
  </div>

  <p v-if="error" class="notice notice--error">{{ error }}</p>
  <p v-else-if="loading">Carregando…</p>
  <div v-else-if="!list.length" class="empty">
    <p>Nenhum projeto cadastrado. Comece pelo primeiro addon do portfólio.</p>
    <RouterLink to="/admin/projetos/novo" class="btn">Novo projeto</RouterLink>
  </div>

  <ul v-else class="rows">
    <li v-for="p in list" :key="p.id" class="row">
      <img v-if="p.cover_image || p.banner_image" :src="p.cover_image || p.banner_image" alt="" class="row__img" />
      <span v-else class="row__img" />
      <div class="row__text">
        <RouterLink :to="`/admin/projetos/${p.id}`" class="row__title">{{ p.title }}</RouterLink>
        <span class="row__meta">
          <span :class="p.published ? 'tag tag--on' : 'tag'">{{ p.published ? 'Publicado' : 'Rascunho' }}</span>
          <span v-if="p.featured" class="tag tag--star">Destaque</span>
          <span v-if="p.category">{{ p.category.name }}</span>
        </span>
      </div>
      <RouterLink :to="`/admin/projetos/${p.id}`" class="btn btn--small btn--ghost">Editar</RouterLink>
    </li>
  </ul>
</template>

<style scoped>
.head {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  margin-bottom: 24px;
}

.head h1 {
  font-size: var(--step-3);
}

.empty {
  display: grid;
  justify-items: start;
  gap: 16px;
  padding: 32px;
  background: var(--white);
  border-radius: 8px;
}

.rows {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: 10px;
}

.row {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 12px;
  background: var(--white);
  border-radius: 8px;
}

.row__img {
  width: 112px;
  aspect-ratio: 16 / 9;
  object-fit: cover;
  background: var(--line);
  border-radius: 4px;
  flex: none;
}

.row__text {
  flex: 1;
  display: grid;
  gap: 4px;
  min-width: 0;
}

.row__title {
  font-weight: 800;
  font-size: var(--step-1);
  text-decoration: none;
}

.row__meta {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  font-size: var(--step--1);
  color: var(--muted);
}

.tag {
  padding: 1px 8px;
  border-radius: 4px;
  background: var(--paper);
  font-weight: 700;
}

.tag--on {
  background: #e2f5ea;
  color: var(--ok);
}

.tag--star {
  background: #fff3d1;
  color: #8a5a00;
}

@media (max-width: 560px) {
  .row__img {
    width: 72px;
  }
}
</style>
