#!/bin/sh
## Create users and groups
groupadd -r autologin
useradd -m live; passwd -d live
gpasswd -a live wheel; gpasswd -a live autologin
passwd -d root

## Uncomment mirrors in pacman mirrorlist
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
[ -f /etc/pacman.d/archlinuxcn-mirrorlist ] && sed -i "s/#Server/Server/g" /etc/pacman.d/archlinuxcn-mirrorlist

## Enable important system services
systemctl enable fstrim.timer systemd-timesyncd NetworkManager
[ -f /usr/lib/systemd/system/ufw.service ] && systemctl enable ufw

## Initialise Pacman keyring
pacman-key --init
pacman-key --populate

## Add Chaotic-AUR keys
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB

## Replace mkinitcpio.conf so that mkinitcpio is properly configured for Arch install
cp -f /etc/mkinitcpio.conf.system /etc/mkinitcpio.conf

## Generate locales if not already done
[ $(localectl list-locales | grep -c ".UTF-8") -le 1 ] && locale-gen

## Copy Calamares installer files
if [ -d /etc/calamares-custom ]; then
    rm -rf /etc/calamares
    mv /etc/calamares-custom /etc/calamares
fi
if [ -f /usr/share/applications/calamares.desktop ]; then
    cp /usr/share/applications/calamares.desktop /etc/xdg/autostart/
fi

## Delete unneeded files
rm -f /etc/*.pacnew /etc/lightdm/*.pacnew
rm -f /usr/share/libalpm/hooks/zzzz-archiso-setup.hook
rm -f /usr/share/libalpm/scripts/archiso-setup.sh
