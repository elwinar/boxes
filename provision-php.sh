#! /bin/bash

pacman -S --noconfirm php php-fpm php-mcrypt php-gd
systemctl enable php-fpm

sed -i 's/display_errors = Off/display_errors = On/' /etc/php/php.ini
sed -ri 's#open_basedir = (.*)#open_basedir = /#' /etc/php/php.ini
sed -ri 's/;extension=(phar|openssl|mcrypt|zip|gd).so/extension=\1.so/' /etc/php/php.ini

sed -i 's/listen.owner = http/listen.owner = vagrant/' /etc/php/php-fpm.conf
sed -i 's/listen.group = http/listen.group = vagrant/' /etc/php/php-fpm.conf 
