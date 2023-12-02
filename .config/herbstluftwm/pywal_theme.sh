#! /bin/bash

hc(){
	herbstclient "$@"
}

wdir="/mnt/forlinuxuse/Wallpapers"
if [ "$#" = "1" ]; then
	wall=$1
else
	wall=$wdir/"$(ls $wdir | shuf | head -n 1)"
fi

wal -i $wall >/dev/null

source ~/.cache/wal/colors.sh

# theme 
hc attr theme.outer_color black
hc attr theme.active.inner_color $foreground
hc attr theme.active.color $foreground
hc attr theme.active.outer_color $foreground
#hc set frame_bg_normal_color "${color2}00"
#hc set frame_bg_active_color "${color3}00"
hc set frame_bg_transparent off

# Tabs
hc attr theme.tab_color $background
hc attr thene.tab_title_color $foreground
hc attr theme.tab_outer_color $background

killall dunst &
