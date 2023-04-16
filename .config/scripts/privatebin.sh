#! /bin/bash

# Saving Screenshot
dir=$(mktemp -dt "$(basename $0).XXXXXXXXXXXX") &&
file="screeshot.jpg"

flameshot gui --path $dir/$file

pbincli=$HOME/.local/lib/python3.10/site-packages/pbincli/cli.py

# Find instances here https://privatebin.info/directory/
server="https://0.0g.gg"
#server="https://0.jaegers.net"

# Magic
python3 $pbincli send -q -f $dir/$file -B -s $server > $dir/links.txt

if [ $(sed -n '$=' $dir/links.txt) -eq 9 ]; then # Count lines

	awk '{print $2}' $dir/links.txt | sed -n '8{p;q}' | xclip -selection clipboard

	notify-send -u normal "Your privatebin script is done!"
else
	notify-send -u normal "Whoops! There is some problem."
fi

