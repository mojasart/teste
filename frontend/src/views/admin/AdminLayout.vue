<script setup>
import { useRouter } from 'vue-router'
import { admin, api } from '../../api.js'

const router = useRouter()

async function logout() {
  try {
    await api('/admin/logout', { method: 'POST' })
  } finally {
    admin.user = null
    router.replace('/admin/login')
  }
}
</script>

<template>
  <div class="admin">
    <header class="admin__bar">
      <div class="wrap admin__barInner">
        <RouterLink to="/admin" class="admin__brand">Painel PurpleByte</RouterLink>
        <nav class="admin__nav" aria-label="Painel">
          <RouterLink to="/admin" exact-active-class="is-active" :class="{ 'is-active': $route.path.startsWith('/admin/projetos') }">Projetos</RouterLink>
          <RouterLink to="/admin/mensagens" active-class="is-active">Mensagens</RouterLink>
          <RouterLink to="/admin/textos" active-class="is-active">Textos e links</RouterLink>
        </nav>
        <div class="admin__user">
          <a href="/" target="_blank" rel="noopener">Ver site</a>
          <button type="button" class="btn btn--small btn--ghost" @click="logout">Sair</button>
        </div>
      </div>
    </header>
    <div class="wrap admin__page">
      <RouterView />
    </div>
  </div>
</template>

<style scoped>
.admin {
  min-height: 100vh;
}

.admin__bar {
  background: var(--ink);
  color: var(--white);
}

.admin__barInner {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px 28px;
  min-height: 64px;
  padding-block: 8px;
}

.admin__brand {
  font-weight: 800;
  font-stretch: 80%;
  font-size: var(--step-1);
  text-decoration: none;
}

.admin__nav {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  flex: 1;
}

.admin__nav a {
  padding: 8px 12px;
  border-radius: 6px;
  text-decoration: none;
  font-weight: 600;
}

.admin__nav a.is-active {
  background: var(--byte);
}

.admin__user {
  display: flex;
  align-items: center;
  gap: 14px;
}

.admin__page {
  padding-block: 32px 80px;
}
</style>
