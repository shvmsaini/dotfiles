#! /bin/bash

echo -n "Checking dependencies... "

if command -v flameshot &> /dev/null  &&  command -v xclip &> /dev/null  &&  command -v tesseract &> /dev/null   ; then
	echo "Everything is there! Running..."
else 
	echo "One of the following programmes is not installed, make sure you install them first."
	echo "flameshot, xclip, tesseract"
    echo "Exiting..."
	exit 1
fi

# Temperory directory to work with, it will be deleted on reboot
dir=$(mktemp -dt "$(basename $0).XXXXXXXXXXXX")
file="screeshot.jpg"

flameshot gui -p $dir/$file

#TESSDATA_PREFIX=/usr/local/share/tessdata/ tesseract $dir/$file $dir/output

tesseract $dir/$file $dir/output

xclip -selection clipboard < $dir/output.txt 

notify-send -t 2000 "Copied \"$(cat $dir/output.txt)\" to clipboard"

trap "rm -rf $dir" EXIT
