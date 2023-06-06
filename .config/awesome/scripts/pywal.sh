#! /bin/bash

wdir="/mnt/forlinuxuse/Wallpapers"
if [ "$#" = "1" ]; then
	wall=$1
else
	wall=$wdir/"$(ls $wdir | shuf | head -n 1)"
fi

wal -i $wall >/dev/null

# As wall is not able to set wallpaper in awesome
feh --bg-fill $wall 

# Restart awesome
awesome-client 'awful = require("awful"); awesome.restart()'     
