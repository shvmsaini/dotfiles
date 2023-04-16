#!/usr/bin/env bash

# This script emulates master and stack layout 

hc() { "${herbstclient_command[@]:-herbstclient}" "$@"; }

clients=($(hc list_clients --tiling))

fclient=$(hc attr clients.focus.winid)

hc load "$(echo "(split horizontal:0.5:1 (clients horizontal:0 ${clients[0]}) (clients vertical:0 ${clients[@]:1}))")"

hc jumpto $fclient
