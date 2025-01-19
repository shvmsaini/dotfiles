#! /bin/bash

echo -n "Checking dependencies... "

if command -v flameshot &> /dev/null  &&  command -v xclip &> /dev/null  &&  command -v zbarimg &> /dev/null   ; then
	echo "Everything is there! Running..."
else 
	echo "One of the following programmes is not installed, make sure you install them first."
	echo "flameshot, xclip, zbarimg"
    echo "Exiting..."
	exit 1
fi

# Temperory directory to work with, it will be deleted on reboot
dir=$(mktemp -dt "$(basename $0).XXXXXXXXXXXX")
file="screeshot.jpg"

echo "File will be saved at $dir/$file"

flameshot gui -p $dir/$file

if [ $? -eq 0 ]; then
  #TESSDATA_PREFIX=/usr/local/share/tessdata/ tesseract $dir/$file $dir/output

  zbarimg $dir/$file | cut -d ':' -f2- | xclip -selection clipboard
else 
  echo "flameshot didn't capture"
fi

trap "rm -rf $dir" EXIT
