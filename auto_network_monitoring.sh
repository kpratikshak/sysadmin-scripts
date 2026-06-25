#!/bin/bash

set -u

TARGET="8.8.8.8"
LOGFILE="/var/log/network-monitor.log"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

if ping -c 1 -W 3 "$TARGET" >/dev/null 2>&1; then
    echo "$TIMESTAMP OK - Network reachable" >> "$LOGFILE"
else
    echo "$TIMESTAMP CRITICAL - Network unreachable" >> "$LOGFILE"
fi
