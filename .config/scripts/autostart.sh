#! /bin/bash

# $HOME/.config/scripts/autoxrandr.sh &

#killall picom 
#picom --config $HOME/.config/picom/picom.conf &

# killall nm-applet
# nm-applet &

#killall parcellite
#parcellite &

# killall polkitd
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# killall gnome-keyring-daemon 
gnome-keyring-daemon & 

numlockx & # Activating numlock
xset r rate 250 40 & # Lower keypress delays
setxkbmap -option caps:swapescape # Swapping escape and capslock

#clipmenud &
greenclip daemon &

