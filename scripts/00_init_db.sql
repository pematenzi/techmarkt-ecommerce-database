DROP DATABASE IF EXISTS techmarkt;

CREATE DATABASE techmarkt;

USE techmarkt;

CREATE USER IF NOT EXISTS 'techmarkt'@'localhost' IDENTIFIED BY 'techmarkt';
GRANT ALL PRIVILEGES ON techmarkt.* TO 'techmarkt'@'localhost';
FLUSH PRIVILEGES;