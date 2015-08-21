#! /bin/bash

DISK="/dev/sda"
PARTITION_NUMBER="1"
PARTITION="$DISK$PARTITION_NUMBER"
MOUNTPOINT="/mnt"
TIMEZONE="Europe/Paris"
LANGUAGE="en_US.UTF-8"
KEYMAP="fr"

#
# Partitions
#

# Remove old partition table
sgdisk --zap $DISK 

# Create a new partition from start to end of the available space
sgdisk --new=$PARTITION_NUMBER:0:0 $DISK 

# Make partition bootable by setting it's 2nd bit up
sgdisk --attribute=$PARTITION_NUMBER:set:2

# Create the ext4 filesystem
mkfs -t ext4 ${PARTITION}

# Mount the partition
mount ${PARTITION} $MOUNTPOINT


#
# System
#

# Bootstrap the system
pacstrap $MOUNTPOINT base base-devel

# Generate the filesystem table
genfstab -U -p $MOUNTPOINT >> $MOUNTPOINT/etc/fstab


#
# Setup
#

# Timezone and locales
arch-chroot $MOUNTPOINT ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime
arch-chroot $MOUNTPOINT echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf
arch-chroot $MOUNTPOINT sed -i "s/#$LANGUAGE/$LANGUAGE/" /etc/locale.gen
arch-chroot $MOUNTPOINT echo "LANG=$LANGUAGE" > /etc/locale.conf
arch-chroot $MOUNTPOINT locale-gen

# Enable networking on boot
arch-chroot $MOUNTPOINT systemctl enable dhcpcd

# Initial RAM disk
arch-chroot $MOUNTPOINT mkinitcpio -p linux

# Install and configure the bootloader
arch-chroot $MOUNTPOINT pacman -S --noconfirm gptfdisk syslinux
arch-chroot $MOUNTPOINT syslinux-install_update -i -a -m
arch-chroot $MOUNTPOINT sed -i 's/sda3/sda1/' /boot/syslinux/syslinux.cfg

# Install and configure openssh
arch-chroot $MOUNTPOINT pacman -S --noconfirm openssh
arch-chroot $MOUNTPOINT systemctl enable sshd
arch-chroot $MOUNTPOINT sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
arch-chroot $MOUNTPOINT sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
arch-chroot $MOUNTPOINT sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config


#
# Cleanup
#

arch-chroot pacman -Rcns --noconfirm gptfdisk
arch-chroot pacman -Scc --noconfirm


#
# Reboot
#

reboot now
