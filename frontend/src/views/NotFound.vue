<template>
  <section class="nf wrap">
    <h1>Essa página não existe.</h1>
    <p>O endereço pode ter mudado. Os projetos estão todos aqui:</p>
    <RouterLink to="/projetos" class="btn">Ver projetos</RouterLink>
  </section>
</template>

<style scoped>
.nf {
  display: grid;
  justify-items: start;
  gap: 18px;
  padding-block: 96px;
}

.nf h1 {
  font-size: var(--step-4);
  font-stretch: 75%;
  color: var(--byte);
}
</style>
