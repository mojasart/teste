# 1) compila o frontend (Vue)
FROM node:22-alpine AS front
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ ./
RUN npm run build   # gera ../backend/public/dist

# 2) PHP + Apache servindo backend/public
FROM php:8.3-apache
RUN docker-php-ext-install pdo_mysql \
 && a2enmod rewrite headers \
 && sed -i 's#/var/www/html#/var/www/backend/public#g' /etc/apache2/sites-available/000-default.conf \
 && printf '<Directory /var/www/backend/public>\n  AllowOverride All\n  Require all granted\n</Directory>\n' > /etc/apache2/conf-enabled/purplebyte.conf \
 && printf 'upload_max_filesize=10M\npost_max_size=12M\nexpose_php=Off\n' > /usr/local/etc/php/conf.d/purplebyte.ini
WORKDIR /var/www
COPY backend/ backend/
COPY database/ database/
COPY imagens/ imagens/
COPY --from=front /app/backend/public/dist backend/public/dist
RUN mkdir -p backend/public/uploads && chown -R www-data:www-data backend/public/uploads
