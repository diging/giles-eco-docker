CREATE DATABASE nepomuk;

CREATE USER 'nepomuk'@'%' IDENTIFIED BY 'NepomukPassword';
GRANT ALL ON nepomuk.* TO 'nepomuk'@'%';
