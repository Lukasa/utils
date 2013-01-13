#!/bin/bash

###############################################################################
# music_backup.sh
#
# This is a script intended to perform incremental backups of my music to my
# local fileserver. Because it is intended to be run as a cron job, it needs to
# handle the possibility that it may be outside my local network, and to not
# just start sending data to some random machine.
#
# Copyright Cory Benfield (C) 2013
###############################################################################

# Make errors cause us to fail.
set -e

# Some constants.
FILESERVER_IP="192.168.2.8"
FILESERVER_USERNAME="lukasa"
LOCAL_MUSIC_DIR="/Users/Cory/Music/iTunes/"
REMOTE_MUSIC_DIR="/dpool/media/Music/Cory/"
LOG_DIR="/var/log/music_backup.log"

# Log out a date/time message.
DATE_TIME=`date`
echo "Backing up music at $DATE_TIME..." > "$LOG_DIR"

# First, check that there is a machine at the IP we want. If there isn't,
# 'set -e' will kill the script.
echo "Pinging $FILESERVER_IP..." >> "$LOG_DIR"
ping -c 1 -nq "$FILESERVER_IP" > /dev/null 2>&1

# If we got here, there is a machine there. Try to SSH in and run 'whoami'.
# Once again, 'set -e' will kill the script if this fails.
echo "Confirming $FILESERVER_USERNAME exists on remote server..." >> "$LOG_DIR"
ssh "$FILESERVER_USERNAME@$FILESERVER_IP" whoami > /dev/null 2>&1

# If we made it this far, there's a remote box there and we can log in. Given
# that my box requires key-based login, there's an excellent chance that I'm
# talking to the right box. That's good enough for me.
#
# We're going to use rsync to do the backup, and we're going to do it over ssh,
# because we care about security AND about this not taking all day.
echo "Beginning backup..." >> "$LOG_DIR"
rsync -ae ssh --delete \
     "$LOCAL_MUSIC_DIR" \
     "$FILESERVER_USERNAME@$FILESERVER_IP:$REMOTE_MUSIC_DIR" >> "$LOG_DIR" 2>&1
echo "Backup complete" >> "$LOG_DIR"

# Done.
exit 0
