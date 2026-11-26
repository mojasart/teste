<script setup>
import { reactive, ref } from 'vue'
import { api, site } from '../api.js'

const form = reactive({ name: '', email: '', subject: '', message: '', website: '' })
const errors = ref({})
const status = ref('idle') // idle | sending | sent
const error = ref('')

async function submit() {
  status.value = 'sending'
  errors.value = {}
  error.value = ''
  try {
    await api('/contact', { method: 'POST', body: form })
    status.value = 'sent'
  } catch (e) {
    errors.value = e.fields || {}
    error.value = e.message
    status.value = 'idle'
  }
}
</script>

<template>
  <section class="contact wrap">
    <div class="contact__intro">
      <h1 class="contact__title">Contato</h1>
      <p>Parcerias, projetos sob encomenda, imprensa ou dúvidas sobre algum addon: mande uma mensagem e respondemos por e-mail.</p>
      <p v-if="site.settings?.contact_email">
        Prefere e-mail direto? <a :href="`mailto:${site.settings.contact_email}`">{{ site.settings.contact_email }}</a>
      </p>
    </div>

    <div v-if="status === 'sent'" class="sent lift">
      <div class="sent__inner chamfer">
        <h2>Mensagem enviada.</h2>
        <p>Respondemos no e-mail {{ form.email }}.</p>
      </div>
    </div>

    <form v-else class="form" novalidate @submit.prevent="submit">
      <p v-if="error" class="notice notice--error" role="alert">{{ error }}</p>

      <label class="field">
        <span>Nome</span>
        <input v-model="form.name" class="input" autocomplete="name" required :aria-invalid="!!errors.name" />
        <small v-if="errors.name" class="error">{{ errors.name }}</small>
      </label>

      <label class="field">
        <span>E-mail</span>
        <input v-model="form.email" class="input" type="email" autocomplete="email" required :aria-invalid="!!errors.email" />
        <small v-if="errors.email" class="error">{{ errors.email }}</small>
      </label>

      <label class="field">
        <span>Assunto <small>(opcional)</small></span>
        <input v-model="form.subject" class="input" :aria-invalid="!!errors.subject" />
        <small v-if="errors.subject" class="error">{{ errors.subject }}</small>
      </label>

      <label class="field">
        <span>Mensagem</span>
        <textarea v-model="form.message" class="input" rows="6" required :aria-invalid="!!errors.message"></textarea>
        <small v-if="errors.message" class="error">{{ errors.message }}</small>
      </label>

      <!-- armadilha para robôs: pessoas não veem este campo -->
      <label class="visually-hidden" aria-hidden="true">
        Site <input v-model="form.website" tabindex="-1" autocomplete="off" />
      </label>

      <button class="btn btn--purple" type="submit" :disabled="status === 'sending'">
        {{ status === 'sending' ? 'Enviando…' : 'Enviar mensagem' }}
      </button>
    </form>
  </section>
</template>

<style scoped>
.contact {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(0, 1.2fr);
  gap: clamp(32px, 6vw, 96px);
  padding-block: clamp(40px, 7vw, 96px);
  align-items: start;
}

.contact__intro {
  display: grid;
  gap: 16px;
  max-width: 44ch;
  font-size: 1.125rem;
}

.contact__intro a {
  font-weight: 700;
  color: var(--byte-deep);
}

.contact__title {
  font-size: var(--step-4);
  font-stretch: 75%;
  color: var(--byte);
  text-shadow: 0.05em 0.06em 0 var(--line);
  margin-bottom: 8px;
}

.form {
  display: grid;
  gap: 20px;
  justify-items: stretch;
}

.form .btn {
  justify-self: start;
}

.sent__inner {
  display: grid;
  gap: 8px;
  padding: 36px;
  background: var(--white);
}

.sent h2 {
  font-size: var(--step-2);
}

@media (max-width: 760px) {
  .contact {
    grid-template-columns: 1fr;
  }
}
</style>
