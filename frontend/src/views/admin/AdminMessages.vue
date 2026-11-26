<script setup>
import { onMounted, ref } from 'vue'
import { api } from '../../api.js'

const list = ref([])
const loading = ref(true)
const error = ref('')

onMounted(async () => {
  try {
    list.value = await api('/admin/messages')
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
})

async function markRead(m) {
  await api(`/admin/messages/${m.id}/read`, { method: 'PUT' })
  m.read_at = m.read_at || new Date().toISOString()
}

async function remove(m) {
  if (!confirm(`Excluir a mensagem de ${m.name}?`)) return
  try {
    await api(`/admin/messages/${m.id}`, { method: 'DELETE' })
    list.value = list.value.filter((x) => x !== m)
  } catch (e) {
    error.value = e.message
  }
}

const when = (s) => new Date(s.replace(' ', 'T')).toLocaleString('pt-BR', { dateStyle: 'short', timeStyle: 'short' })
</script>

<template>
  <h1 class="title">Mensagens</h1>
  <p v-if="error" class="notice notice--error">{{ error }}</p>
  <p v-else-if="loading">Carregando…</p>
  <p v-else-if="!list.length" class="empty">Nenhuma mensagem ainda. O que chegar pelo formulário de contato aparece aqui.</p>
  <ul v-else class="msgs">
    <li v-for="m in list" :key="m.id" class="msg" :class="{ 'msg--new': !m.read_at }">
      <div class="msg__head">
        <strong>{{ m.name }}</strong>
        <a :href="`mailto:${m.email}?subject=${encodeURIComponent('Re: ' + (m.subject || 'PurpleByte Studios'))}`" @click="markRead(m)">{{ m.email }}</a>
        <span class="msg__date">{{ when(m.created_at) }}</span>
      </div>
      <p v-if="m.subject" class="msg__subject">{{ m.subject }}</p>
      <p class="msg__text">{{ m.message }}</p>
      <div class="msg__actions">
        <button v-if="!m.read_at" type="button" class="btn btn--small btn--ghost" @click="markRead(m)">Marcar como lida</button>
        <button type="button" class="btn btn--small btn--ghost" @click="remove(m)">Excluir</button>
      </div>
    </li>
  </ul>
</template>

<style scoped>
.title {
  font-size: var(--step-3);
  margin-bottom: 24px;
}

.empty {
  padding: 24px;
  background: var(--white);
  border-radius: 8px;
  color: var(--muted);
}

.msgs {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: 12px;
  max-width: 860px;
}

.msg {
  display: grid;
  gap: 8px;
  padding: 20px;
  background: var(--white);
  border-radius: 8px;
  border-left: 6px solid var(--line);
}

.msg--new {
  border-left-color: var(--byte);
}

.msg__head {
  display: flex;
  flex-wrap: wrap;
  gap: 6px 14px;
  align-items: baseline;
}

.msg__head a {
  color: var(--byte-deep);
}

.msg__date {
  margin-left: auto;
  color: var(--muted);
  font-size: var(--step--1);
}

.msg__subject {
  font-weight: 700;
}

.msg__text {
  white-space: pre-wrap;
}

.msg__actions {
  display: flex;
  gap: 10px;
  margin-top: 6px;
}
</style>
