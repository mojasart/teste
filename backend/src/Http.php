<?php
declare(strict_types=1);

namespace App;

final class Http
{
    public static function json(mixed $data, int $status = 200): never
    {
        http_response_code($status);
        header('Content-Type: application/json; charset=utf-8');
        header('Cache-Control: no-store');
        echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }

    /** Corpo JSON da requisição. */
    public static function body(): array
    {
        static $body = null;
        if ($body === null) {
            $raw = file_get_contents('php://input') ?: '';
            $body = $raw === '' ? [] : json_decode($raw, true);
            if (!is_array($body)) {
                throw new HttpError(400, 'JSON inválido.');
            }
        }
        return $body;
    }

    public static function ip(): string
    {
        return $_SERVER['REMOTE_ADDR'] ?? '';
    }
}
