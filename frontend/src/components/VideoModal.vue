<script setup>
// Trailer em tela cheia: vídeo do próprio site (.mp4) ou YouTube.
import { computed, ref, watch } from 'vue'
import { youtubeId } from '../content.js'

const props = defineProps({
  src: { type: String, default: '' }, // vazio = fechado
  title: { type: String, default: 'Trailer' },
})
const emit = defineEmits(['close'])
const dlg = ref(null)
const yt = computed(() => youtubeId(props.src))

watch(
  () => props.src,
  (v) => {
    if (v && !dlg.value?.open) dlg.value?.showModal()
    if (!v && dlg.value?.open) dlg.value.close()
  }
)
</script>

<template>
  <dialog ref="dlg" class="vm" :aria-label="title" @close="emit('close')" @click.self="emit('close')">
    <div v-if="src" class="vm__frame">
      <iframe
        v-if="yt"
        :src="`https://www.youtube-nocookie.com/embed/${yt}?autoplay=1`"
        :title="title"
        allow="autoplay; encrypted-media; picture-in-picture; fullscreen"
        allowfullscreen
      ></iframe>
      <video v-else :src="src" controls autoplay playsinline preload="metadata"></video>
    </div>
    <button type="button" class="vm__close" @click="emit('close')">
      <span class="visually-hidden">Close trailer</span>
      <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 6l12 12M18 6L6 18" /></svg>
    </button>
  </dialog>
</template>

<style scoped>
.vm {
  width: 100vw;
  max-width: 100vw;
  height: 100dvh;
  max-height: 100dvh;
  margin: 0;
  padding: 0 16px;
  border: 0;
  background: transparent;
}

.vm::backdrop {
  background: rgb(12 8 18 / 0.94);
}

.vm[open] {
  display: grid;
  place-items: center;
}

.vm__frame {
  width: min(1200px, 100%);
  aspect-ratio: 16 / 9;
  border-radius: 8px;
  overflow: hidden;
  background: #000;
  box-shadow: 0 40px 120px -30px rgb(125 85 184 / 0.6);
  animation: pop 300ms cubic-bezier(0.2, 0.9, 0.2, 1);
}

@keyframes pop {
  from {
    opacity: 0;
    transform: scale(0.96);
  }
}

.vm__frame iframe,
.vm__frame video {
  width: 100%;
  height: 100%;
  border: 0;
}

.vm__close {
  position: fixed;
  top: calc(16px + env(safe-area-inset-top, 0px));
  right: 16px;
  display: grid;
  place-items: center;
  width: 48px;
  height: 48px;
  color: var(--hi);
  background: rgb(43 34 56 / 0.85);
  border: 1px solid var(--panel-hi);
  border-radius: 6px;
  cursor: pointer;
}

.vm__close svg {
  width: 22px;
  height: 22px;
  fill: none;
  stroke: currentColor;
  stroke-width: 2.4;
}
</style>
