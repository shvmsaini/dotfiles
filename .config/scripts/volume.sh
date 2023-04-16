#!/bin/bash

low="/usr/share/icons/Papirus/48x48/status/notification-audio-volume-low.svg"
mid="/usr/share/icons/Papirus/48x48/status/notification-audio-volume-medium.svg"
high="/usr/share/icons/Papirus/48x48/status/notification-audio-volume-high.svg"
muted="/usr/share/icons/Papirus/48x48/status/notification-audio-volume-muted.svg"

function get_volume {
    amixer -D pulse get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
    amixer -D pulse get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
    volume=`get_volume`
	if [ "$volume" = "0" ]; then
        icon_name=$muted
    	else
		if [ "$volume" -lt "30" ]; then
			icon_name=$low
		else
			if [ "$volume" -lt "50" ]; then
			    icon_name=$mid
			else 
				icon_name=$high
			fi
		fi
     fi
	notify-send "Volume: $volume%" -i "$icon_name" -t 2000 -h string:synchronous:"─"
}

case $1 in
    up)
	# Set the volume on (if it was muted)
	amixer -D pulse set Master on > /dev/null
	# Up the volume (+ 5%)
	amixer -D pulse sset Master 5%+ > /dev/null
	send_notification
	;;
    down)
	amixer -D pulse set Master on > /dev/null
	amixer -D pulse sset Master 5%- > /dev/null
	send_notification
	;;
    mute)
    	# Toggle mute
	amixer -D pulse set Master 1+ toggle > /dev/null
	if is_mute ; then
	    notify-send -i $icon-muted --replace=555 -u normal "Mute" -t 2000
	else
	    send_notification
	fi
	;;
esac
