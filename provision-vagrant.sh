#! /bin/bash

# Virtualbox Guest Additions
pacman -S --noconfirm linux-headers virtualbox-guest-utils 
systemctl enable vboxservice

# Users
groupadd vagrant
useradd --comment "Vagrant" --create-home --gid users --groups vagrant,vboxsf vagrant

# Passwords
passwd <<EOI
vagrant
vagrant
EOI

passwd vagrant <<EOI
vagrant
vagrant
EOI

# Sudo
pacman -S --noconfirm sudo
echo 'Defaults env_keep += "SSH_AUTH_SOCK"' > /etc/sudoers.d/10_vagrant
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/10_vagrant
chmod 0440 /etc/sudoers.d/10_vagrant

# SSH
mkdir /home/vagrant/.ssh
curl --output /home/vagrant/.ssh/authorized_keys --location https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
chown vagrant:users -R /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
chmod 0600 /home/vagrant/.ssh/authorized_keys

# NFS
pacman -S --noconfirm net-tools nfs-utils
systemctl enable rpcbind nfs-server nfs-client.target

# Utils
pacman -S --noconfirm htop tmux
