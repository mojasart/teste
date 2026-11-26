<script setup>
import { computed, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { api, formatDate, paragraphs, youtubeId } from '../api.js'
import ProjectTile from '../components/ProjectTile.vue'

const route = useRoute()
const project = ref(null)
const others = ref([])
const status = ref('loading') // loading | ok | missing | error
const viewer = ref(null)
const viewing = ref('')

watch(
  () => route.params.slug,
  async (slug) => {
    if (!slug) return
    status.value = 'loading'
    try {
      const [p, all] = await Promise.all([api(`/addons/${encodeURIComponent(slug)}`), api('/addons')])
      project.value = p
      // três outros projetos, começando pelos que vêm logo depois deste
      const i = all.findIndex((a) => a.slug === p.slug)
      others.value = [...all.slice(i + 1), ...all.slice(0, Math.max(i, 0))].slice(0, 3)
      document.title = `${p.title} | PurpleByte Studios`
      status.value = 'ok'
    } catch (e) {
      status.value = e.status === 404 ? 'missing' : 'error'
    }
  },
  { immediate: true }
)

const art = computed(() => project.value?.banner_image || project.value?.cover_image)
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
    <header class="hero">
      <img v-if="art" class="hero__bg" :src="art" alt="" aria-hidden="true" />
      <div class="wrap hero__grid">
        <div class="hero__text">
          <RouterLink to="/projetos" class="back">Todos os projetos</RouterLink>
          <h1 class="hero__title">{{ project.title }}</h1>
          <p v-if="project.tagline" class="hero__tag">{{ project.tagline }}</p>
          <dl class="facts">
            <div v-if="project.category">
              <dt>Tipo</dt>
              <dd>{{ project.category.name }}</dd>
            </div>
            <div v-if="project.release_date">
              <dt>Lançamento</dt>
              <dd>{{ formatDate(project.release_date) }}</dd>
            </div>
            <div>
              <dt>Plataforma</dt>
              <dd>Minecraft Bedrock</dd>
            </div>
          </dl>
          <div class="hero__actions">
            <a v-if="project.marketplace_url" :href="project.marketplace_url" target="_blank" rel="noopener" class="btn">
              Ver no Marketplace
            </a>
            <a v-if="video" href="#trailer" class="btn btn--ghost">Assistir ao trailer</a>
          </div>
        </div>
        <div v-if="art" class="hero__art">
          <img :src="art" :alt="`Arte do ${project.title}`" />
        </div>
      </div>
    </header>

    <div v-if="body.length" class="wrap info">
      <p v-for="(p, i) in body" :key="i">{{ p }}</p>
    </div>

    <section v-if="video" id="trailer" class="wrap block" aria-label="Trailer">
      <iframe
        class="video"
        :src="`https://www.youtube-nocookie.com/embed/${video}`"
        :title="`Trailer do ${project.title}`"
        loading="lazy"
        allow="accelerometer; encrypted-media; gyroscope; picture-in-picture"
        allowfullscreen
      ></iframe>
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

    <section v-if="others.length" class="wrap block more" aria-labelledby="mais">
      <div class="more__head">
        <h2 id="mais" class="block__title">Mais projetos</h2>
        <RouterLink to="/projetos" class="more__all">Ver todos</RouterLink>
      </div>
      <div class="more__grid">
        <ProjectTile v-for="(p, i) in others" :key="p.id" v-reveal="i" :project="p" />
      </div>
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
  padding-block: 96px;
  font-size: var(--step-1);
  color: var(--mid);
}

.state h1 {
  font-size: var(--step-3);
  color: var(--hi);
}

/* ---------- topo: arte desfocada ao fundo ---------- */
.hero {
  position: relative;
  overflow: hidden;
  isolation: isolate;
  padding-block: clamp(40px, 6vw, 88px) clamp(40px, 5vw, 72px);
}

.hero__bg {
  position: absolute;
  inset: -40px;
  width: calc(100% + 80px);
  height: calc(100% + 80px);
  object-fit: cover;
  filter: blur(36px) saturate(1.3);
  opacity: 0.5;
  z-index: -2;
}

.hero::after {
  content: '';
  position: absolute;
  inset: 0;
  z-index: -1;
  background:
    linear-gradient(180deg, rgb(18 9 35 / 0.55), var(--night) 96%),
    radial-gradient(60% 80% at 75% 40%, transparent, rgb(18 9 35 / 0.6));
}

.hero__grid {
  display: grid;
  grid-template-columns: minmax(0, 0.9fr) minmax(0, 1.1fr);
  align-items: center;
  gap: clamp(32px, 5vw, 72px);
}

.hero__text {
  display: grid;
  justify-items: start;
  gap: 16px;
}

.back {
  margin-bottom: 12px;
  color: var(--mid);
  font-weight: 600;
  text-decoration: none;
}

.back:hover {
  color: var(--hi);
}

.hero__title {
  font-size: var(--step-4);
  font-stretch: 75%;
  line-height: 0.92;
  text-wrap: balance;
}

.hero__tag {
  font-size: var(--step-1);
  line-height: 1.4;
  color: #d9d0f2;
  max-width: 36ch;
}

.hero__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  margin-top: 12px;
}

.hero__actions:empty {
  display: none;
}

.hero__art img {
  width: 100%;
  aspect-ratio: 16 / 9;
  object-fit: cover;
  border-radius: 12px;
  box-shadow:
    0 0 0 2px var(--accent),
    0 40px 100px -30px var(--accent);
}

/* ---------- ficha e texto ---------- */
.facts {
  display: flex;
  flex-wrap: wrap;
  gap: 12px 32px;
  margin: 8px 0 0;
  padding-top: 18px;
  border-top: 1px solid rgb(255 255 255 / 0.12);
}

.facts dt {
  font-size: var(--step--1);
  color: var(--mid);
}

.facts dd {
  margin: 0;
  font-weight: 700;
}

.info {
  display: grid;
  gap: 1em;
  max-width: calc(66ch + 2 * var(--gutter));
  margin-inline: max(0px, calc((100% - var(--max)) / 2));
  font-size: 1.125rem;
  color: #ddd5f3;
}

/* ---------- blocos ---------- */
.block {
  padding-top: clamp(56px, 7vw, 96px);
}

.project {
  padding-bottom: clamp(72px, 9vw, 128px);
}

.block__title {
  font-size: var(--step-3);
  font-stretch: 80%;
  margin-bottom: 28px;
}

.video {
  display: block;
  width: 100%;
  aspect-ratio: 16 / 9;
  border: 0;
  border-radius: 12px;
  background: var(--night-2);
}

.gallery {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(min(100%, 280px), 1fr));
  gap: 16px;
}

.gallery__item {
  display: block;
  width: 100%;
  padding: 0;
  border: 0;
  border-radius: 8px;
  overflow: hidden;
  background: var(--night-2);
  cursor: zoom-in;
}

.gallery__item img {
  width: 100%;
  aspect-ratio: 16 / 9;
  object-fit: cover;
  transition: transform 400ms ease;
}

.gallery__item:hover img {
  transform: scale(1.04);
}

.more {
  margin-top: clamp(16px, 3vw, 32px);
}

.more__head {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
}

.more__all {
  color: var(--mid);
  font-weight: 700;
}

.more__grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 28px;
}

.viewer {
  max-width: min(1200px, 94vw);
  padding: 0;
  border: 0;
  background: transparent;
}

.viewer::backdrop {
  background: rgb(18 9 35 / 0.9);
}

.viewer img {
  max-height: 84vh;
  margin: 0 auto;
  border-radius: 8px;
}

.viewer__close {
  margin: 16px auto 0;
  display: flex;
}

@media (max-width: 900px) {
  .hero__grid {
    grid-template-columns: 1fr;
  }

  .hero__art {
    order: -1;
  }

  .more__grid {
    grid-template-columns: 1fr;
  }
}
</style>
