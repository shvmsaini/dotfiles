#! /bin/sh

# Function to handle shutdown
shutdown_action() {
    zenity --question --text="Are you sure, proceed to shutdown?"
    if [ $? = 0 ]; then
        systemctl poweroff
    else
        exit
    fi
}

# Function to handle reboot
reboot_action() {
    zenity --question --text="Are you sure, proceed to reboot?"
    if [ $? = 0 ]; then
        systemctl reboot
    else
        exit
    fi
}

# Function to handle sleep
sleep_action() {
    zenity --question --text="Are you sure, proceed to sleep?"
    if [ $? = 0 ]; then
        systemctl suspend
    else
        exit
    fi
}

# Check for command-line argument
if [ $# -eq 1 ]; then
    case "$1" in
        "shutdown") shutdown_action ;;
        "reboot") reboot_action ;;
        "sleep") sleep_action ;;
        *) echo "Invalid action. Use 'shutdown', 'reboot', or 'sleep'." && exit 1 ;;
    esac
else
    # Main menu using rofi
    chosen=$(printf "Shutdown\nReboot\nSleep" | rofi -dmenu -i)

    case "$chosen" in
        "Shutdown") shutdown_action ;;
        "Reboot") reboot_action ;;
        "Sleep") sleep_action ;;
        *) exit 1 ;;
    esac
fi

