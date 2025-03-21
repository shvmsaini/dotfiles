#! /bin/bash

$HOME/.config/scripts/autoxrandr.sh &

killall picom 
picom --config $HOME/.config/picom/picom_dual_blur.conf &
# xcompmgr &

# killall nm-applet
# nm-applet &

killall polkitd
killall polkit-gnome-au
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

killall gnome-keyring-d 
gnome-keyring-daemon & 

numlockx & # Activating numlock
xset r rate 250 40 & # Lower keypress delays
setxkbmap -option caps:swapescape # Swapping escape and capslock
#xmodmap -e "keycode 66 = Escape NoSymbol Escape" \
#          "keycode 9 = Super_R NoSymbol Super_R"
          #"keycode 134 = Caps_Lock NoSymbol Caps_Lock"

# Clipboard Managers
killall greenclip
greenclip daemon &

# Auto-suspend service
killall suspend_if_idle.sh
~/.config/scripts/suspend_if_idle.sh &
