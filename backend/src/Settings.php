<?php
declare(strict_types=1);

namespace App;

final class Settings
{
    /** Chaves que o painel pode editar. */
    public const KEYS = [
        'hero_title', 'hero_subtitle', 'about_text',
        'stat_downloads', 'stat_projects', 'stat_years',
        'contact_email', 'social_twitter', 'social_youtube', 'social_discord', 'social_instagram', 'social_vatonage',
        'free_more_url',
    ];

    public static function all(): array
    {
        $out = array_fill_keys(self::KEYS, '');
        foreach (Db::all('SELECT `key`, `value` FROM settings') as $r) {
            if (array_key_exists($r['key'], $out)) {
                $out[$r['key']] = $r['value'];
            }
        }
        return $out;
    }

    public static function update(array $in): array
    {
        $err = [];
        foreach ($in as $k => $v) {
            if (!in_array($k, self::KEYS, true)) {
                continue;
            }
            $v = trim((string) $v);
            if ((str_starts_with($k, 'social_') || str_ends_with($k, '_url')) && $v !== '' && !preg_match('#^https?://#i', $v)) {
                $err[$k] = 'Cole o link completo, começando com https://';
            }
            if ($k === 'contact_email' && $v !== '' && !filter_var($v, FILTER_VALIDATE_EMAIL)) {
                $err[$k] = 'E-mail inválido.';
            }
        }
        if ($err) {
            throw new HttpError(422, 'Confira os campos destacados.', $err);
        }
        foreach ($in as $k => $v) {
            if (in_array($k, self::KEYS, true)) {
                Db::exec('INSERT INTO settings (`key`, `value`) VALUES (?, ?) ON DUPLICATE KEY UPDATE `value` = VALUES(`value`)', [$k, trim((string) $v)]);
            }
        }
        return self::all();
    }
}
