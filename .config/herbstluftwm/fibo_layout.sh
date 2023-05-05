#!/usr/bin/env bash

# usage: start this script in anywhere your autostart (but *after* the
# emit_hook reload line)

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}
tag=0
tname=$(hc attr tags.$tag.name)
hc watch tags.$tag.client_count
algo=(horizontal vertical)
hc --idle '(attribute_changed|reload)' |
{
    while read line; do
       IFS=$'\t' read -ra args <<< "$line"
	  if [[ "${args[1]}" = "tags.$tag.client_count" ]]; then
		clients=($(hc list_clients --tag="$tname" --tiling))
		ratio=($(hc dump | /usr/share/doc/herbstluftwm/examples/dumpbeautify.sh | grep "split" | cut -d ':' -f 2) "0.448")
		layout="" # Resetting
		j=0
		k=0
		for ((i = 0; i < ${#clients[@]}-1; ++i)); do
			layout+="(split ${algo[$j]}:${ratio[$k]}:1 (clients ${algo[$j]}:0 ${clients[i]})"
			if [[ $j = 0 ]]; then j=1; else j=0; fi
			((k+=1))
		done
		
		layout+="(clients ${algo[$j]}:0 ${clients[-1]})"
		for ((i = 0; i < ${#clients[@]}-1; ++i)); do layout+=")"; done
		
		hc load "$tname" "$layout"
	  elif [[ "${args[0]}" = "reload" ]]; then
       	exit 1
	  fi
    done
}
