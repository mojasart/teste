<template>
  <section class="wrap nf">
    <h1 class="display">This page does not exist.</h1>
    <p>The address may have changed. All our add-ons are on the home page.</p>
    <RouterLink to="/" class="btn btn--light">See our add-ons</RouterLink>
  </section>
</template>

<style scoped>
.nf {
  display: grid;
  justify-items: start;
  gap: 16px;
  padding-block: 120px;
  color: var(--mid);
}

.nf h1 {
  font-size: var(--step-4);
  line-height: 0.95;
  color: var(--hi);
}
</style>
