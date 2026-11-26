-- Conteúdo inicial. Tudo aqui é editável pelo painel (/admin).
SET NAMES utf8mb4;

INSERT IGNORE INTO categories (slug, name, sort_order) VALUES
  ('addon',   'Addon',   1),
  ('mapa',    'Mapa',    2),
  ('textura', 'Textura', 3),
  ('skin',    'Skin Pack', 4);

INSERT IGNORE INTO addons
  (slug, title, tagline, description, category_id, cover_image, banner_image, gallery,
   marketplace_url, trailer_url, accent_color, release_date, featured, published, sort_order)
VALUES
  ('fabricate', 'Fabricate',
   'Engrenagens, máquinas e muita criatividade.',
   'Texto de exemplo: troque pela descrição real do Fabricate no painel.\n\nConte o que o addon adiciona, os destaques e o que o jogador pode construir.',
   (SELECT id FROM categories WHERE slug = 'addon'),
   '/media/fabricate-cover.webp', '/media/fabricate-banner.webp', JSON_ARRAY(),
   '', '', '#F5B82E', NULL, 1, 1, 1);

INSERT IGNORE INTO settings (`key`, `value`) VALUES
  ('hero_title',    'Criamos mundos para Minecraft.'),
  ('hero_subtitle', 'A PurpleByte Studios faz addons, mapas e experiências para o Minecraft Marketplace.'),
  ('about_text',    'Somos a PurpleByte Studios, um estúdio brasileiro de conteúdo para Minecraft.\n\nTroque este texto no painel: conte a história do estúdio, quem faz parte e o que vocês gostam de criar.'),
  ('stat_downloads', ''),
  ('stat_projects',  ''),
  ('stat_years',     ''),
  ('contact_email',  ''),
  ('social_twitter', ''),
  ('social_youtube', ''),
  ('social_discord', ''),
  ('social_instagram', '');
