#!/bin/bash

apt install -y apache2 mariadb-server libapache2-mod-php7.4 \
                php7.4-gd php7.4-mysql php7.4-curl php7.4-mbstring php7.4-intl \
                php7.4-gmp php7.4-bcmath php-imagick php7.4-xml php7.4-zip

/etc/init.d/mysql start
mysql -uroot -p

cd /var/www/html/ || return 1

wget https://download.nextcloud.com/server/releases/nextcloud-21.0.1.zip

sudo unzip nextcloud-21.0.1.zip -d /var/www/html/

sudo chown -R www-data:www-data /var/www/html/nextcloud
sudo chmod -R 775 /var/www/html/nextcloud
