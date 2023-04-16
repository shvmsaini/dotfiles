#! /bin/bash

hc=herbstclient

tag1="umm"
tag2="ok..."
count=$($hc get_attr tags.count)

if [ $count -gt 9 ]; then 
	$hc chain . focus_monitor 0 . use "$(cat /tmp/prevtag1)"
	$hc chain . focus_monitor 1 . use "$(cat /tmp/prevtag2)"
	$hc merge_tag $tag1 1
	$hc merge_tag $tag2 2
else 
	# Storing focused tags on respective monitors
	echo $($hc get_attr monitors.0.tag) > /tmp/prevtag1
	echo $($hc get_attr monitors.1.tag) > /tmp/prevtag2
	$hc add $tag1
	$hc add $tag2
	$hc chain . focus_monitor 0 . use "umm"
	$hc chain . focus_monitor 1 . use "ok..."
fi 
