<?php
declare(strict_types=1);

namespace App;

final class Auth
{
    private const MAX_ATTEMPTS = 8;      // por IP
    private const WINDOW_MIN   = 15;     // minutos

    public static function startSession(): void
    {
        if (session_status() === PHP_SESSION_ACTIVE) {
            return;
        }
        $https = ($_SERVER['HTTPS'] ?? '') === 'on' || ($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '') === 'https';
        session_name('pb_session');
        session_set_cookie_params([
            'lifetime' => 0,
            'path'     => '/',
            'secure'   => $https,
            'httponly' => true,
            'samesite' => 'Strict',
        ]);
        session_start();
    }

    /** @return array{id:int,email:string,name:string,csrf:string} */
    public static function login(string $email, string $password): array
    {
        $ip = Http::ip();
        $recent = Db::one(
            'SELECT COUNT(*) n FROM login_attempts WHERE ip = ? AND attempted_at > NOW() - INTERVAL ' . self::WINDOW_MIN . ' MINUTE',
            [$ip]
        );
        if ((int) $recent['n'] >= self::MAX_ATTEMPTS) {
            throw new HttpError(429, 'Muitas tentativas. Espere alguns minutos e tente de novo.');
        }

        $user = Db::one('SELECT id, email, name, password_hash FROM users WHERE email = ?', [mb_strtolower(trim($email))]);
        if (!$user || !password_verify($password, $user['password_hash'])) {
            Db::exec('INSERT INTO login_attempts (ip) VALUES (?)', [$ip]);
            throw new HttpError(401, 'E-mail ou senha incorretos.');
        }
        Db::exec('DELETE FROM login_attempts WHERE ip = ? OR attempted_at < NOW() - INTERVAL 1 DAY', [$ip]);

        self::startSession();
        session_regenerate_id(true);
        $_SESSION['uid']  = (int) $user['id'];
        $_SESSION['csrf'] = bin2hex(random_bytes(32));
        return self::me();
    }

    public static function logout(): void
    {
        self::startSession();
        $_SESSION = [];
        session_destroy();
    }

    /** @return array{id:int,email:string,name:string,csrf:string} */
    public static function me(): array
    {
        self::startSession();
        $uid = $_SESSION['uid'] ?? null;
        $user = $uid ? Db::one('SELECT id, email, name FROM users WHERE id = ?', [$uid]) : null;
        if (!$user) {
            throw new HttpError(401, 'Faça login para continuar.');
        }
        return ['id' => (int) $user['id'], 'email' => $user['email'], 'name' => $user['name'], 'csrf' => $_SESSION['csrf']];
    }

    /** Exige login; em requisições que alteram dados, exige também o token CSRF. */
    public static function require(string $method): void
    {
        $me = self::me();
        if ($method !== 'GET') {
            $token = $_SERVER['HTTP_X_CSRF_TOKEN'] ?? '';
            if (!hash_equals($me['csrf'], $token)) {
                throw new HttpError(403, 'Sessão expirada. Recarregue a página.');
            }
        }
    }
}
