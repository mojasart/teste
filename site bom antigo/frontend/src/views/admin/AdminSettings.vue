<script setup>
import { onMounted, reactive, ref } from 'vue'
import { api, refreshSettings } from '../../api.js'

const form = reactive({})
const errors = ref({})
const message = ref(null)
const saving = ref(false)
const loading = ref(true)

const groups = [
  {
    title: 'Página inicial',
    fields: [
      ['hero_title', 'Título principal'],
      ['hero_subtitle', 'Texto embaixo do título', 'textarea'],
    ],
  },
  {
    title: 'Números',
    hint: 'Aparecem numa faixa na página inicial. Deixe em branco para esconder.',
    fields: [
      ['stat_downloads', 'Downloads', 'text', 'ex: 2 milhões'],
      ['stat_projects', 'Projetos lançados', 'text', 'ex: 12'],
      ['stat_years', 'Anos criando', 'text', 'ex: 3'],
    ],
  },
  { title: 'Sobre', fields: [['about_text', 'Texto da página Sobre', 'textarea', '', 'Deixe uma linha em branco entre os parágrafos.']] },
  {
    title: 'Contato e redes',
    fields: [
      ['contact_email', 'E-mail de contato', 'email'],
      ['social_youtube', 'YouTube', 'url', 'https://'],
      ['social_discord', 'Discord', 'url', 'https://'],
      ['social_twitter', 'X / Twitter', 'url', 'https://'],
      ['social_instagram', 'Instagram', 'url', 'https://'],
    ],
  },
]

onMounted(async () => {
  try {
    Object.assign(form, await api('/settings'))
  } catch (e) {
    message.value = { type: 'error', text: e.message }
  } finally {
    loading.value = false
  }
})

async function save() {
  saving.value = true
  errors.value = {}
  message.value = null
  try {
    const s = await api('/admin/settings', { method: 'PUT', body: form })
    refreshSettings(s)
    message.value = { type: 'ok', text: 'Textos e links salvos.' }
  } catch (e) {
    errors.value = e.fields || {}
    message.value = { type: 'error', text: e.message }
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <h1 class="title">Textos e links</h1>
  <p v-if="loading">Carregando…</p>
  <form v-else class="edit" novalidate @submit.prevent="save">
    <p v-if="message" :class="['notice', `notice--${message.type}`]" role="status">{{ message.text }}</p>
    <fieldset v-for="g in groups" :key="g.title" class="box">
      <legend>{{ g.title }}</legend>
      <p v-if="g.hint" class="hint">{{ g.hint }}</p>
      <label v-for="[key, label, type, ph, help] in g.fields" :key="key" class="field">
        <span>{{ label }}</span>
        <textarea v-if="type === 'textarea'" v-model="form[key]" class="input" rows="5" :aria-invalid="!!errors[key]"></textarea>
        <input v-else v-model="form[key]" class="input" :type="type || 'text'" :placeholder="ph" :aria-invalid="!!errors[key]" />
        <small v-if="help">{{ help }}</small>
        <small v-if="errors[key]" class="error">{{ errors[key] }}</small>
      </label>
    </fieldset>
    <button class="btn btn--purple" type="submit" :disabled="saving">{{ saving ? 'Salvando…' : 'Salvar textos e links' }}</button>
  </form>
</template>

<style scoped>
.title {
  font-size: var(--step-3);
  margin-bottom: 24px;
}

.edit {
  display: grid;
  gap: 24px;
  max-width: 760px;
  justify-items: start;
}

.box {
  display: grid;
  gap: 18px;
  width: 100%;
  margin: 0;
  padding: 24px;
  background: var(--white);
  border: 0;
  border-radius: 8px;
}

.box legend {
  float: left;
  width: 100%;
  font-weight: 800;
  font-size: var(--step-1);
}

.hint {
  color: var(--muted);
  font-size: var(--step--1);
}
</style>
