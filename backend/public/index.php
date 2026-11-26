<?php
declare(strict_types=1);

/*
 * Ponto de entrada único.
 *  /api/...      → API em PHP
 *  qualquer outra → app Vue (dist/index.html), que cuida das rotas no navegador
 */

use App\{Addons, Auth, Contact, Db, Http, HttpError, Router, Settings, Uploads};

$path = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';

// servidor embutido do PHP (dev): entrega arquivos que existem direto
if (PHP_SAPI === 'cli-server' && $path !== '/' && is_file(__DIR__ . $path)) {
    return false;
}

if (!str_starts_with($path, '/api/') && $path !== '/api') {
    $app = __DIR__ . '/dist/index.html';
    if (!is_file($app)) {
        http_response_code(503);
        echo 'Frontend ainda não compilado: rode "npm run build" em frontend/.';
        exit;
    }
    header('Content-Type: text/html; charset=utf-8');
    readfile($app);
    exit;
}

require dirname(__DIR__) . '/src/bootstrap.php';

header('X-Content-Type-Options: nosniff');
header('Referrer-Policy: strict-origin-when-cross-origin');

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
$route = substr($path, 4) ?: '/';   // tira o "/api"
$id = static fn (string $v): int => ctype_digit($v) ? (int) $v : throw new HttpError(404, 'Rota não encontrada.');
$admin = static function () use ($method): void { Auth::require($method); };

$r = new Router();

// ---- público ----
$r->add('GET', '/addons', fn () => Addons::list(true, $_GET['category'] ?? null, isset($_GET['featured'])));
$r->add('GET', '/addons/{slug}', fn ($slug) => Addons::findBySlug($slug, true));
$r->add('GET', '/categories', fn () => Db::all(
    'SELECT c.id, c.slug, c.name, COUNT(a.id) AS total FROM categories c
     LEFT JOIN addons a ON a.category_id = c.id AND a.published = 1
     GROUP BY c.id ORDER BY c.sort_order'
));
$r->add('GET', '/settings', fn () => Settings::all());
$r->add('POST', '/contact', fn () => Contact::send(Http::body()));

// ---- painel ----
$r->add('POST', '/admin/login', fn () => Auth::login((string) (Http::body()['email'] ?? ''), (string) (Http::body()['password'] ?? '')));
$r->add('POST', '/admin/logout', function () { Auth::logout(); return ['ok' => true]; });
$r->add('GET', '/admin/me', fn () => Auth::me());

$r->add('GET', '/admin/addons', function () use ($admin) { $admin(); return Addons::list(false); });
$r->add('POST', '/admin/addons', function () use ($admin) { $admin(); return Addons::save(Http::body()); });
$r->add('GET', '/admin/addons/{id}', function ($v) use ($admin, $id) { $admin(); return Addons::findById($id($v)); });
$r->add('PUT', '/admin/addons/{id}', function ($v) use ($admin, $id) { $admin(); return Addons::save(Http::body(), $id($v)); });
$r->add('DELETE', '/admin/addons/{id}', function ($v) use ($admin, $id) { $admin(); Addons::delete($id($v)); return ['ok' => true]; });
$r->add('POST', '/admin/upload', function () use ($admin) { $admin(); return Uploads::store(); });
$r->add('PUT', '/admin/settings', function () use ($admin) { $admin(); return Settings::update(Http::body()); });
$r->add('GET', '/admin/messages', function () use ($admin) {
    $admin();
    return Db::all('SELECT id, name, email, subject, message, read_at, created_at FROM contact_messages ORDER BY id DESC LIMIT 200');
});
$r->add('PUT', '/admin/messages/{id}/read', function ($v) use ($admin, $id) {
    $admin();
    Db::exec('UPDATE contact_messages SET read_at = COALESCE(read_at, NOW()) WHERE id = ?', [$id($v)]);
    return ['ok' => true];
});
$r->add('DELETE', '/admin/messages/{id}', function ($v) use ($admin, $id) {
    $admin();
    Db::exec('DELETE FROM contact_messages WHERE id = ?', [$id($v)]);
    return ['ok' => true];
});

try {
    $r->dispatch($method, rtrim($route, '/') ?: '/');
} catch (HttpError $e) {
    Http::json(['error' => $e->getMessage(), 'fields' => (object) $e->fields], $e->status);
} catch (Throwable $e) {
    error_log((string) $e);
    Http::json(['error' => APP_DEBUG ? $e->getMessage() : 'Erro no servidor. Tente de novo em instantes.'], 500);
}
