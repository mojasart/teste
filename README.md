# PurpleByte Studios: site

Site da PurpleByte Studios: addons premium e grátis para o Minecraft: Bedrock Edition.

- `imagens/`: todas as imagens e o trailer. O site lê direto daqui (endereços `/media/...`).
- `site bom antigo/`: a primeira versão do site, guardada para referência.

- **Frontend:** Vue 3 + Vite (`frontend/`)
- **Backend:** PHP 8.2+ puro, sem framework (`backend/`), API em `/api`
- **Banco:** MariaDB 10.6+ ou MySQL 8+ (`database/`)
- **Painel:** `/admin`, para cadastrar projetos, enviar imagens, ler mensagens do contato e editar textos e links

```
backend/
  public/        ← pasta pública (o que o navegador acessa)
    index.php    ← entrada única: /api → PHP, o resto → app Vue
    uploads/     ← imagens enviadas pelo painel
    dist/        ← frontend compilado (gerado pelo npm run build)
  src/           ← código da API
  bin/           ← scripts de terminal (criar tabelas, criar admin)
database/        ← schema.sql (tabelas) e seed.sql (conteúdo inicial)
frontend/        ← código do Vue
docker/          ← imagem PHP + Apache
```

## Rodar no seu computador com Docker (mais fácil)

Precisa do [Docker Desktop](https://www.docker.com/products/docker-desktop/).

```bash
docker compose up --build
```

- Site: http://localhost:8080
- phpMyAdmin: http://localhost:8081 (usuário `purplebyte`, senha `purplebyte`)

Crie o seu usuário do painel (a senha é pedida no terminal):

```bash
docker compose exec app php backend/bin/create-admin.php voce@email.com "Seu Nome"
```

Depois entre em http://localhost:8080/admin.

## Rodar sem Docker (para mexer no código)

Precisa de PHP 8.2+, Node 20+ e MariaDB/MySQL.

1. Crie o banco e um usuário no MariaDB, copie `backend/.env.example` para `backend/.env` e preencha.
2. Crie as tabelas e o admin:

   ```bash
   php backend/bin/migrate.php
   ```

   ```bash
   php backend/bin/create-admin.php voce@email.com "Seu Nome"
   ```

3. Suba a API (deixe rodando):

   ```bash
   php -S 127.0.0.1:8000 -t backend/public backend/public/index.php
   ```

4. Em outro terminal, suba o Vue com recarga automática:

   ```bash
   cd frontend && npm install && npm run dev
   ```

   Abra http://localhost:5173. As chamadas para `/api` vão para o PHP na porta 8000.

## Colocar no ar (hospedagem PHP comum: Hostinger, HostGator, Locaweb…)

1. No seu computador, compile o frontend:

   ```bash
   cd frontend && npm install && npm run build
   ```

   Isso cria `backend/public/dist/`.

2. No painel da hospedagem, crie um banco MySQL/MariaDB e anote o nome, o usuário e a senha.
3. Abra o phpMyAdmin da hospedagem, selecione o banco e importe `database/schema.sql` e depois `database/seed.sql`.
4. Pelo gerenciador de arquivos ou FTP, envie:
   - o **conteúdo** de `backend/public/` para `public_html/`
   - as pastas `backend/src/`, `backend/bin/` e `imagens/` para a pasta **acima** de `public_html` (assim o código da API não fica acessível pelo navegador; as imagens são entregues pelo `index.php`)
   - um arquivo `.env` (copie de `backend/.env.example`, com os dados do banco e `APP_ENV=production`), também na pasta acima de `public_html`

   No fim, fica assim:

   ```
   ~/.env
   ~/src/
   ~/bin/
   ~/imagens/
   ~/public_html/index.php, .htaccess, dist/, uploads/
   ```

5. Crie o usuário do painel. Se a hospedagem tiver terminal (SSH):

   ```bash
   php bin/create-admin.php voce@email.com "Seu Nome"
   ```

   Sem SSH: gere o hash da senha no seu computador com o comando abaixo e cole o resultado no phpMyAdmin, na tabela `users` (colunas `email`, `name` e `password_hash`).

   ```bash
   php -r 'echo password_hash("sua-senha-forte", PASSWORD_DEFAULT), "\n";'
   ```

6. Ative o HTTPS (SSL grátis) no painel da hospedagem e aponte o domínio.

## Editar o conteúdo

Tudo pelo painel `/admin`:

- **Projetos:** nome, frase curta, descrição, tipo, data, link do Marketplace, trailer do YouTube, capa (16:9), banner, galeria, cor do projeto, destaque e publicado/rascunho.
- **Mensagens:** o que chega pelo formulário de contato.
- **Textos e links:** e-mail, redes sociais (X, Discord, YouTube, Vatonage) e o link do botão "Show more add-ons".

- **Premium:** categoria "Premium". Capa = key art 16:9; imagem do topo = primeira imagem do slideshow da home; galeria com legenda; trailer pode ser YouTube ou um vídeo do site (`/media/fabricate-trailer.mp4`). O premium marcado como **destaque** aparece no topo da home.
- **Grátis:** categoria "Free". Capa = ícone quadrado; o link de download vai no campo do Marketplace.

As descrições dos premium são rascunhos em inglês: revise no painel.

## Segurança

- Login com senha em hash (bcrypt) e limite de tentativas por IP.
- Ações do painel exigem sessão e token CSRF.
- O formulário de contato tem limite por IP e uma armadilha para robôs.
- O envio de imagens só aceita PNG, JPG, WEBP e GIF de até 8 MB, com nome aleatório, numa pasta que não executa scripts.
- O `.env` nunca vai para o Git.
