#!/bin/bash

zenity --question --text="Are you sure, proceed to shutdown?"
if [ $? = 0 ]; then
	 systemctl poweroff
else
	 exit
fi

