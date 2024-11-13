#!/bin/bash

# Function to check microphone status
check_mic_status() {
    #local status=$(pactl list sources | grep -A 15 "Source #1166" | grep "Mute" | awk '{print $2}')
    local status=$(pactl list sources | grep -A 15 "Lenovo" | grep "Mute" | awk '{print $2}')
    if [ "$status" == "yes" ]; then
        echo "Muted"
    else
        echo "Unmuted"
    fi
}

# Function to mute the microphone
mute_mic() {
    pactl set-source-mute @DEFAULT_SOURCE@ 1
    echo "Microphone has been muted."
}

# Function to unmute the microphone
unmute_mic() {
    pactl set-source-mute @DEFAULT_SOURCE@ 0
    echo "Microphone has been unmuted."
}

toggle() {
  status=$(check_mic_status)
  if [ "$status" == "Muted" ]; then
    unmute_mic
  else
    mute_mic
  fi
}

# Main script logic
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 [status|mute|unmute]"
    exit 1
fi

case "$1" in
    status)
        check_mic_status
        ;;
    mute)
        mute_mic
        ;;
    unmute)
        unmute_mic
        ;;
    toggle)
        toggle
        ;;
    *)
        echo "Invalid argument. Use 'status', 'mute', or 'unmute'."
        exit 1
        ;;
esac

