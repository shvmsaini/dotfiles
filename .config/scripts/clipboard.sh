#! /bin/bash

choosen=$(xcmenu --dmenu | rofi -dmenu -i)

echo $choosen
