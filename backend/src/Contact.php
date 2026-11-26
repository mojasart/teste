<?php
declare(strict_types=1);

namespace App;

final class Contact
{
    public static function send(array $in): array
    {
        // campo escondido: só robô preenche
        if (!empty($in['website'])) {
            return ['ok' => true];
        }
        $name = trim((string) ($in['name'] ?? ''));
        $email = trim((string) ($in['email'] ?? ''));
        $subject = trim((string) ($in['subject'] ?? ''));
        $message = trim((string) ($in['message'] ?? ''));

        $err = [];
        if ($name === '' || mb_strlen($name) > 120) {
            $err['name'] = 'Diga seu nome.';
        }
        if (!filter_var($email, FILTER_VALIDATE_EMAIL) || mb_strlen($email) > 190) {
            $err['email'] = 'Confira o e-mail: ele precisa ter @ e domínio, como nome@email.com.';
        }
        if (mb_strlen($subject) > 190) {
            $err['subject'] = 'Use no máximo 190 caracteres.';
        }
        if (mb_strlen($message) < 10) {
            $err['message'] = 'Escreva pelo menos 10 caracteres.';
        } elseif (mb_strlen($message) > 5000) {
            $err['message'] = 'Use no máximo 5000 caracteres.';
        }
        if ($err) {
            throw new HttpError(422, 'Confira os campos destacados.', $err);
        }

        $ip = Http::ip();
        $recent = Db::one('SELECT COUNT(*) n FROM contact_messages WHERE ip = ? AND created_at > NOW() - INTERVAL 1 HOUR', [$ip]);
        if ((int) $recent['n'] >= 5) {
            throw new HttpError(429, 'Você já mandou várias mensagens. Tente de novo daqui a uma hora.');
        }

        Db::exec(
            'INSERT INTO contact_messages (name, email, subject, message, ip) VALUES (?, ?, ?, ?, ?)',
            [$name, $email, $subject, $message, $ip]
        );
        return ['ok' => true];
    }
}
