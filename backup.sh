#!/bin/bash
set -uo pipefail

SCRIPT_PATH=$(realpath "$0")
BACKUP_DISK_LABEL="fedora-backup"

if [[ "$#" -ge 1 && "$1" == "--install" ]]; then
    echo "Setup cron schedule" 
    backupCronEntry="0 12 * * 1-5 $SCRIPT_PATH"
    cronEntries=$(crontab -l)
    hasExistingCronEntries=$(("$?" == "1"))

    if echo "$cronEntries" | grep "$backupCronEntry";
    then
        hasBackupCronEntry="1"
    else
        hasBackupCronEntry="0"
    fi

    if [[ $hasExistingCronEntries == "1" && $hasBackupCronEntry == "1" ]]; then
        echo "Backup cron entry $backupCronEntry already installed" 
        exit 0
    fi


    tempfile=$(mktemp "/tmp/backupcron.XXXXXXX") 
    if [[ "$hasExistingCronEntries" == "1" ]]; then
        echo "$cronEntries" >> "$tempfile"
    fi

    echo "$backupCronEntry" >> "$tempfile"
    crontab "$tempfile"
    rm "$tempfile"
    echo "Installed cron entry $backupCronEntry"

    exit 0
fi

if [[ ! -e "/dev/disk/by-label/$BACKUP_DISK_LABEL" ]]; then
    echo "Backup disk $BACKUP_DISK_LABEL not connected, skipping backup!"
    exit 0
fi

rsync -aAXv / --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} /run/media/k3v1n/fedora-backup/thinkpadl470

echo "Backup to $BACKUP_DISK_LABEL finished"
