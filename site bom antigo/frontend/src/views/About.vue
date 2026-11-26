<script setup>
import { computed } from 'vue'
import { paragraphs, site } from '../api.js'
import BrandMark from '../components/BrandMark.vue'

const body = computed(() => paragraphs(site.settings?.about_text))
</script>

<template>
  <section class="about wrap">
    <div class="about__mark" aria-hidden="true">
      <BrandMark gap="var(--night)" ink="var(--byte)" shade="var(--night-3)" />
    </div>
    <div>
      <h1 class="about__title">About the studio</h1>
      <div class="about__body">
        <p v-for="(p, i) in body" :key="i">{{ p }}</p>
      </div>
      <RouterLink to="/contact" class="btn btn--purple">Work with us</RouterLink>
    </div>
  </section>
</template>

<style scoped>
.about {
  display: grid;
  grid-template-columns: 220px minmax(0, 1fr);
  gap: clamp(24px, 6vw, 80px);
  padding-block: clamp(40px, 7vw, 96px);
  align-items: start;
}

.about__title {
  font-size: var(--step-4);
  font-stretch: 75%;
  color: var(--byte);
  text-shadow: 0.05em 0.06em 0 var(--night-3);
}

.about__body {
  display: grid;
  gap: 1em;
  max-width: 64ch;
  margin: 28px 0 36px;
  font-size: 1.15rem;
  color: #ddd5f3;
}

@media (max-width: 720px) {
  .about {
    grid-template-columns: 1fr;
  }

  .about__mark {
    width: 120px;
  }
}
</style>
