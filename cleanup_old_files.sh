#!/bin/sh

# Cleanup old temporary files

MAX_DAYS=30
OWNER_KEEP="root nobody"

#
# Parse options
#
if [ "$1" = "-ok" ]; then
    OWNER_KEEP="$2"
    shift 2
fi

case "$1" in
    [0-9]*)
        MAX_DAYS="$1"
        shift
        ;;
esac

DIRS_TO_CLEAN="${@:-/tmp}"

#
# Build owner exclusion expression
#
OWNER_EXPR=""

for user in $OWNER_KEEP
do
    OWNER_EXPR="$OWNER_EXPR ! -user $user"
done

#
# Process directories
#
for dir in $DIRS_TO_CLEAN
do
    [ -d "$dir" ] || continue

    echo "Cleaning: $dir"

    (
        cd "$dir" || exit 1

        find . -depth \
            ! -type d \
            \( -mtime +"$MAX_DAYS" -o -mtime -0 \) \
            \( \
                \( -atime +"$MAX_DAYS" -a -ctime +5 \) -o \
                \( -ctime +"$MAX_DAYS" -a -atime +5 \) -o \
                -type l \
            \) \
            $OWNER_EXPR \
            -print -delete

        find . -type d \
            -empty \
            -mtime +"$MAX_DAYS" \
            $OWNER_EXPR \
            -print -delete

    ) 2>/dev/null
done

exit 0
