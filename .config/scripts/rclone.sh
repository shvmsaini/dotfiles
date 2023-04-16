# Backup and Sync

rclone sync -P /mnt/forlinuxuse/Graphs/Notes un-goog:Notes/ --backup-dir "un-goog:Backup/Notes/"`date -I`

rclone sync -P /mnt/forlinuxuse/Graphs/Personal un-goog:PersonalNotes/ --backup-dir "un-goog:Backup/Personal/"`date -I`
