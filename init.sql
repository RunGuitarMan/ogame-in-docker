CREATE DATABASE IF NOT EXISTS ogame;
CREATE USER IF NOT EXISTS 'ogame'@'%' IDENTIFIED BY 'ogame';
GRANT ALL PRIVILEGES ON ogame.* TO 'ogame'@'%';
FLUSH PRIVILEGES;