#! /bin/bash

curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/bin --filename=composer
pacman -S --noconfirm git
