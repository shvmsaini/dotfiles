#! /bin/bash

# This script gets the name of the 2 connected monitors
# and Connects DP monitor to the right of HDMI monitor 

arr=($(xrandr | grep " connected" | awk '{print $1;}';))

xrandr --output ${arr[1]} --primary --left-of ${arr[0]} --rate 75
