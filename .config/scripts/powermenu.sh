#! /bin/sh

chosen=$(printf "Shutdown\nReboot\nSleep" | rofi -dmenu -i )

case "$chosen" in
	 "Shutdown") ~/.config/scripts/shutdown.sh;;
	 "Reboot") ~/.config/scripts/reboot.sh;;
	 "Sleep") ~/.config/scripts/sleep.sh;;
	 *) exit 1;;
esac
