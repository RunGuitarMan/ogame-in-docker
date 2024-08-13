# Используем базовый образ
FROM ubuntu:20.04

# Установка необходимых пакетов
RUN apt-get update && \
    apt-get install -y nginx php-fpm php-gd php-mbstring php-mysql git

# Клонирование исходного кода ogame
RUN git clone https://github.com/ogamespec/ogame-opensource.git /var/www/ogame

# Копирование исходного кода в нужные директории
RUN cp -r /var/www/ogame/wwwroot/* /var/www/html/ && \
    cp -r /var/www/ogame/game/* /var/www/Universe/ && \
    chown -R www-data:www-data /var/www/html /var/www/Universe

# Копирование конфигурационных файлов
COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

# Открытие порта
EXPOSE 80

# Запуск Nginx и PHP-FPM
CMD service php7.4-fpm start && nginx -g 'daemon off;'
