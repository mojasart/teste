<template>
  <section class="nf wrap">
    <h1>This page does not exist.</h1>
    <p>The address may have changed. All our projects are here:</p>
    <RouterLink to="/projects" class="btn">See our projects</RouterLink>
  </section>
</template>

<style scoped>
.nf {
  display: grid;
  justify-items: start;
  gap: 18px;
  padding-block: 96px;
  color: var(--mid);
}

.nf h1 {
  font-size: var(--step-4);
  font-stretch: 75%;
  color: var(--byte);
}
</style>
