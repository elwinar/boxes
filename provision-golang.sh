#! /bin/bash

pacman -S --noconfirm go git subversion mercurial
echo "export GOPATH=~
export PATH=\$GOPATH/bin:\$PATH
" >> ~/.bashrc
source ~/.bashrc
go get golang.org/x/tools/cmd/...
