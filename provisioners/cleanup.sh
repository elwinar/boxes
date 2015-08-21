#! /bin/bash

pacman -Scc --noconfirm
dd if=/dev/zero of=/EMPTY
rm -f /EMPTY
cat /dev/null > ~/.bash_history && history -c
