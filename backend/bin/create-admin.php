<?php
// Cria (ou troca a senha de) um usuário do painel:
//   php bin/create-admin.php voce@email.com "Seu Nome"
// A senha é pedida no terminal (não fica no histórico).
declare(strict_types=1);
require dirname(__DIR__) . '/src/bootstrap.php';

$email = mb_strtolower(trim($argv[1] ?? ''));
$name = trim($argv[2] ?? '');
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    fwrite(STDERR, "Uso: php bin/create-admin.php email \"Nome\"\n");
    exit(1);
}

$pass = getenv('ADMIN_PASSWORD') ?: '';
if ($pass === '') {
    echo 'Senha (mín. 10 caracteres): ';
    if (DIRECTORY_SEPARATOR === '/') {
        system('stty -echo');
    }
    $pass = trim((string) fgets(STDIN));
    if (DIRECTORY_SEPARATOR === '/') {
        system('stty echo');
    }
    echo "\n";
}
if (mb_strlen($pass) < 10) {
    fwrite(STDERR, "A senha precisa de pelo menos 10 caracteres.\n");
    exit(1);
}

App\Db::exec(
    'INSERT INTO users (email, name, password_hash) VALUES (?, ?, ?)
     ON DUPLICATE KEY UPDATE password_hash = VALUES(password_hash), name = IF(VALUES(name) = "", name, VALUES(name))',
    [$email, $name, password_hash($pass, PASSWORD_DEFAULT)]
);
echo "Pronto: $email pode entrar em /admin\n";
