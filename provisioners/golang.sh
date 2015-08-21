#! /bin/bash

pacman -S --noconfirm go git subversion mercurial bzr
echo "export GOPATH=~
export PATH=\$GOPATH/bin:\$PATH
" >> /home/vagrant/.bashrc
