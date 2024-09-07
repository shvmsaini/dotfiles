#!/bin/bash

zenity --question --text="Are you sure, proceed to shutdown?"
if [ $? = 0 ]; then
	# /sbin/shutdown now
	systemctl poweroff
  #sudo halt
  #killall -u shvmpc
  #poweroff
else
	 exit
fi

