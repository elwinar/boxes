#! /bin/bash

# PHP
pacman -S --noconfirm php php-fpm php-mcrypt php-gd php-sqlite
systemctl enable php-fpm
sed -i 's/display_errors = Off/display_errors = On/' /etc/php/php.ini
sed -i 's/open_basedir = /open_basedir = \/usr\/local\/bin:/' /etc/php/php.ini

sed -i 's/;extension=curl.so/extension=curl.so/' /etc/php/php.ini
sed -i 's/;extension=ftp.so/extension=ftp.so/' /etc/php/php.ini
sed -i 's/;extension=gd.so/extension=gd.so/' /etc/php/php.ini
sed -i 's/;extension=gettext.so/extension=gettext.so/' /etc/php/php.ini
sed -i 's/;extension=mcrypt.so/extension=mcrypt.so/' /etc/php/php.ini
sed -i 's/;extension=openssl.so/extension=openssl.so/' /etc/php/php.ini
sed -i 's/;extension=pdo_sqlite.so/extension=pdo_sqlite.so/' /etc/php/php.ini
sed -i 's/;extension=phar.so/extension=phar.so/' /etc/php/php.ini
sed -i 's/;extension=zip.so/extension=zip.so/' /etc/php/php.ini

sed -i 's/listen.owner = http/listen.owner = vagrant/' /etc/php/php-fpm.conf
sed -i 's/listen.group = http/listen.group = vagrant/' /etc/php/php-fpm.conf 

# NGINX
pacman -S --noconfirm nginx
systemctl enable nginx
echo "user vagrant users;
worker_processes 1;

events {
	worker_connections 512;
	use epoll;
}

http {
	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	access_log /var/log/nginx/access.log combined;
	error_log /var/log/nginx/error.log info;
	rewrite_log on;
	index index.php index.html;

	server {
		listen 80;
		root /vagrant/public;

		location ~* \.(png|jpg|jpeg|gif)\$ {
			expires 7d;
			log_not_found off;
		}

		location / {
			try_files \$uri \$uri/ /index.php?\$query_string;
		}

		if (!-d \$request_filename) {
			rewrite ^/(.+)/\$ /\$1 permanent;
		}

		location ~ \.php\$ {
			fastcgi_pass unix:/run/php-fpm/php-fpm.sock;
			fastcgi_index index.php;
			include fastcgi.conf;
		}
	}
}
" > /etc/nginx/nginx.conf

# Git
pacman -S --noconfirm git

# Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
composer self-update

# Node.js, Gulp, Bower
pacman -S --noconfirm nodejs
npm install -g gulp bower
