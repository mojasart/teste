-- PurpleByte Studios: estrutura do banco (MariaDB 10.6+ / MySQL 8+)
-- Rodar uma vez: mariadb -u root -p purplebyte < database/schema.sql

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS categories (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug       VARCHAR(60)  NOT NULL UNIQUE,
  name       VARCHAR(80)  NOT NULL,
  sort_order INT          NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS addons (
  id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  slug            VARCHAR(120) NOT NULL UNIQUE,
  title           VARCHAR(120) NOT NULL,
  tagline         VARCHAR(255) NOT NULL DEFAULT '',
  description     TEXT         NOT NULL,
  category_id     INT UNSIGNED NULL,
  cover_image     VARCHAR(255) NOT NULL DEFAULT '',  -- card 16:9
  banner_image    VARCHAR(255) NOT NULL DEFAULT '',  -- topo da página do addon
  gallery         JSON         NULL,                 -- ["url", ...]
  marketplace_url VARCHAR(500) NOT NULL DEFAULT '',
  trailer_url     VARCHAR(500) NOT NULL DEFAULT '',  -- link do YouTube
  accent_color    CHAR(7)      NOT NULL DEFAULT '#8D4BEB',
  release_date    DATE         NULL,
  featured        TINYINT(1)   NOT NULL DEFAULT 0,
  published       TINYINT(1)   NOT NULL DEFAULT 0,
  sort_order      INT          NOT NULL DEFAULT 0,
  created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_addons_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
  INDEX idx_addons_pub (published, featured, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS users (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email         VARCHAR(190) NOT NULL UNIQUE,
  name          VARCHAR(120) NOT NULL DEFAULT '',
  password_hash VARCHAR(255) NOT NULL,
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS contact_messages (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(120) NOT NULL,
  email      VARCHAR(190) NOT NULL,
  subject    VARCHAR(190) NOT NULL DEFAULT '',
  message    TEXT         NOT NULL,
  ip         VARCHAR(45)  NOT NULL DEFAULT '',
  read_at    DATETIME     NULL,
  created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_msg_ip (ip, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS login_attempts (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  ip           VARCHAR(45) NOT NULL,
  attempted_at DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_login_ip (ip, attempted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- textos e números editáveis do site (chave → valor)
CREATE TABLE IF NOT EXISTS settings (
  `key`   VARCHAR(80) PRIMARY KEY,
  `value` TEXT        NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
