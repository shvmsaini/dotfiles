#!/bin/bash

# Set the idle time limit in milliseconds
IDLE_LIMIT=$((10 * 60 * 1000))
# Set the warning time limit in seconds
WARNING_TIME=60

# Notification ID for overriding
NOTIFY_ID="idle_timeout"

while true; do
    # Get the idle time in milliseconds
    IDLE_TIME=$(xprintidle)

    # Check if the idle time exceeds the limit
    if [ "$IDLE_TIME" -ge "$IDLE_LIMIT" ]; then
        # Start the countdown
        for ((i = WARNING_TIME; i > 0; i--)); do⌛️
            # Notify the user about the impending suspension with remaining time
            content="Your system will suspend in $i seconds. Move your mouse or press a key to cancel. 🔥"
            notify-send -u normal "⌛️ Idle Timeout" $content -h string:x-canonical-private-synchronous:anything -t 1200

            # Sleep for 1 second
            sleep 1
            
            # Check if the user is still idle
            IDLE_TIME=$(xprintidle)
            if [ "$IDLE_TIME" -lt "$IDLE_LIMIT" ]; then
                break
            fi
        done

        # If the user is still idle after the countdown, suspend the system
        if [ "$IDLE_TIME" -ge "$IDLE_LIMIT" ]; then
            systemctl suspend
        fi
    fi

    # Sleep for a minute before checking again
    sleep 60
done

