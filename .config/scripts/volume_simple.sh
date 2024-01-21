amixer get Master | grep "Front Left:" | cut -d' ' -f7 | sed -e "s/\[//g" | sed -e "s/\]//g" | sed -e "s/%//g"
