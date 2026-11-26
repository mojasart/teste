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

const demo = !!import.meta.env.VITE_DEMO
const art = computed(() => project.value?.banner_image || project.value?.cover_image)
const video = computed(() => youtubeId(project.value?.trailer_url))
const body = computed(() => paragraphs(project.value?.description))

function open(src) {
  viewing.value = src
  viewer.value?.showModal()
}
</script>

<template>
  <p v-if="status === 'loading'" class="wrap state">Loading…</p>

  <section v-else-if="status === 'missing'" class="wrap state">
    <h1>This project does not exist or is no longer available.</h1>
    <RouterLink to="/projects" class="btn">View all projects</RouterLink>
  </section>

  <section v-else-if="status === 'error'" class="wrap state">
    <h1>This project could not be loaded.</h1>
    <p>Check your connection and refresh the page.</p>
  </section>

  <article v-else class="project" :style="{ '--accent': project.accent_color }">
    <header class="stage">
      <img v-if="art" class="stage__glow" :src="art" alt="" aria-hidden="true" />
      <div class="wrap">
        <RouterLink to="/projects" class="back">All projects</RouterLink>
        <img v-if="art" class="stage__art" :src="art" :alt="`${project.title} key art`" />
      </div>
    </header>

    <div class="wrap detail">
      <div class="detail__main">
        <h1 class="detail__title">{{ project.title }}</h1>
        <p v-if="project.tagline" class="detail__tag">{{ project.tagline }}</p>
        <div v-if="body.length" class="detail__body">
          <p v-for="(p, i) in body" :key="i">{{ p }}</p>
        </div>
      </div>

      <aside class="panel" aria-label="Project details">
        <dl class="panel__facts">
          <div v-if="project.category">
            <dt>Type</dt>
            <dd>{{ project.category.name }}</dd>
          </div>
          <div>
            <dt>Platform</dt>
            <dd>Minecraft: Bedrock Edition</dd>
          </div>
          <div v-if="project.release_date">
            <dt>Released</dt>
            <dd>{{ formatDate(project.release_date) }}</dd>
          </div>
        </dl>
        <a v-if="project.marketplace_url" :href="project.marketplace_url" target="_blank" rel="noopener" class="btn panel__cta">
          Get it on the Marketplace
        </a>
        <a v-if="video" href="#trailer" class="btn btn--ghost panel__cta">Watch the trailer</a>
      </aside>
    </div>

    <section v-if="video" id="trailer" class="wrap block" aria-label="Trailer">
      <!-- na demonstração (sem servidor) o YouTube não pode ser embutido: vira um link -->
      <a v-if="demo" :href="project.trailer_url" target="_blank" rel="noopener" class="video video--link">
        <img v-if="art" :src="art" alt="" />
        <span class="video__play">Watch the trailer on YouTube</span>
      </a>
      <iframe
        v-else
        class="video"
        :src="`https://www.youtube-nocookie.com/embed/${video}`"
        :title="`${project.title} trailer`"
        loading="lazy"
        allow="accelerometer; encrypted-media; gyroscope; picture-in-picture"
        allowfullscreen
      ></iframe>
    </section>

    <section v-if="project.gallery.length" class="wrap block" aria-labelledby="gallery">
      <h2 id="gallery" class="block__title">Screenshots</h2>
      <ul class="gallery">
        <li v-for="(src, i) in project.gallery" :key="src">
          <button type="button" class="gallery__item" @click="open(src)">
            <img :src="src" :alt="`${project.title} screenshot ${i + 1}`" loading="lazy" />
            <span class="visually-hidden">Enlarge screenshot {{ i + 1 }}</span>
          </button>
        </li>
      </ul>
    </section>

    <section v-if="others.length" class="wrap block" aria-labelledby="more">
      <div class="more__head">
        <h2 id="more" class="block__title">More projects</h2>
        <RouterLink to="/projects" class="more__all">View all</RouterLink>
      </div>
      <div class="more__grid">
        <ProjectTile v-for="(p, i) in others" :key="p.id" v-reveal="i" :project="p" />
      </div>
    </section>

    <dialog ref="viewer" class="viewer" @click.self="viewer.close()">
      <img :src="viewing" :alt="`${project.title} screenshot, enlarged`" />
      <button type="button" class="btn btn--small viewer__close" @click="viewer.close()">Close</button>
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

/* ---------- arte inteira em destaque, com brilho da própria arte atrás ---------- */
.stage {
  position: relative;
  isolation: isolate;
  /* sobe por baixo do cabeçalho, que fica transparente aqui */
  margin-top: -77px;
  padding-top: calc(77px + clamp(24px, 3vw, 40px));
}

@media (max-width: 680px) {
  .stage {
    margin-top: -65px;
    padding-top: calc(65px + 20px);
  }
}

.stage__glow {
  position: absolute;
  inset: 0 0 auto;
  width: 100%;
  height: 95%;
  object-fit: cover;
  filter: blur(60px) saturate(1.4);
  opacity: 0.45;
  z-index: -1;
  mask-image: linear-gradient(180deg, #000 30%, transparent);
}

.back {
  display: inline-block;
  margin-bottom: 20px;
  color: var(--mid);
  font-weight: 600;
  text-decoration: none;
}

.back:hover {
  color: var(--hi);
}

.stage__art {
  width: 100%;
  height: auto;
  border-radius: 14px;
  box-shadow:
    0 0 0 1px rgb(255 255 255 / 0.08),
    0 50px 120px -50px var(--accent);
}

/* ---------- título, texto e painel ---------- */
.detail {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 340px;
  gap: 40px 72px;
  align-items: start;
  padding-top: clamp(36px, 5vw, 64px);
}

.detail__main {
  display: grid;
  gap: 16px;
}

.detail__title {
  font-size: var(--step-4);
  font-stretch: 75%;
  line-height: 0.92;
  text-wrap: balance;
}

.detail__tag {
  font-size: var(--step-1);
  line-height: 1.4;
  color: #d9d0f2;
  max-width: 44ch;
}

.detail__body {
  display: grid;
  gap: 1em;
  max-width: 66ch;
  margin-top: 16px;
  font-size: 1.125rem;
  color: #ddd5f3;
}

.panel {
  position: sticky;
  top: 24px;
  display: grid;
  gap: 14px;
  padding: 24px;
  background: var(--night-2);
  border: 1px solid var(--night-3);
  border-top: 4px solid var(--accent);
  border-radius: 12px;
}

.panel__facts {
  display: grid;
  gap: 16px;
  margin: 0 0 8px;
}

.panel__facts dt {
  font-size: var(--step--1);
  color: var(--mid);
}

.panel__facts dd {
  margin: 0;
  font-weight: 700;
}

.panel__cta {
  width: 100%;
}

/* ---------- blocos ---------- */
.project {
  padding-bottom: clamp(40px, 5vw, 64px);
}

.block {
  padding-top: clamp(64px, 8vw, 112px);
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

.video--link {
  position: relative;
  display: grid;
  place-items: center;
  overflow: hidden;
  text-decoration: none;
}

.video--link img {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  filter: brightness(0.45) blur(2px);
}

.video__play {
  position: relative;
  padding: 16px 24px 16px 56px;
  font-weight: 800;
  color: var(--white);
  background: #e0262b;
  border-radius: 10px;
}

.video__play::before {
  content: '';
  position: absolute;
  left: 22px;
  top: 50%;
  translate: 0 -50%;
  border-left: 16px solid var(--white);
  border-top: 10px solid transparent;
  border-bottom: 10px solid transparent;
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
  .detail {
    grid-template-columns: 1fr;
  }

  .panel {
    position: static;
  }

  .more__grid {
    grid-template-columns: 1fr;
    gap: 20px;
  }
}
</style>
