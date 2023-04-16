#!/bin/bash

zenity --question --text="Are you sure, proceed to sleep?"
if [ $? = 0 ]; then
	systemctl suspend
else
    exit
fi

