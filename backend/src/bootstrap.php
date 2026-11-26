<?php
declare(strict_types=1);

// Carrega classes App\* de src/ (sem precisar de Composer)
spl_autoload_register(static function (string $class): void {
    if (str_starts_with($class, 'App\\')) {
        $file = __DIR__ . '/' . str_replace('\\', '/', substr($class, 4)) . '.php';
        if (is_file($file)) {
            require $file;
        }
    }
});

// Lê backend/.env (variáveis reais do servidor têm prioridade)
$envFile = dirname(__DIR__) . '/.env';
if (is_file($envFile)) {
    foreach (file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
        $line = trim($line);
        if ($line === '' || $line[0] === '#' || !str_contains($line, '=')) {
            continue;
        }
        [$k, $v] = array_map('trim', explode('=', $line, 2));
        $v = trim(preg_replace('/\s+#.*$/', '', $v), "\"'");
        if (getenv($k) === false) {
            putenv("$k=$v");
            $_ENV[$k] = $v;
        }
    }
}

function env(string $key, string $default = ''): string
{
    $v = getenv($key);
    return $v === false ? $default : $v;
}

define('APP_DEBUG', env('APP_ENV') === 'development');
define('PUBLIC_DIR', dirname(__DIR__) . '/public');

error_reporting(E_ALL);
ini_set('display_errors', APP_DEBUG ? '1' : '0');
