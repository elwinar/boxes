#! /bin/bash

pacman -S --noconfirm go git subversion mercurial
echo "export GOPATH=~
export PATH=\$GOPATH/bin:\$PATH
" >> /home/vagrant/.bashrc
