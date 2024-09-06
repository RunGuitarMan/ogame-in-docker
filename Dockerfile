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

# Копирование замененного файла "Welcome to nginx!"
COPY index.html /usr/share/nginx/html/index.html
COPY index.html /var/www/html/index.nginx-debian.html

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
COPY my.cnf /etc/mysql/my.cnf

# Копирование SQL-скрипта для инициализации
COPY init.sql /docker-entrypoint-initdb.d/

# Копирование и установка скрипта запуска
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Открытие портов
EXPOSE 8080

# Запуск MySQL и других сервисов
CMD ["/usr/local/bin/start.sh"]
