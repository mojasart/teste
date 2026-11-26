<script setup>
import { computed, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { api, formatDate, paragraphs, youtubeId } from '../api.js'

const route = useRoute()
const project = ref(null)
const status = ref('loading') // loading | ok | missing | error
const viewer = ref(null)
const viewing = ref('')

watch(
  () => route.params.slug,
  async (slug) => {
    if (!slug) return
    status.value = 'loading'
    try {
      project.value = await api(`/addons/${encodeURIComponent(slug)}`)
      document.title = `${project.value.title} | PurpleByte Studios`
      status.value = 'ok'
    } catch (e) {
      status.value = e.status === 404 ? 'missing' : 'error'
    }
  },
  { immediate: true }
)

const video = computed(() => youtubeId(project.value?.trailer_url))
const body = computed(() => paragraphs(project.value?.description))

function open(src) {
  viewing.value = src
  viewer.value?.showModal()
}
</script>

<template>
  <p v-if="status === 'loading'" class="wrap state">Carregando…</p>

  <section v-else-if="status === 'missing'" class="wrap state">
    <h1>Esse projeto não existe ou saiu do ar.</h1>
    <RouterLink to="/projetos" class="btn">Ver todos os projetos</RouterLink>
  </section>

  <section v-else-if="status === 'error'" class="wrap state">
    <h1>Não deu para carregar este projeto.</h1>
    <p>Confira sua conexão e recarregue a página.</p>
  </section>

  <article v-else class="project" :style="{ '--accent': project.accent_color }">
    <header class="project__top">
      <div class="wrap">
        <RouterLink to="/projetos" class="back">Todos os projetos</RouterLink>
        <div v-if="project.banner_image || project.cover_image" class="project__banner lift">
          <img class="chamfer" :src="project.banner_image || project.cover_image" :alt="`Arte do ${project.title}`" />
        </div>
      </div>
    </header>

    <div class="wrap project__main">
      <div class="project__intro">
        <h1 class="project__title">{{ project.title }}</h1>
        <p v-if="project.tagline" class="project__tagline">{{ project.tagline }}</p>
      </div>

      <aside class="project__side">
        <dl class="facts">
          <div v-if="project.category">
            <dt>Tipo</dt>
            <dd>{{ project.category.name }}</dd>
          </div>
          <div v-if="project.release_date">
            <dt>Lançamento</dt>
            <dd>{{ formatDate(project.release_date) }}</dd>
          </div>
        </dl>
        <a v-if="project.marketplace_url" :href="project.marketplace_url" target="_blank" rel="noopener" class="btn">
          Ver no Marketplace
        </a>
      </aside>

      <div class="project__body">
        <p v-for="(p, i) in body" :key="i">{{ p }}</p>
      </div>
    </div>

    <section v-if="video" class="wrap block" aria-label="Trailer">
      <div class="video lift">
        <iframe
          class="chamfer"
          :src="`https://www.youtube-nocookie.com/embed/${video}`"
          :title="`Trailer do ${project.title}`"
          loading="lazy"
          allow="accelerometer; encrypted-media; gyroscope; picture-in-picture"
          allowfullscreen
        ></iframe>
      </div>
    </section>

    <section v-if="project.gallery.length" class="wrap block" aria-labelledby="galeria">
      <h2 id="galeria" class="block__title">Imagens</h2>
      <ul class="gallery">
        <li v-for="(src, i) in project.gallery" :key="src">
          <button type="button" class="gallery__item" @click="open(src)">
            <img :src="src" :alt="`Imagem ${i + 1} do ${project.title}`" loading="lazy" />
            <span class="visually-hidden">Ampliar imagem {{ i + 1 }}</span>
          </button>
        </li>
      </ul>
    </section>

    <dialog ref="viewer" class="viewer" @click.self="viewer.close()">
      <img :src="viewing" :alt="`Imagem ampliada do ${project.title}`" />
      <button type="button" class="btn btn--small viewer__close" @click="viewer.close()">Fechar</button>
    </dialog>
  </article>
</template>

<style scoped>
.state {
  display: grid;
  justify-items: start;
  gap: 20px;
  padding-block: 80px;
  font-size: var(--step-1);
}

.state h1 {
  font-size: var(--step-3);
}

.project__top {
  /* faixa na cor do projeto que termina no meio do banner */
  background: linear-gradient(var(--accent) 0 62%, transparent 62%);
  padding-top: 24px;
}

.back {
  display: inline-block;
  margin-bottom: 20px;
  padding: 8px 12px;
  font-weight: 700;
  text-decoration: none;
  color: var(--ink);
  background: var(--white);
  border-radius: 6px;
}

.project__banner {
  --lift: 10px;
  --lift-color: var(--ink);
}

.project__banner img {
  width: 100%;
  max-height: 520px;
  object-fit: cover;
  background: var(--ink);
}

.project__main {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 300px;
  gap: 24px 64px;
  padding-top: clamp(40px, 5vw, 64px);
}

.project__title {
  font-size: var(--step-4);
  font-stretch: 75%;
}

.project__tagline {
  margin-top: 12px;
  font-size: var(--step-1);
  color: var(--muted);
  max-width: 44ch;
}

.project__side {
  grid-row: span 2;
  display: grid;
  align-content: start;
  gap: 24px;
}

.facts {
  display: grid;
  gap: 14px;
  margin: 0;
  padding: 20px;
  background: var(--white);
  border-left: 6px solid var(--accent);
}

.facts dt {
  font-size: var(--step--1);
  color: var(--muted);
}

.facts dd {
  margin: 0;
  font-weight: 700;
}

.facts:not(:has(div)) {
  display: none;
}

.project__body {
  display: grid;
  gap: 1em;
  max-width: 68ch;
  font-size: 1.125rem;
}

.block {
  padding-top: clamp(48px, 6vw, 80px);
}

.project {
  padding-bottom: clamp(64px, 8vw, 112px);
}

.block__title {
  font-size: var(--step-3);
  margin-bottom: 24px;
}

.video {
  --lift: 10px;
  --lift-color: var(--accent);
}

.video iframe {
  display: block;
  width: 100%;
  aspect-ratio: 16 / 9;
  border: 0;
  background: var(--ink);
}

.gallery {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(min(100%, 260px), 1fr));
  gap: 16px;
}

.gallery__item {
  display: block;
  width: 100%;
  padding: 0;
  border: 0;
  background: var(--ink);
  cursor: zoom-in;
  border-radius: 6px;
  overflow: hidden;
}

.gallery__item img {
  width: 100%;
  aspect-ratio: 16 / 9;
  object-fit: cover;
}

.viewer {
  max-width: min(1200px, 94vw);
  padding: 0;
  border: 0;
  background: transparent;
}

.viewer::backdrop {
  background: rgb(36 16 74 / 0.88);
}

.viewer img {
  max-height: 84vh;
  margin: 0 auto;
}

.viewer__close {
  margin: 16px auto 0;
  display: flex;
}

@media (max-width: 820px) {
  .project__main {
    grid-template-columns: 1fr;
  }

  .project__side {
    grid-row: auto;
  }
}
</style>
