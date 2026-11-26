<script setup>
import { reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { admin, api } from '../../api.js'
import BrandMark from '../../components/BrandMark.vue'

const form = reactive({ email: '', password: '' })
const error = ref('')
const busy = ref(false)
const router = useRouter()
const route = useRoute()

async function submit() {
  busy.value = true
  error.value = ''
  try {
    admin.user = await api('/admin/login', { method: 'POST', body: form })
    const back = String(route.query.voltar || '/admin')
    router.replace(back.startsWith('/admin') ? back : '/admin')
  } catch (e) {
    error.value = e.message
  } finally {
    busy.value = false
  }
}
</script>

<template>
  <section class="login">
    <form class="login__box" @submit.prevent="submit">
      <div class="login__mark"><BrandMark gap="var(--white)" ink="var(--byte)" shade="var(--line)" /></div>
      <h1>Painel PurpleByte</h1>
      <p v-if="error" class="notice notice--error" role="alert">{{ error }}</p>
      <label class="field">
        <span>E-mail</span>
        <input v-model="form.email" class="input" type="email" autocomplete="username" required />
      </label>
      <label class="field">
        <span>Senha</span>
        <input v-model="form.password" class="input" type="password" autocomplete="current-password" required />
      </label>
      <button class="btn btn--purple" type="submit" :disabled="busy">{{ busy ? 'Entrando…' : 'Entrar' }}</button>
      <RouterLink to="/" class="login__back">Voltar ao site</RouterLink>
    </form>
  </section>
</template>

<style scoped>
.login {
  min-height: 100vh;
  display: grid;
  place-items: center;
  padding: 24px 16px;
  background: var(--byte);
}

.login__box {
  display: grid;
  gap: 18px;
  width: min(400px, 100%);
  padding: 32px;
  background: var(--white);
  border-radius: 8px;
  box-shadow: 8px 8px 0 var(--byte-deep);
}

.login__mark {
  width: 56px;
}

.login h1 {
  font-size: var(--step-2);
}

.login__back {
  justify-self: center;
  color: var(--muted);
  font-size: var(--step--1);
}
</style>
