#!/usr/bin/env sh

FILE_NAME='data.txt'
CURRENT_TIME=$( date | awk '{print $4}' )

if [ -f "$FILE_NAME" ]; then
    while IFS= read -r line; do
        echo "Task: $line"
        if IFS= read -r next_line; then
            echo "Time: $next_line"
        fi
    done < "$FILE_NAME"
else
    echo "FILE NOT FOUND"
fi
