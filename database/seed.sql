-- Conteúdo inicial. Tudo aqui é editável pelo painel (/admin).
SET NAMES utf8mb4;

INSERT IGNORE INTO categories (slug, name, sort_order) VALUES
  ('addon',   'Addon',   1),
  ('mapa',    'Mapa',    2),
  ('textura', 'Textura', 3),
  ('skin',    'Skin Pack', 4);

-- Frases curtas e descrições são rascunhos: revise no painel.
SET @addon = (SELECT id FROM categories WHERE slug = 'addon');

INSERT IGNORE INTO addons
  (slug, title, tagline, description, category_id, cover_image, banner_image, gallery,
   accent_color, featured, published, sort_order)
VALUES
  ('fabricate', 'Fabricate', 'Engrenagens, máquinas e muita criatividade.', '', @addon, '/media/fabricate-cover.webp', '/media/fabricate-banner.webp', JSON_ARRAY(), '#F5B82E', 1, 1, 1),
  ('create', 'Create: Bedrock Edition', 'Engrenagens, esteiras e máquinas para automatizar tudo.', '', @addon, '/media/addons/create.webp', '/media/addons/create.webp', JSON_ARRAY(), '#E8B43A', 0, 1, 2),
  ('basic-machinery', 'Basic Machinery', 'Máquinas para processar minérios e gerar energia.', '', @addon, '/media/addons/basic-machinery.webp', '/media/addons/basic-machinery.webp', JSON_ARRAY(), '#2FA3E0', 0, 1, 3),
  ('dark-utilities', 'Dark Utilities', 'Placas mágicas que empurram, prendem e aceleram.', '', @addon, '/media/addons/dark-utilities.webp', '/media/addons/dark-utilities.webp', JSON_ARRAY(), '#8E4FD6', 0, 1, 4),
  ('autosmelt', 'Autosmelt', 'Picaretas que já entregam o minério derretido.', '', @addon, '/media/addons/autosmelt.webp', '/media/addons/autosmelt.webp', JSON_ARRAY(), '#F59A1B', 0, 1, 5),
  ('projecte', 'ProjectE', 'Transmute itens usando energia EMC.', '', @addon, '/media/addons/projecte.webp', '/media/addons/projecte.webp', JSON_ARRAY(), '#D0333B', 0, 1, 6),
  ('tree-ores', 'Tree Ores', 'Árvores que dão minérios.', '', @addon, '/media/addons/tree-ores.webp', '/media/addons/tree-ores.webp', JSON_ARRAY(), '#7BC43A', 0, 1, 7),
  ('mob-heads', 'Mob Heads', 'Cabeças de mobs para colecionar e decorar.', '', @addon, '/media/addons/mob-heads.webp', '/media/addons/mob-heads.webp', JSON_ARRAY(), '#E0A12E', 0, 1, 8),
  ('endercraft', 'EnderCraft', 'Pacote de add-ons com máquinas e blocos novos.', '', @addon, '/media/addons/endercraft.webp', '/media/addons/endercraft.webp', JSON_ARRAY(), '#2BB3A8', 0, 1, 9),
  ('waystones', 'Waystones', 'Pedras de teleporte para viajar pelo mundo.', '', @addon, '/media/addons/waystones.webp', '/media/addons/waystones.webp', JSON_ARRAY(), '#A3A9B0', 0, 1, 10),
  ('simple-storage-network', 'Simple Storage Network', 'Todos os seus baús numa rede só.', '', @addon, '/media/addons/simple-storage-network.webp', '/media/addons/simple-storage-network.webp', JSON_ARRAY(), '#C08420', 0, 1, 11),
  ('wireless-storage', 'Wireless Storage', 'Acesse seus baús à distância.', '', @addon, '/media/addons/wireless-storage.webp', '/media/addons/wireless-storage.webp', JSON_ARRAY(), '#D9A55B', 0, 1, 12),
  ('travelers-backpack', 'Travelers Backpack', 'Mochilas com inventário, tanques e estilo.', '', @addon, '/media/addons/travelers-backpack.webp', '/media/addons/travelers-backpack.webp', JSON_ARRAY(), '#D23A3A', 0, 1, 13),
  ('botania', 'Botania', 'Magia e tecnologia movidas a flores.', '', @addon, '/media/addons/botania.webp', '/media/addons/botania.webp', JSON_ARRAY(), '#3FAE4A', 0, 1, 14),
  ('diagonal-fences', 'Diagonal Fences', 'Cercas que conectam na diagonal.', '', @addon, '/media/addons/diagonal-fences.webp', '/media/addons/diagonal-fences.webp', JSON_ARRAY(), '#C9A15B', 0, 1, 15),
  ('items-transporter', 'Items Transporter', 'Canos que levam itens de um baú a outro.', '', @addon, '/media/addons/items-transporter.webp', '/media/addons/items-transporter.webp', JSON_ARRAY(), '#C9B98A', 0, 1, 16);

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
