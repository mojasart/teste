-- Conteúdo inicial. Tudo aqui é editável pelo painel (/admin).
-- Textos dos addons são rascunhos em inglês: revise no painel.
SET NAMES utf8mb4;

INSERT IGNORE INTO categories (slug, name, sort_order) VALUES
  ('premium', 'Premium', 1),
  ('free',    'Free',    2);

SET @premium = (SELECT id FROM categories WHERE slug = 'premium');
SET @free    = (SELECT id FROM categories WHERE slug = 'free');

-- Premium: capa = key art 16:9, banner = imagem do topo; galeria com legenda e miniatura.
-- Free: capa = ícone quadrado; "marketplace_url" = link de download (Vatonage).
INSERT IGNORE INTO addons
  (slug, title, tagline, description, category_id, cover_image, banner_image, gallery,
   marketplace_url, trailer_url, accent_color, featured, published, sort_order)
VALUES
  ('fabricate', 'Fabricate', 'Machines, automation, and new ways to build.', 'Explore factories, conveyor systems, trains, and flying machines.

Build production lines that run on their own, craft new machines and take on the Smelter Colossus.', @premium, '/media/fabricate-keyart.webp', '/media/hero-fabricate.webp', '[{"src": "/media/fabricate-01.webp", "thumb": "/media/thumbs/fabricate-01.webp", "alt": "Automated conveyor belts inside a Fabricate factory"}, {"src": "/media/fabricate-02.webp", "thumb": "/media/thumbs/fabricate-02.webp", "alt": "Automated crop and livestock farm with conveyor belts"}, {"src": "/media/fabricate-03.webp", "thumb": "/media/thumbs/fabricate-03.webp", "alt": "Golden steam train at a Minecraft station"}, {"src": "/media/fabricate-04.webp", "thumb": "/media/thumbs/fabricate-04.webp", "alt": "Fabricate car and flying machine outside a workshop"}, {"src": "/media/fabricate-05.webp", "thumb": "/media/thumbs/fabricate-05.webp", "alt": "A player facing the Smelter Colossus boss"}, {"src": "/media/fabricate-06.webp", "thumb": "/media/thumbs/fabricate-06.webp", "alt": "Collection of Fabricate machines, blocks and tools"}, {"src": "/media/fabricate-07.webp", "thumb": "/media/thumbs/fabricate-07.webp", "alt": "Industrial smelters and processing machines in a factory"}, {"src": "/media/fabricate-08.webp", "thumb": "/media/thumbs/fabricate-08.webp", "alt": "Fabricate train, car and flying machines"}, {"src": "/media/fabricate-09.webp", "thumb": "/media/thumbs/fabricate-09.webp", "alt": "Gears and conveyor machinery inside a workshop"}, {"src": "/media/fabricate-10.webp", "thumb": "/media/thumbs/fabricate-10.webp", "alt": "Players exploring a Fabricate machinery workshop"}, {"src": "/media/fabricate-12.webp", "thumb": "/media/thumbs/fabricate-12.webp", "alt": "Fabricate machinery and enemies in the Nether"}, {"src": "/media/fabricate-13.webp", "thumb": "/media/thumbs/fabricate-13.webp", "alt": "A large factory with interconnected production lines"}]', '', '/media/fabricate-trailer.mp4', '#F5B82E', 1, 1, 1),
  ('all-the-stuff', 'All The Stuff', 'Tools, equipment, and technology for your next adventure.', 'Tools, equipment, and technology for your next Minecraft adventure. Explore the quest book, crafting recipes, and new gear.', @premium, '/media/all-the-stuff-keyart.webp', '/media/all-the-stuff-01.webp', '[{"src": "/media/all-the-stuff-01.webp", "thumb": "/media/thumbs/all-the-stuff-01.webp", "alt": "In-game inventory information and minimap in All The Stuff"}, {"src": "/media/all-the-stuff-02.webp", "thumb": "/media/thumbs/all-the-stuff-02.webp", "alt": "Item encyclopedia and crafting recipe interface"}, {"src": "/media/all-the-stuff-03.webp", "thumb": "/media/thumbs/all-the-stuff-03.webp", "alt": "Quest book showing a branching technology progression"}, {"src": "/media/all-the-stuff-04.webp", "thumb": "/media/thumbs/all-the-stuff-04.webp", "alt": "Fighting creatures with advanced equipment in a cave"}, {"src": "/media/all-the-stuff-05.webp", "thumb": "/media/thumbs/all-the-stuff-05.webp", "alt": "A player holding a powered sword inside a Minecraft house"}, {"src": "/media/all-the-stuff-06.webp", "thumb": "/media/thumbs/all-the-stuff-06.webp", "alt": "A player wearing red armor in a grassy landscape"}, {"src": "/media/all-the-stuff-07.webp", "thumb": "/media/thumbs/all-the-stuff-07.webp", "alt": "Nighttime combat with a futuristic weapon"}, {"src": "/media/all-the-stuff-08.webp", "thumb": "/media/thumbs/all-the-stuff-08.webp", "alt": "Fighting a zombie villager using an energy weapon"}, {"src": "/media/all-the-stuff-09.webp", "thumb": "/media/thumbs/all-the-stuff-09.webp", "alt": "Exploring a grassy Minecraft landscape at night"}]', '', '', '#B44BEB', 0, 1, 2),
  ('zombie-craft', 'Zombie Craft', 'Survive a world taken over by zombies.', 'Ruined cities, abandoned vehicles and hordes of zombies. Scavenge, gear up and survive.', @premium, '/media/zombie-craft-keyart.webp', '/media/zombie-craft-01.webp', '[{"src": "/media/zombie-craft-01.webp", "thumb": "/media/thumbs/zombie-craft-01.webp", "alt": "Zombies surrounding abandoned vehicles on a city street"}, {"src": "/media/zombie-craft-02.webp", "thumb": "/media/thumbs/zombie-craft-02.webp", "alt": "Abandoned city buildings and cars at night"}, {"src": "/media/zombie-craft-03.webp", "thumb": "/media/thumbs/zombie-craft-03.webp", "alt": "An overgrown tower at sunset"}, {"src": "/media/zombie-craft-04.webp", "thumb": "/media/thumbs/zombie-craft-04.webp", "alt": "An abandoned hospital among ruined city buildings"}, {"src": "/media/zombie-craft-05.webp", "thumb": "/media/thumbs/zombie-craft-05.webp", "alt": "A radar installation beside a snowy frozen lake"}, {"src": "/media/zombie-craft-06.webp", "thumb": "/media/thumbs/zombie-craft-06.webp", "alt": "A wooden watchtower above a forest at sunset"}, {"src": "/media/zombie-craft-07.webp", "thumb": "/media/thumbs/zombie-craft-07.webp", "alt": "Ruined city towers in the evening light"}]', '', '', '#E0562E', 0, 1, 3),
  ('bonsai-pots', 'Bonsai Pots', '', '', @free, '/media/addons/bonsai-pots.webp', '', '[]', '', '', '#8D4BEB', 0, 1, 1),
  ('dynamic-lights', 'Dynamic Lights', '', '', @free, '/media/addons/dynamic-lights-project.webp', '', '[]', 'https://vatonage.com/mods/dynamic-lights-add-on', '', '#8D4BEB', 0, 1, 2),
  ('more-tools', 'More Tools', '', '', @free, '/media/addons/more-tools-project.webp', '', '[]', '', '', '#8D4BEB', 0, 1, 3),
  ('waystones-project', 'Waystones Project', '', '', @free, '/media/addons/waystones-project.webp', '', '[]', 'https://vatonage.com/mods/waystone-add-on', '', '#8D4BEB', 0, 1, 4),
  ('advanced-furnaces', 'Advanced Furnaces', '', '', @free, '/media/addons/advanced-furnaces.webp', '', '[]', 'https://vatonage.com/mods/advanced-furnaces-add-on', '', '#8D4BEB', 0, 1, 5),
  ('real-gravestone', 'Real Gravestone', '', '', @free, '/media/addons/gravestone-pb.webp', '', '[]', '', '', '#8D4BEB', 0, 1, 6),
  ('animal-net', 'Animal Net', '', '', @free, '/media/addons/animal-net.webp', '', '[]', '', '', '#8D4BEB', 0, 1, 7),
  ('simple-storage', 'Simple Storage', '', '', @free, '/media/addons/simple-storage.webp', '', '[]', '', '', '#8D4BEB', 0, 1, 8),
  ('cardboard-box', 'Cardboard Box', '', '', @free, '/media/addons/cardboard-box-addon.webp', '', '[]', '', '', '#8D4BEB', 0, 1, 9),
  ('more-ores', 'More Ores', '', '', @free, '/media/addons/more-ores-add-on.webp', '', '[]', 'https://vatonage.com/mods/more-ores-add-on', '', '#8D4BEB', 0, 1, 10),
  ('backpacks', 'Backpacks', '', '', @free, '/media/addons/backpacks-add-on.webp', '', '[]', 'https://vatonage.com/mods/backpacks-add-on', '', '#8D4BEB', 0, 1, 11),
  ('elevators', 'Elevators', '', '', @free, '/media/addons/elevators-addon.webp', '', '[]', 'https://vatonage.com/mods/elevators-add-on', '', '#8D4BEB', 0, 1, 12),
  ('more-chests', 'More Chests', '', '', @free, '/media/addons/more-chests.webp', '', '[]', 'https://vatonage.com/mods/more-chests-add-on', '', '#8D4BEB', 0, 1, 13);

INSERT IGNORE INTO settings (`key`, `value`) VALUES
  ('contact_email',    ''),
  ('social_twitter',   'https://x.com/PurpleByteMC'),
  ('social_youtube',   'https://www.youtube.com/@PurpleByteCreations'),
  ('social_discord',   'https://discord.gg/kXeNcRWmbe'),
  ('social_instagram', ''),
  ('social_vatonage',  'https://vatonage.com/'),
  ('free_more_url',    'https://vatonage.com/creator/Raco56');
