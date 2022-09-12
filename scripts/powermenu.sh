#! /bin/sh

chosen=$(printf "Shutdown\nReboot\nSleep" | rofi -dmenu -i )

case "$chosen" in
	 "Shutdown") ~/shutdown.sh;;
	 "Reboot") ~/reboot.sh;;
	 "Sleep") ~/sleep.sh;;
	 *) exit 1;;
esac
