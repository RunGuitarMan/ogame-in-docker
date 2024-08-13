#!/bin/bash

# Запуск MySQL в фоновом режиме
service mysql start

# Выполнение SQL-скрипта для инициализации базы данных
mysql -u root -e "source /docker-entrypoint-initdb.d/init.sql"

# Запуск PHP-FPM
service php7.4-fpm start

# Запуск Nginx
nginx -g 'daemon off;'