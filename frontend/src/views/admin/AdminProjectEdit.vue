<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { api } from '../../api.js'
import ImageUpload from '../../components/ImageUpload.vue'

const route = useRoute()
const router = useRouter()
const id = computed(() => route.params.id)
const isNew = computed(() => !id.value)

const blank = {
  title: '', slug: '', tagline: '', description: '', category_id: '',
  cover_image: '', banner_image: '', gallery: [],
  marketplace_url: '', trailer_url: '', accent_color: '#8D4BEB',
  release_date: '', featured: false, published: false, sort_order: 0,
}
const form = reactive({ ...blank })
const categories = ref([])
const errors = ref({})
const message = ref(null) // { type, text }
const loading = ref(true)
const saving = ref(false)

onMounted(async () => {
  try {
    categories.value = await api('/categories')
    if (!isNew.value) {
      const p = await api(`/admin/addons/${id.value}`)
      Object.assign(form, { ...p, category_id: p.category_id ?? '', release_date: p.release_date ?? '' })
    }
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
    const saved = await api(isNew.value ? '/admin/addons' : `/admin/addons/${id.value}`, {
      method: isNew.value ? 'POST' : 'PUT',
      body: form,
    })
    Object.assign(form, { ...saved, category_id: saved.category_id ?? '', release_date: saved.release_date ?? '' })
    message.value = { type: 'ok', text: form.published ? 'Projeto salvo e publicado no site.' : 'Projeto salvo como rascunho.' }
    if (isNew.value) router.replace(`/admin/projetos/${saved.id}`)
  } catch (e) {
    errors.value = e.fields || {}
    message.value = { type: 'error', text: e.message }
  } finally {
    saving.value = false
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

async function remove() {
  if (!confirm(`Excluir "${form.title}"? Isso tira o projeto do site e não dá para desfazer.`)) return
  try {
    await api(`/admin/addons/${id.value}`, { method: 'DELETE' })
    router.replace('/admin')
  } catch (e) {
    message.value = { type: 'error', text: e.message }
  }
}

function moveImage(i, dir) {
  const j = i + dir
  if (j < 0 || j >= form.gallery.length) return
  const g = [...form.gallery]
  ;[g[i], g[j]] = [g[j], g[i]]
  form.gallery = g
}
</script>

<template>
  <RouterLink to="/admin" class="back">Projetos</RouterLink>
  <h1 class="title">{{ isNew ? 'Novo projeto' : form.title || 'Editar projeto' }}</h1>

  <p v-if="loading">Carregando…</p>
  <form v-else class="edit" novalidate @submit.prevent="save">
    <p v-if="message" :class="['notice', `notice--${message.type}`]" role="status">{{ message.text }}</p>

    <fieldset class="box">
      <legend>Informações</legend>
      <label class="field">
        <span>Nome</span>
        <input v-model="form.title" class="input" required :aria-invalid="!!errors.title" />
        <small v-if="errors.title" class="error">{{ errors.title }}</small>
      </label>
      <label class="field">
        <span>Endereço da página</span>
        <input v-model="form.slug" class="input" placeholder="gerado a partir do nome" :aria-invalid="!!errors.slug" />
        <small>O projeto fica em /projetos/{{ form.slug || 'nome-do-projeto' }}</small>
        <small v-if="errors.slug" class="error">{{ errors.slug }}</small>
      </label>
      <label class="field">
        <span>Frase curta</span>
        <input v-model="form.tagline" class="input" maxlength="255" :aria-invalid="!!errors.tagline" />
        <small>Aparece no card e embaixo do nome.</small>
        <small v-if="errors.tagline" class="error">{{ errors.tagline }}</small>
      </label>
      <label class="field">
        <span>Descrição</span>
        <textarea v-model="form.description" class="input" rows="8"></textarea>
        <small>Deixe uma linha em branco entre os parágrafos.</small>
      </label>
      <div class="two">
        <label class="field">
          <span>Tipo</span>
          <select v-model="form.category_id" class="input" :aria-invalid="!!errors.category_id">
            <option value="">Sem tipo</option>
            <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
          </select>
        </label>
        <label class="field">
          <span>Data de lançamento</span>
          <input v-model="form.release_date" class="input" type="date" :aria-invalid="!!errors.release_date" />
          <small v-if="errors.release_date" class="error">{{ errors.release_date }}</small>
        </label>
      </div>
    </fieldset>

    <fieldset class="box">
      <legend>Links</legend>
      <label class="field">
        <span>Link no Minecraft Marketplace</span>
        <input v-model="form.marketplace_url" class="input" type="url" placeholder="https://" :aria-invalid="!!errors.marketplace_url" />
        <small v-if="errors.marketplace_url" class="error">{{ errors.marketplace_url }}</small>
      </label>
      <label class="field">
        <span>Trailer no YouTube</span>
        <input v-model="form.trailer_url" class="input" type="url" placeholder="https://youtube.com/watch?v=…" :aria-invalid="!!errors.trailer_url" />
        <small v-if="errors.trailer_url" class="error">{{ errors.trailer_url }}</small>
      </label>
    </fieldset>

    <fieldset class="box">
      <legend>Imagens</legend>
      <div class="images">
        <div class="field">
          <span>Capa do card (16:9)</span>
          <img v-if="form.cover_image" :src="form.cover_image" alt="" class="preview" />
          <div class="row">
            <ImageUpload :label="form.cover_image ? 'Trocar capa' : 'Enviar capa'" @uploaded="form.cover_image = $event" />
            <button v-if="form.cover_image" type="button" class="link" @click="form.cover_image = ''">Remover</button>
          </div>
          <small v-if="errors.cover_image" class="error">{{ errors.cover_image }}</small>
        </div>
        <div class="field">
          <span>Banner da página</span>
          <img v-if="form.banner_image" :src="form.banner_image" alt="" class="preview" />
          <div class="row">
            <ImageUpload :label="form.banner_image ? 'Trocar banner' : 'Enviar banner'" @uploaded="form.banner_image = $event" />
            <button v-if="form.banner_image" type="button" class="link" @click="form.banner_image = ''">Remover</button>
          </div>
          <small>Sem banner, a página usa a capa.</small>
        </div>
      </div>

      <div class="field">
        <span>Galeria</span>
        <ul v-if="form.gallery.length" class="gallery">
          <li v-for="(src, i) in form.gallery" :key="src">
            <img :src="src" alt="" />
            <div class="row">
              <button type="button" class="link" :disabled="i === 0" @click="moveImage(i, -1)">Antes</button>
              <button type="button" class="link" :disabled="i === form.gallery.length - 1" @click="moveImage(i, 1)">Depois</button>
              <button type="button" class="link link--danger" @click="form.gallery.splice(i, 1)">Remover</button>
            </div>
          </li>
        </ul>
        <ImageUpload label="Adicionar imagens" multiple @uploaded="form.gallery.push($event)" />
        <small v-if="errors.gallery" class="error">{{ errors.gallery }}</small>
      </div>
    </fieldset>

    <fieldset class="box">
      <legend>Aparência e publicação</legend>
      <div class="two">
        <label class="field">
          <span>Cor do projeto</span>
          <div class="row">
            <input v-model="form.accent_color" type="color" class="swatch" aria-label="Escolher cor" />
            <input v-model="form.accent_color" class="input" :aria-invalid="!!errors.accent_color" />
          </div>
          <small>Usada na sombra do card e no topo da página.</small>
          <small v-if="errors.accent_color" class="error">{{ errors.accent_color }}</small>
        </label>
        <label class="field">
          <span>Ordem</span>
          <input v-model.number="form.sort_order" class="input" type="number" />
          <small>Números menores aparecem primeiro.</small>
        </label>
      </div>
      <label class="check"><input v-model="form.published" type="checkbox" /> Publicado no site</label>
      <label class="check"><input v-model="form.featured" type="checkbox" /> Destaque na página inicial</label>
    </fieldset>

    <div class="actions">
      <button class="btn btn--purple" type="submit" :disabled="saving">{{ saving ? 'Salvando…' : 'Salvar projeto' }}</button>
      <a v-if="!isNew && form.published" :href="`/projetos/${form.slug}`" target="_blank" rel="noopener">Ver no site</a>
      <button v-if="!isNew" type="button" class="btn btn--small btn--danger push" @click="remove">Excluir projeto</button>
    </div>
  </form>
</template>

<style scoped>
.back {
  color: var(--muted);
  font-weight: 600;
}

.title {
  font-size: var(--step-3);
  margin: 8px 0 24px;
}

.edit {
  display: grid;
  gap: 24px;
  max-width: 860px;
}

.box {
  display: grid;
  gap: 18px;
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
  margin-bottom: 4px;
}

.two {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 18px;
}

.images {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 18px;
}

.preview {
  width: 100%;
  aspect-ratio: 16 / 9;
  object-fit: cover;
  border-radius: 6px;
  background: var(--paper);
}

.row {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
}

.gallery {
  list-style: none;
  margin: 0 0 8px;
  padding: 0;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 12px;
}

.gallery img {
  width: 100%;
  aspect-ratio: 16 / 9;
  object-fit: cover;
  border-radius: 6px;
  margin-bottom: 6px;
}

.link {
  padding: 4px 2px;
  font: inherit;
  font-size: var(--step--1);
  font-weight: 600;
  color: var(--byte-deep);
  background: none;
  border: 0;
  text-decoration: underline;
  cursor: pointer;
}

.link:disabled {
  color: var(--line);
  cursor: default;
}

.link--danger {
  color: var(--danger);
}

.swatch {
  width: 52px;
  height: 48px;
  padding: 2px;
  border: 2px solid var(--line);
  border-radius: 6px;
  background: var(--white);
  flex: none;
}

.row .input {
  flex: 1;
  width: auto;
}

.check {
  display: flex;
  align-items: center;
  gap: 10px;
  font-weight: 600;
}

.check input {
  width: 20px;
  height: 20px;
  accent-color: var(--byte);
}

.actions {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 16px;
}

.push {
  margin-left: auto;
}

@media (max-width: 640px) {
  .two,
  .images {
    grid-template-columns: 1fr;
  }
}
</style>
