#! /bin/bash

# This script gets the name of the 2 connected monitors
# and Connects DP monitor to the right of HDMI monitor 

arr=($(xrandr | grep " connected" | awk '{print $1;}';))


#if [ arr[1] = "HDMI-1" ]; then
#  xrandr --output ${arr[1]} --rate 75 --primary --left-of ${arr[0]}
#else 
#  xrandr --output ${arr[0]} --primary --right-of ${arr[1]} --rate 75
#fi

if [ arr[1] = "HDMI-1" ]; then
  xrandr --output ${arr[1]} --primary --left-of ${arr[0]} 
else 
  xrandr --output ${arr[0]} --primary --right-of ${arr[1]}
fi
