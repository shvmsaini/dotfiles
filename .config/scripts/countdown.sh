#! /bin/sh
secs=$(($1 * 60))
reset # hide shell prompt
tput civis # hide cursor
while [ $secs -gt 0 ]; do
   echo -ne "$secs\033[0K\r"
   sleep 1
   : $((secs--))
done
tput bel # bel sound
tput cnorm #restore cursor
