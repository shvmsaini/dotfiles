#! /bin/bash

hc=herbstclient
tag=$($hc get_attr tags.focus.name)

if [ $1 == "brave" ]; then
	class="Brave-browser"
	spawn="brave --disable-application-cache --media-cache-size=1 --disk-cache-size=1"
elif [ $1 == "tor" ]; then
	class="Tor Browser"
	spawn="torbrowser-launcher"
elif [ $1 == "code" ]; then
	class="code-oss"
	spawn="code"
elif [ $1 == "nemo" ]; then
	class="Nemo"
	spawn="nemo"
elif [ $1 == "bitwarden" ]; then
	class="bitwarden"
	spawn="/mnt/forlinuxuse/bitwarden.appimage"
elif [ $1 == "idea" ]; then
	class="jetbrains-idea-ce"
	spawn="idea"
fi

$hc chain . rule class="$class" maxage=5 tag=$tag . spawn $spawn
