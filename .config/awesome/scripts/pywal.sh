#! /bin/bash

cat "/tmp/.pywal" > /dev/null

if [ $? = 0 ] && [ $# -eq 0 ]; then
	exit 1
fi

wdir="/mnt/forlinuxuse/Wallpapers"

if [ "$#" = 1 ] && [ $1 != -f ]; then
	wall=$1
else
	wall=$wdir/"$(ls $wdir | shuf | head -n 1)"
fi

wal -i $wall >/dev/null

echo 1 > /tmp/.pywal

# As wall is not able to set wallpaper in awesome
feh --bg-fill $wall 

# Restart awesome
awesome-client 'awful = require("awful"); awesome.restart()'     
