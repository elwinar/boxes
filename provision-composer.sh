#! /bin/bash

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
pacman -S --noconfirm git
