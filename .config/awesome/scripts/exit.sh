#! /bin/sh

zenity --question --text="Are you sure you want to exit Awesomewm?"
if [ $? = 0 ]; then
	 awesome-client 'awesome.quit()'
else
	exit
fi

