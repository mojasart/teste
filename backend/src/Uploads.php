<?php
declare(strict_types=1);

namespace App;

final class Uploads
{
    private const MAX_BYTES = 8 * 1024 * 1024;
    private const TYPES = ['image/png' => 'png', 'image/jpeg' => 'jpg', 'image/webp' => 'webp', 'image/gif' => 'gif'];

    /** Recebe o campo "file" e devolve a URL pública. */
    public static function store(): array
    {
        $f = $_FILES['file'] ?? null;
        if (!$f || !is_array($f) || ($f['error'] ?? UPLOAD_ERR_NO_FILE) === UPLOAD_ERR_NO_FILE) {
            throw new HttpError(400, 'Escolha uma imagem.');
        }
        if ($f['error'] === UPLOAD_ERR_INI_SIZE || $f['error'] === UPLOAD_ERR_FORM_SIZE || $f['size'] > self::MAX_BYTES) {
            throw new HttpError(413, 'A imagem passa de 8 MB. Diminua e tente de novo.');
        }
        if ($f['error'] !== UPLOAD_ERR_OK || !is_uploaded_file($f['tmp_name'])) {
            throw new HttpError(400, 'Não consegui receber a imagem. Tente de novo.');
        }

        $mime = (new \finfo(FILEINFO_MIME_TYPE))->file($f['tmp_name']);
        $ext = self::TYPES[$mime] ?? null;
        if (!$ext || @getimagesize($f['tmp_name']) === false) {
            throw new HttpError(415, 'Use uma imagem PNG, JPG, WEBP ou GIF.');
        }

        $sub = date('Y/m');
        $dir = PUBLIC_DIR . '/uploads/' . $sub;
        if (!is_dir($dir) && !mkdir($dir, 0775, true) && !is_dir($dir)) {
            throw new HttpError(500, 'Não consegui criar a pasta de uploads.');
        }
        $name = bin2hex(random_bytes(12)) . '.' . $ext;
        if (!move_uploaded_file($f['tmp_name'], "$dir/$name")) {
            throw new HttpError(500, 'Não consegui salvar a imagem.');
        }
        return ['url' => "/uploads/$sub/$name"];
    }
}
