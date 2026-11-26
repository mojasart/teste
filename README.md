# PurpleByte Studios: site

Site da PurpleByte Studios: addons premium e grátis para o Minecraft: Bedrock Edition.

É um **site estático** (Vue 3 + Vite): sem servidor, sem banco de dados e sem painel.
Fica no ar de graça no GitHub Pages e é publicado sozinho a cada mudança na `main`.

```
imagens/                 ← todas as imagens e o trailer (o site usa direto daqui, em /media/...)
frontend/
  src/content/addons.json  ← os addons (premium e grátis): textos, imagens, links, galeria
  src/content/site.json    ← nome, endereço do site, redes sociais, e-mail, link "Show more add-ons"
  src/                     ← código das páginas
site bom antigo/         ← a primeira versão do site, guardada para referência
```

## Mudar o conteúdo

Tudo fica em `frontend/src/content/`. Dá para editar pelo próprio GitHub (inclusive pelo celular):
abra o arquivo, toque no lápis, mude e salve com "Commit changes". Em 1 ou 2 minutos o site atualiza.

- **Addon premium** (`premium` em `addons.json`): `title`, `tagline` (frase curta), `description`
  (parágrafos separados por linha em branco), `keyart` (arte 16:9), `hero` (imagem do topo da home),
  `gallery` (cada print com `src`, `thumb` e `alt`), `trailer` (vídeo em `media/...` ou link do YouTube),
  `marketplace` (link do Marketplace; vazio = sem botão), `badge` (ex.: `"Coming soon"`; vazio = sem selo),
  `featured: true` para ser o destaque do topo da home, `accent` (cor do brilho).
- **Addon grátis** (`free`): `title`, `icon` e `link` (página de download; vazio = cartão sem link).
- **Imagens novas:** coloque em `imagens/` e use o caminho `media/nome-do-arquivo.webp` no JSON.

## Rodar no computador

Precisa do Node 20+.

```bash
cd frontend
npm install
npm run dev
```

Abra http://localhost:5173.

## Publicação

O workflow `.github/workflows/pages.yml` faz o build e envia para a branch `gh-pages` a cada push na `main`.
No GitHub: **Settings → Pages → Build and deployment → Deploy from a branch → `gh-pages` / `(root)`**.

### Domínio próprio

1. Crie o arquivo `frontend/public/CNAME` contendo só o domínio (ex.: `purplebyte.com`) e mande para a `main`.
2. No GitHub: **Settings → Pages → Custom domain**, digite o mesmo domínio e salve.
3. No painel onde o domínio foi registrado, crie:
   - 4 registros **A** para `@`: `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`
   - 1 **CNAME** para `www` → `mojasart.github.io`
4. Depois que o DNS propagar, marque **Enforce HTTPS** na mesma tela.

Com o `CNAME` no lugar, o build passa a usar o domínio nos links de prévia (Discord, WhatsApp, X) e no `sitemap.xml`.
