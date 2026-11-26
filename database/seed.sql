-- Conteúdo inicial. Tudo aqui é editável pelo painel (/admin).
SET NAMES utf8mb4;

INSERT IGNORE INTO categories (slug, name, sort_order) VALUES
  ('addon',   'Add-On',  1),
  ('mapa',    'Map',     2),
  ('textura', 'Texture Pack', 3),
  ('skin',    'Skin Pack', 4);

-- Frases curtas (em inglês) são rascunhos: revise no painel.
SET @addon = (SELECT id FROM categories WHERE slug = 'addon');

INSERT IGNORE INTO addons
  (slug, title, tagline, description, category_id, cover_image, banner_image, gallery,
   accent_color, featured, published, sort_order)
VALUES
  ('fabricate', 'Fabricate', 'Gears, machines and plenty of creativity.', '', @addon, '/media/fabricate-cover.webp', '/media/fabricate-banner.webp', JSON_ARRAY(), '#F5B82E', 1, 1, 1),
  ('create', 'Create: Bedrock Edition', 'Gears, conveyors and machines to automate everything.', '', @addon, '/media/addons/create.webp', '/media/addons/create.webp', JSON_ARRAY(), '#E8B43A', 0, 1, 2),
  ('basic-machinery', 'Basic Machinery', 'Machines to process ores and generate power.', '', @addon, '/media/addons/basic-machinery.webp', '/media/addons/basic-machinery.webp', JSON_ARRAY(), '#2FA3E0', 0, 1, 3),
  ('dark-utilities', 'Dark Utilities', 'Magic pads that push, trap and speed you up.', '', @addon, '/media/addons/dark-utilities.webp', '/media/addons/dark-utilities.webp', JSON_ARRAY(), '#8E4FD6', 0, 1, 4),
  ('autosmelt', 'Autosmelt', 'Pickaxes that drop ores already smelted.', '', @addon, '/media/addons/autosmelt.webp', '/media/addons/autosmelt.webp', JSON_ARRAY(), '#F59A1B', 0, 1, 5),
  ('projecte', 'ProjectE', 'Transmute items using EMC energy.', '', @addon, '/media/addons/projecte.webp', '/media/addons/projecte.webp', JSON_ARRAY(), '#D0333B', 0, 1, 6),
  ('tree-ores', 'Tree Ores', 'Trees that grow ores.', '', @addon, '/media/addons/tree-ores.webp', '/media/addons/tree-ores.webp', JSON_ARRAY(), '#7BC43A', 0, 1, 7),
  ('mob-heads', 'Mob Heads', 'Mob heads to collect and decorate with.', '', @addon, '/media/addons/mob-heads.webp', '/media/addons/mob-heads.webp', JSON_ARRAY(), '#E0A12E', 0, 1, 8),
  ('endercraft', 'EnderCraft', 'An add-on pack with new machines and blocks.', '', @addon, '/media/addons/endercraft.webp', '/media/addons/endercraft.webp', JSON_ARRAY(), '#2BB3A8', 0, 1, 9),
  ('waystones', 'Waystones', 'Teleport stones to travel across your world.', '', @addon, '/media/addons/waystones.webp', '/media/addons/waystones.webp', JSON_ARRAY(), '#A3A9B0', 0, 1, 10),
  ('simple-storage-network', 'Simple Storage Network', 'All your chests in a single network.', '', @addon, '/media/addons/simple-storage-network.webp', '/media/addons/simple-storage-network.webp', JSON_ARRAY(), '#C08420', 0, 1, 11),
  ('wireless-storage', 'Wireless Storage', 'Access your chests from anywhere.', '', @addon, '/media/addons/wireless-storage.webp', '/media/addons/wireless-storage.webp', JSON_ARRAY(), '#D9A55B', 0, 1, 12),
  ('travelers-backpack', 'Travelers Backpack', 'Backpacks with storage, tanks and style.', '', @addon, '/media/addons/travelers-backpack.webp', '/media/addons/travelers-backpack.webp', JSON_ARRAY(), '#D23A3A', 0, 1, 13),
  ('botania', 'Botania', 'Magic and technology powered by flowers.', '', @addon, '/media/addons/botania.webp', '/media/addons/botania.webp', JSON_ARRAY(), '#3FAE4A', 0, 1, 14),
  ('diagonal-fences', 'Diagonal Fences', 'Fences that connect diagonally.', '', @addon, '/media/addons/diagonal-fences.webp', '/media/addons/diagonal-fences.webp', JSON_ARRAY(), '#C9A15B', 0, 1, 15),
  ('items-transporter', 'Items Transporter', 'Pipes that move items from chest to chest.', '', @addon, '/media/addons/items-transporter.webp', '/media/addons/items-transporter.webp', JSON_ARRAY(), '#C9B98A', 0, 1, 16);

-- trailer do Fabricate no YouTube
UPDATE addons SET trailer_url = 'https://www.youtube.com/watch?v=prfqg2kU4uA'
 WHERE slug = 'fabricate' AND trailer_url = '';

INSERT IGNORE INTO settings (`key`, `value`) VALUES
  ('hero_title',    'We build worlds for Minecraft.'),
  ('hero_subtitle', 'PurpleByte Studios makes add-ons for the Minecraft Marketplace, from machines and automation to magic and exploration.'),
  ('about_text',    'PurpleByte Studios is a team of builders, artists and developers making add-ons for Minecraft: Bedrock Edition.

We love tech and utility add-ons: machines, storage, automation and the small tools that make survival more fun. Every add-on is tested in our own worlds before it ships.'),
  ('stat_downloads', ''),
  ('stat_projects',  ''),
  ('stat_years',     ''),
  ('contact_email',  ''),
  ('social_twitter', 'https://x.com/PurpleByteMC'),
  ('social_youtube', 'https://www.youtube.com/@PurpleByteCreations'),
  ('social_discord', 'https://discord.gg/kXeNcRWmbe'),
  ('social_instagram', '');
