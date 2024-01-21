#!/bin/bash

zenity --question --text="Are you sure, proceed to reboot?"
if [ $? = 0 ]; then
	/sbin/shutdown -r now
	# systemctl reboot
else
    exit
fi

