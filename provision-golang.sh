#! /bin/bash

pacman -S --noconfirm go

echo "export GOPATH=~
export PATH=\$GOPATH/bin:\$PATH
" > ~/.bashrc
