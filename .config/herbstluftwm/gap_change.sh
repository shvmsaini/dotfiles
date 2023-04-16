#! /bin/bash

current_gap=$(herbstclient get window_gap)

if [ $1 = '-' ]; then
	if [ $current_gap -eq 0 ]; then
		exit 0
	fi 
	let size=$current_gap-2
else
	let size=$current_gap+2	
fi

herbstclient set window_gap $size
