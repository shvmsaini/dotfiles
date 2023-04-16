#!/usr/bin/env bash

# usage: start this script in anywhere your autostart (but *after* the
# emit_hook reload line)

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}
tag=$(hc attr tags.focus.index)
tname=$(hc attr tags.$tag.name)
	
clients=($(hc list_clients --tag=$tname --tiling))

# Resetting
j=0
algo=(horizontal vertical)
for ((i = 0; i < ${#clients[@]}-1; ++i)); do
	layout+="(split ${algo[$j]}:0.5:1 (clients ${algo[$j]}:0 ${clients[i]})"
	if [[ $j = 0 ]]; then j=1; else j=0; fi
done

layout+="(clients ${algo[$j]}:0 ${clients[-1]})"
  
for ((i = 0; i < ${#clients[@]}-1; ++i)); do
	layout+=")"; 
done

# echo $layout 

hc load "$(echo "$layout")"
