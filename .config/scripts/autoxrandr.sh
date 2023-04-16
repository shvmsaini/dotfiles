#! /bin/bash

# This script gets the name of the 2 connected monitors
# and Connects DP monitor to the right of HDMI monitor 

arr=($(xrandr | grep " connected" | awk '{print $1;}';))

xrandr --output ${arr[1]} --auto --right-of ${arr[0]}
