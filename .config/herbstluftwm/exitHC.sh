#!/bin/bash

zenity --question --text="Are you sure, proceed to exit Herbstluftwm?"
if [ $? = 0 ]; then
	 	 herbstclient quit
	else
		 	 exit
fi

