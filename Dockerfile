# Используем базовый образ
FROM ubuntu:20.04

# Установка временной зоны без интерактивного ввода
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Установка необходимых пакетов
RUN apt-get install -y nginx php-fpm php-gd php-mbstring php-mysql mysql-server git

# Клонирование исходного кода ogame
RUN git clone https://github.com/ogamespec/ogame-opensource.git /app/ogame

# Создание директорий, если они не существуют
RUN mkdir -p /var/www/html/game /var/www/Universe

# Копирование исходного кода в нужные директории
RUN cp -r /app/ogame/wwwroot/* /var/www/html/ && \
    cp -r /app/ogame/game/* /var/www/html/game/ && \
    chown -R www-data:www-data /var/www/html /var/www/html/game

# Копирование конфигурационных файлов
COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

# Конфигурация MySQL
COPY my.cnf /etc/mysql/my.cnf

# Задаём переменные окружения для автоматического создания базы данных и пользователя
ENV MYSQL_DATABASE=ogame \
    MYSQL_USER=ogame \
    MYSQL_PASSWORD=ogame \
    MYSQL_ROOT_PASSWORD=root_password

# Открытие портов
EXPOSE 80 3306

# Инициализация MySQL и запуск сервисов
CMD service mysql start && \
    service php7.4-fpm start && nginx -g 'daemon off;'
