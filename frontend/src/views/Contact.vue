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
  <section class="wrap contact">
    <div class="contact__intro">
      <h1 class="contact__title display">Contact</h1>
      <p>Partnerships, custom add-ons, press or questions about one of our add-ons: send us a message and we will reply by email.</p>
      <p v-if="site.settings?.social_discord">
        Need help fast?
        <a :href="site.settings.social_discord" target="_blank" rel="noopener">Join our Discord</a>.
      </p>
      <p v-if="site.settings?.contact_email">
        Prefer email? <strong>{{ site.settings.contact_email }}</strong>
      </p>
    </div>

    <div v-if="status === 'sent'" class="sent">
      <h2 class="display">Message sent.</h2>
      <p>We will reply to {{ form.email }}.</p>
    </div>

    <form v-else class="form" novalidate @submit.prevent="submit">
      <p v-if="error" class="notice notice--error" role="alert">{{ error }}</p>
      <div class="form__row">
        <label class="field">
          <span>Name</span>
          <input v-model="form.name" class="input" autocomplete="name" required :aria-invalid="!!errors.name" />
          <small v-if="errors.name" class="error">{{ errors.name }}</small>
        </label>
        <label class="field">
          <span>Email</span>
          <input v-model="form.email" class="input" type="email" autocomplete="email" required :aria-invalid="!!errors.email" />
          <small v-if="errors.email" class="error">{{ errors.email }}</small>
        </label>
      </div>
      <label class="field">
        <span>Subject <small>(optional)</small></span>
        <input v-model="form.subject" class="input" :aria-invalid="!!errors.subject" />
        <small v-if="errors.subject" class="error">{{ errors.subject }}</small>
      </label>
      <label class="field">
        <span>Message</span>
        <textarea v-model="form.message" class="input" rows="7" required :aria-invalid="!!errors.message"></textarea>
        <small v-if="errors.message" class="error">{{ errors.message }}</small>
      </label>
      <label class="visually-hidden" aria-hidden="true">Website <input v-model="form.website" tabindex="-1" autocomplete="off" /></label>
      <button class="btn btn--accent" type="submit" :disabled="status === 'sending'">
        {{ status === 'sending' ? 'Sending…' : 'Send message' }}
      </button>
    </form>
  </section>
</template>

<style scoped>
.contact {
  display: grid;
  grid-template-columns: minmax(0, 0.9fr) minmax(0, 1.2fr);
  gap: clamp(32px, 6vw, 96px);
  align-items: start;
  padding-block: clamp(40px, 7vw, 96px) 0;
}

.contact__intro {
  display: grid;
  gap: 14px;
  color: var(--mid);
  font-size: 1.08rem;
}

.contact__intro a,
.contact__intro strong {
  color: var(--hi);
  font-weight: 600;
}

.contact__title {
  font-size: var(--step-4);
  line-height: 0.9;
  color: var(--hi);
  margin-bottom: 6px;
}

.form {
  display: grid;
  gap: 18px;
  padding: clamp(20px, 3vw, 32px);
  background: var(--bg-2);
  border: 1px solid var(--panel);
  border-radius: 6px;
}

.form__row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 18px;
}

.form .btn {
  justify-self: start;
}

.sent {
  display: grid;
  gap: 8px;
  padding: 32px;
  background: var(--bg-2);
  border: 1px solid var(--accent);
  border-radius: 6px;
}

.sent h2 {
  font-size: var(--step-3);
}

@media (max-width: 800px) {
  .contact,
  .form__row {
    grid-template-columns: 1fr;
  }
}
</style>
