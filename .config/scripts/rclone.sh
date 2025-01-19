#!/bin/bash

# Backup and Sync few directories

if ! command -v rclone &> /dev/null; then
	echo "Error: Please install rclone to use this script."
	exit 1
fi

rclone sync -P /mnt/forlinuxuse/Graphs/Notes un-goog:Notes/ --backup-dir "un-goog:Backup/Notes/"`date -I`

rclone sync -P /mnt/forlinuxuse/Graphs/Personal un-goog:PersonalNotes/ --backup-dir "un-goog:Backup/Personal/"`date -I`

rclone sync -P /mnt/forlinuxuse/Nothing/Extra/Backups/ un-goog:Extra-Backups/ --backup-dir "un-goog:Backup/Extra-Backups/"`date -I`
