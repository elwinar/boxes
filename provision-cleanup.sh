#! /bin/bash

# Clear pacman cache
pacman -Scc --noconfirm

# Zero-out space
dd if=/dev/zero of=/EMPTY
rm -f /EMPTY

# Clear history
cat /dev/null > ~/.bash_history && history -c
