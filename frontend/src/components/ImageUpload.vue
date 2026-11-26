<script setup>
import { ref } from 'vue'
import { api } from '../api.js'

// Escolhe imagens e envia para /api/admin/upload; emite a URL de cada uma.
const props = defineProps({
  label: { type: String, default: 'Enviar imagem' },
  multiple: { type: Boolean, default: false },
})
const emit = defineEmits(['uploaded'])
const busy = ref(false)
const error = ref('')
const input = ref(null)

async function onPick(e) {
  const files = [...e.target.files]
  e.target.value = ''
  if (!files.length) return
  busy.value = true
  error.value = ''
  for (const file of files) {
    const form = new FormData()
    form.append('file', file)
    try {
      const { url } = await api('/admin/upload', { method: 'POST', form })
      emit('uploaded', url)
    } catch (err) {
      error.value = `${file.name}: ${err.message}`
      break
    }
  }
  busy.value = false
}
</script>

<template>
  <div class="upload">
    <button type="button" class="btn btn--small btn--ghost" :disabled="busy" @click="input.click()">
      {{ busy ? 'Enviando…' : props.label }}
    </button>
    <input
      ref="input"
      type="file"
      accept="image/png,image/jpeg,image/webp,image/gif"
      :multiple="props.multiple"
      hidden
      @change="onPick"
    />
    <small v-if="error" class="error" role="alert">{{ error }}</small>
  </div>
</template>

<style scoped>
.upload {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
}

.error {
  color: var(--danger);
  font-weight: 600;
}
</style>
