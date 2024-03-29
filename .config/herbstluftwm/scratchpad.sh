#!/usr/bin/env bash

tag="${1:-scratchpad}"
hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}

hc chain , add "$tag" , set_attr tags.by-name."$tag".at_end true

monitor=scratchpad
monitor_index=$(hc get_attr monitors.focus.index)

exists=false
if ! hc add_monitor $2 $tag $monitor 2> /dev/null ; then
    exists=true
else
    # remember which monitor was focused previously
    hc chain \
        , new_attr string monitors.by-name."$monitor".my_prev_focus \
        , substitute M monitors.focus.index \
            set_attr monitors.by-name."$monitor".my_prev_focus M
fi

show() {
    hc lock
    hc raise_monitor "$monitor"
    hc focus_monitor "$monitor"
    hc unlock
    hc lock_tag "$monitor"
}

hide() {
    # if q3terminal still is focused, then focus the previously focused monitor
    # (that mon which was focused when starting q3terminal)
    hc substitute M monitors.by-name."$monitor".my_prev_focus \
        and + compare monitors.focus.name = "$monitor" \
            + focus_monitor M
    hc remove_monitor "$monitor"
}

[ $exists = true ] && hide || show

