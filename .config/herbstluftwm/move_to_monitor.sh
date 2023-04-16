#! /bin/bash

hc=herbstclient
count=$($hc get_attr monitors.count)

if [[ $count == 2 ]]; then
	focused=$($hc get_attr monitors.focus.index)
	if [[ $focused == 1 ]]; then
		$hc shift_to_monitor 0
	else 
		$hc shift_to_monitor 1
	fi
else 
	$hc shift_to_monitor 2
fi
