#! /bin/sh
sudo mount /dev/sda4 mnt
sudo mount --rbind /dev mnt/dev
sudo mount --rbind /proc mnt/proc
sudo mount --rbind /sys mnt/sys
sudo chroot mnt /bin/bash
