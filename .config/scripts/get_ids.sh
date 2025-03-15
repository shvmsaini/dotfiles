#!/bin/bash

# File to process
file_path="$1"

# Check if file exists
if [ ! -f "$file_path" ]; then
  echo "Error: File '$file_path' not found."
  exit 1
fi

# Print file content and pipe to rofi
selected_item=$(cat "$file_path" | rofi -dmenu -i -p "Select:")

# Copy selected item to clipboard
if [ "$selected_item" != "" ]; then
  echo "$selected_item" | xclip -selection clipboard
  echo "Copied '$selected_item' to clipboard."
fi

