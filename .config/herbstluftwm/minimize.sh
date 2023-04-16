#! /bin/bash

# This script minimizes client and if clients leaves an empty
# frame then it will be minimized as well

hc(){
	herbstclient "$@"
}

clients=$(hc attr tags.focus.curframe_wcount)
currtag=$(hc attr tags.focus.index)
frame_count=0

if [ -f "/tmp/${currtag}_fcount" ]; then
	frame_count=$(cat /tmp/${currtag}_fcount)
fi

if [ $1 = "unmin" ]; then
	if [ -f "/tmp/minimize_${frame_count}_${currtag}" ]; then
		hc load "$(cat /tmp/minimize_${frame_count}_${currtag})"
		rm /tmp/minimize_${frame_count}_${currtag}
		
		((--frame_count))
		if [ $frame_count = 0 ]; then 
			rm /tmp/${currtag}_fcount
		else
			echo $frame_count > /tmp/${currtag}_fcount
		fi
	else
		# When minimized client was in floating state
		hc jumpto last-minimized
	fi
else 
	if [ $(hc attr clients.focus.floating) = "true" ]; then
		hc attr clients.focus.minimized true
		exit 0
	fi

	if [ $clients = 0 ]; then
		exit 1
	fi

	((++frame_count))
	echo $frame_count > /tmp/${currtag}_fcount
	hc dump > /tmp/minimize_${frame_count}_${currtag}

	if [ $clients = 1 ]; then
		hc remove
	fi

	hc attr clients.focus.minimized true
fi
