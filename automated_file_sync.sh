#!/bin/bash

set -euo pipefail

SOURCE="/source/directory/"
DESTINATION="/destination/directory/"
LOGFILE="/var/log/filesync.log"
LOCKFILE="/tmp/filesync.lock"

#
# Prevent multiple executions
#
exec 200>"$LOCKFILE"

flock -n 200 || {
    echo "Another sync process is already running."
    exit 1
}

{
    echo "========================================"
    echo "Sync Started : $(date)"

    rsync \
        -aHAX \
        --delete \
        --stats \
        --human-readable \
        "$SOURCE" \
        "$DESTINATION"

    echo "Sync Finished: $(date)"
} >> "$LOGFILE" 2>&1
