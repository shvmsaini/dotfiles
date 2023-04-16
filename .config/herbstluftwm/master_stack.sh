#!/usr/bin/env bash

# This script emulates master and stack layout 
# Problem: Glitch like behavior when new client is opened on master frame
# Solution: Don't spawn on master frame :/
# usage: start this script in anywhere your autostart (but *after* the
# emit_hook reload line)

hc() { "${herbstclient_command[@]:-herbstclient}" "$@"; }
tag=3
hc watch tags.$tag.client_count
hc keybind Mod4+Control+s emit_hook swap$tag
ratio=0.5

tname=$(hc attr tags.$tag.name)
hc --idle "attribute_changed|reload|swap$tag" |
    {
        while read line; do
            IFS=$'\t' read -ra args <<<"$line"

            swap=$(if [[ "${args[0]}" = "swap$tag" ]]; then echo 1; else echo 0; fi)
            clientch=$(if [[ "${args[1]}" = "tags.$tag.client_count" && "${args[3]}" -gt 1 ]]; then echo 1; else echo 0; fi)
		  newcstate=$(hc attr clients.focus.floating)

            if [[ ( $swap = 1 || $clientch = 1 ) && $newcstate = false ]]; then
                clients=($(hc list_clients --tag=$tname --tiling))
                fclient=$(hc attr clients.focus.winid)
                s=$(hc attr clients.$fclient.parent_frame.selection)
                if [[ $(hc attr tags.focus.frame_count) -gt 1 ]]; then
                    ratio=$(hc dump | cut -d " " -f 2 | cut -d ":" -f 2)
                fi

                if [[ $swap = "1" ]]; then
                    # Focused client should not be master
                    if [ $fclient = ${clients[0]} ]; then continue; fi
                    # Swapping master and focused client
                    clients[(($s + 1))]=${clients[0]}
                    clients[0]=$fclient
                    hc load $tagname "$(echo "(split horizontal:$ratio:1 (clients horizontal:0 ${clients[0]}) (clients vertical:$s ${clients[@]:1}))")"
                    hc jumpto ${clients[0]}
                elif [[ $clientch = "1" ]]; then
                    hc load $tagname "$(echo "(split horizontal:$ratio:1 (clients horizontal:0 ${clients[0]}) (clients vertical:0 ${clients[@]:1}))")"
                    hc jumpto $fclient
                fi
            elif [ "${args[0]}" = "reload" ]; then
                exit 1
            fi
        done
    }
