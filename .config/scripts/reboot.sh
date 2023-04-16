#!/bin/bash

zenity --question --text="Are you sure, proceed to reboot?"
if [ $? = 0 ]; then
	 systemctl reboot
else
    exit
fi

