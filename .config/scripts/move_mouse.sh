#! /bin/sh

x=$(xdotool getmouselocation | cut -d " " -f 1 | cut -d ":" -f 2)

if [ $x -gt 1920 ]; then
	xdotool mousemove 960 540
else
	xdotool mousemove 2612 384
fi
