<?php
declare(strict_types=1);

namespace App;

/** Leitura, validação e gravação de addons. */
final class Addons
{
    private const SELECT = 'SELECT a.*, c.slug AS category_slug, c.name AS category_name
                            FROM addons a LEFT JOIN categories c ON c.id = a.category_id';
    private const ORDER  = ' ORDER BY a.featured DESC, a.sort_order ASC, a.release_date DESC, a.id DESC';

    /** @return array<int, array<string, mixed>> */
    public static function list(bool $onlyPublished, ?string $category = null, bool $onlyFeatured = false): array
    {
        $where = [];
        $params = [];
        if ($onlyPublished) {
            $where[] = 'a.published = 1';
        }
        if ($category) {
            $where[] = 'c.slug = ?';
            $params[] = $category;
        }
        if ($onlyFeatured) {
            $where[] = 'a.featured = 1';
        }
        $sql = self::SELECT . ($where ? ' WHERE ' . implode(' AND ', $where) : '') . self::ORDER;
        return array_map([self::class, 'present'], Db::all($sql, $params));
    }

    public static function findBySlug(string $slug, bool $onlyPublished): array
    {
        $row = Db::one(self::SELECT . ' WHERE a.slug = ?' . ($onlyPublished ? ' AND a.published = 1' : ''), [$slug]);
        if (!$row) {
            throw new HttpError(404, 'Projeto não encontrado.');
        }
        return self::present($row);
    }

    public static function findById(int $id): array
    {
        $row = Db::one(self::SELECT . ' WHERE a.id = ?', [$id]);
        if (!$row) {
            throw new HttpError(404, 'Projeto não encontrado.');
        }
        return self::present($row);
    }

    public static function save(array $in, ?int $id = null): array
    {
        $data = self::validate($in, $id);
        $cols = array_keys($data);
        if ($id === null) {
            Db::exec(
                'INSERT INTO addons (' . implode(', ', $cols) . ') VALUES (' . implode(', ', array_fill(0, count($cols), '?')) . ')',
                array_values($data)
            );
            $id = (int) Db::pdo()->lastInsertId();
        } else {
            self::findById($id);
            Db::exec(
                'UPDATE addons SET ' . implode(', ', array_map(fn ($c) => "$c = ?", $cols)) . ' WHERE id = ?',
                [...array_values($data), $id]
            );
        }
        return self::findById($id);
    }

    public static function delete(int $id): void
    {
        if (Db::exec('DELETE FROM addons WHERE id = ?', [$id]) === 0) {
            throw new HttpError(404, 'Projeto não encontrado.');
        }
    }

    private static function present(array $r): array
    {
        return [
            'id'              => (int) $r['id'],
            'slug'            => $r['slug'],
            'title'           => $r['title'],
            'tagline'         => $r['tagline'],
            'description'     => $r['description'],
            'category'        => $r['category_slug'] ? ['slug' => $r['category_slug'], 'name' => $r['category_name']] : null,
            'category_id'     => $r['category_id'] !== null ? (int) $r['category_id'] : null,
            'cover_image'     => $r['cover_image'],
            'banner_image'    => $r['banner_image'],
            'gallery'         => json_decode($r['gallery'] ?? '[]', true) ?: [],
            'marketplace_url' => $r['marketplace_url'],
            'trailer_url'     => $r['trailer_url'],
            'accent_color'    => $r['accent_color'],
            'release_date'    => $r['release_date'],
            'featured'        => (bool) $r['featured'],
            'published'       => (bool) $r['published'],
            'sort_order'      => (int) $r['sort_order'],
            'updated_at'      => $r['updated_at'],
        ];
    }

    private static function validate(array $in, ?int $id): array
    {
        $err = [];
        $str = fn (string $k) => trim((string) ($in[$k] ?? ''));

        $title = $str('title');
        if ($title === '') {
            $err['title'] = 'Dê um nome ao projeto.';
        } elseif (mb_strlen($title) > 120) {
            $err['title'] = 'Use no máximo 120 caracteres.';
        }

        $slug = self::slugify($str('slug') !== '' ? $str('slug') : $title);
        if ($slug === '') {
            $err['slug'] = 'Use letras ou números no endereço.';
        } elseif (Db::one('SELECT id FROM addons WHERE slug = ? AND id <> ?', [$slug, $id ?? 0])) {
            $err['slug'] = 'Já existe um projeto com esse endereço.';
        }

        $tagline = $str('tagline');
        if (mb_strlen($tagline) > 255) {
            $err['tagline'] = 'Use no máximo 255 caracteres.';
        }

        $categoryId = $in['category_id'] ?? null;
        if ($categoryId !== null && $categoryId !== '') {
            $categoryId = (int) $categoryId;
            if (!Db::one('SELECT id FROM categories WHERE id = ?', [$categoryId])) {
                $err['category_id'] = 'Categoria inválida.';
            }
        } else {
            $categoryId = null;
        }

        foreach (['marketplace_url', 'trailer_url'] as $k) {
            $v = $str($k);
            if ($v !== '' && !preg_match('#^https?://#i', $v)) {
                $err[$k] = 'Cole um link completo, começando com https://';
            }
        }

        foreach (['cover_image', 'banner_image'] as $k) {
            if (!self::isImagePath($str($k))) {
                $err[$k] = 'Imagem inválida.';
            }
        }

        $gallery = $in['gallery'] ?? [];
        if (!is_array($gallery) || array_filter($gallery, fn ($g) => !is_string($g) || $g === '' || !self::isImagePath($g))) {
            $err['gallery'] = 'Galeria inválida.';
            $gallery = [];
        }

        $accent = $str('accent_color') ?: '#8D4BEB';
        if (!preg_match('/^#[0-9a-fA-F]{6}$/', $accent)) {
            $err['accent_color'] = 'Use uma cor no formato #RRGGBB.';
        }

        $release = $str('release_date');
        if ($release !== '' && !\DateTime::createFromFormat('!Y-m-d', $release)) {
            $err['release_date'] = 'Data inválida.';
        }

        if ($err) {
            throw new HttpError(422, 'Confira os campos destacados.', $err);
        }

        return [
            'slug'            => $slug,
            'title'           => $title,
            'tagline'         => $tagline,
            'description'     => $str('description'),
            'category_id'     => $categoryId,
            'cover_image'     => $str('cover_image'),
            'banner_image'    => $str('banner_image'),
            'gallery'         => json_encode(array_values($gallery), JSON_UNESCAPED_SLASHES),
            'marketplace_url' => $str('marketplace_url'),
            'trailer_url'     => $str('trailer_url'),
            'accent_color'    => strtoupper($accent),
            'release_date'    => $release ?: null,
            'featured'        => !empty($in['featured']) ? 1 : 0,
            'published'       => !empty($in['published']) ? 1 : 0,
            'sort_order'      => (int) ($in['sort_order'] ?? 0),
        ];
    }

    /** Só aceita imagens do próprio site (pastas media/ e uploads/). */
    private static function isImagePath(string $p): bool
    {
        return $p === '' || (bool) preg_match('#^/(media|uploads)/[A-Za-z0-9/_.-]+\.(png|jpe?g|webp|gif)$#', $p) && !str_contains($p, '..');
    }

    public static function slugify(string $s): string
    {
        $s = iconv('UTF-8', 'ASCII//TRANSLIT//IGNORE', $s) ?: $s;
        $s = strtolower(preg_replace('/[^A-Za-z0-9]+/', '-', $s));
        return substr(trim($s, '-'), 0, 120);
    }
}
