#! /bin/bash

mino="$(xrandr | grep " con" | awk '{print $1;}';)"
arr=($mino)
mone=$(echo ${arr[1]});
mzero=$(echo ${arr[0]});

xrandr --output $mone --auto --right-of $mzero
