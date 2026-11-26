<?php
// Cria as tabelas e o conteúdo inicial: php bin/migrate.php
declare(strict_types=1);
require dirname(__DIR__) . '/src/bootstrap.php';

$dir = dirname(__DIR__, 2) . '/database';
$pdo = App\Db::pdo();
foreach (['schema.sql', 'seed.sql'] as $file) {
    $pdo->exec(file_get_contents("$dir/$file"));
    echo "ok: $file\n";
}
