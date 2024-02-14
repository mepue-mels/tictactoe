#! /bin/bash

copy_file=$1
copy_directory=$2

current_date=$(date +"%Y-%m-%d %H:%M:%S")

while getopts ":hdwm" opt; do
    case $opt in
        h)
            #target_date = $(date -d "$current_date + 1 hour" + "%Y-%m-%d %H:%M:%S")
            echo "h"
            ;;
        d)
            target_date = $(date -d "$current_date + 1 day" + "%Y-%m-%d %H:%M:%S")
            ;;
        w)
            target_date = $(date -d "$current_date + 1 week" + "%Y-%m-%d %H:%M:%S")
            ;;
        m)
            target_date = $(date -d "$current_date + 1 month" + "%Y-%m-%d %H:%M:%S")
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            ;;
    esac
done
