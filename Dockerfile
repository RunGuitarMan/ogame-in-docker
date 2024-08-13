FROM ubuntu:20.04

# Установка необходимых пакетов
RUN apt-get update && \
    apt-get install -y nginx php-fpm php-gd php-mbstring php-mysql git

# Копирование конфигураций
COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

# Открытие порта
EXPOSE 80

# Запуск сервисов
CMD service php7.4-fpm start && nginx -g 'daemon off;'
