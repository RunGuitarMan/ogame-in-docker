# Используем официальный образ PHP-FPM
FROM php:7.4-fpm

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    curl \
    git \
    nginx \
    && rm /etc/nginx/sites-enabled/default

# Устанавливаем расширения PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mbstring pdo pdo_mysql

# Создаем необходимые директории
RUN mkdir -p /var/run/php

# Копируем конфигурационные файлы nginx
COPY nginx/default /etc/nginx/sites-enabled/

# Копируем исходный код игры
RUN git clone https://github.com/ogamespec/ogame-opensource.git /var/www/ogame \
    && cp -r /var/www/ogame/wwwroot/* /var/www/html/ \
    && cp -r /var/www/ogame/game/* /var/www/Universe/ \
    && chown -R www-data:www-data /var/www/html /var/www/Universe

# Настраиваем PHP
RUN { \
    echo 'short_open_tag = On'; \
    echo 'max_execution_time = 200'; \
    echo 'display_errors = On'; \
    echo 'variables_order = "EGPCS"'; \
} > /usr/local/etc/php/conf.d/custom.ini

# Настраиваем команды запуска
CMD service nginx start && php-fpm -D && tail -f /var/log/nginx/error.log