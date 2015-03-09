#! /bin/bash

pacman -S --noconfirm nginx
systemctl enable nginx

echo "user vagrant vagrant;
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
	index index.html;

	server {
		listen 80;
		root /vagrant;
	}
}
" > /etc/nginx/nginx.conf
