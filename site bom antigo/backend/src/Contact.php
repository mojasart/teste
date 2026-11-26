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
            $err['name'] = 'Enter your name.';
        }
        if (!filter_var($email, FILTER_VALIDATE_EMAIL) || mb_strlen($email) > 190) {
            $err['email'] = 'Check your email address. It needs an @ and a domain, like name@example.com.';
        }
        if (mb_strlen($subject) > 190) {
            $err['subject'] = 'Use 190 characters or fewer.';
        }
        if (mb_strlen($message) < 10) {
            $err['message'] = 'Write at least 10 characters.';
        } elseif (mb_strlen($message) > 5000) {
            $err['message'] = 'Use 5000 characters or fewer.';
        }
        if ($err) {
            throw new HttpError(422, 'Check the highlighted fields.', $err);
        }

        $ip = Http::ip();
        $recent = Db::one('SELECT COUNT(*) n FROM contact_messages WHERE ip = ? AND created_at > NOW() - INTERVAL 1 HOUR', [$ip]);
        if ((int) $recent['n'] >= 5) {
            throw new HttpError(429, 'You have sent several messages already. Try again in an hour.');
        }

        Db::exec(
            'INSERT INTO contact_messages (name, email, subject, message, ip) VALUES (?, ?, ?, ?, ?)',
            [$name, $email, $subject, $message, $ip]
        );
        return ['ok' => true];
    }
}
