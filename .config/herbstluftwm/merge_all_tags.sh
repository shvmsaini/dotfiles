#! /bin/bash

hc=herbstclient

# number of tags
no_tags=$($hc attr tags.count)
default=$($hc attr tags.0.name)
$hc use $default
for (( x = 1; x < no_tags; ++x)); do
	tag_name=$($hc attr tags.$x.name)
	$hc merge_tag $tag_name $default
done
