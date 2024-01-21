#!/bin/sh

hc=herbstclient
notify-send -t 1500 "Called Move script"

id=$(hc get_attr clients.focus.winid)

$hc set_attr clients.focus.floating toggle

$hc mousebind Mod1+Button1 move

$hc drag $id move

$hc mouseunbind Mod1+Button1

