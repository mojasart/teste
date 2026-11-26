<?php
declare(strict_types=1);

namespace App;

final class HttpError extends \RuntimeException
{
    /** @param array<string, string> $fields erros por campo do formulário */
    public function __construct(public readonly int $status, string $message, public readonly array $fields = [])
    {
        parent::__construct($message);
    }
}
