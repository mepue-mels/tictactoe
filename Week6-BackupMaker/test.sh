#!/bin/bash

target_date=""

function CheckFile() {
    local file="$1"
    local directory="$2"

    if [ ! -f $file ]; then
        echo "$file is not a file or does not exit."
        exit 1;
    fi

    if [ ! -d $directory ]; then
        echo "$directory is not a directory or does not exist."
        exit 1;
    fi
}

function Request() {
    local file="$1"
    local directory="$2"
    local date="$3"
    original_date=$(date -r "$target_date" +"%Y-%m-%d %H:%M:%S")

    CheckFile $file $directory

    echo "$date" >> jobs
    echo "cp $file $directory" >> jobs

    echo "Backup scheduled for $file to $directory on $original_date"
}

if [ -z "$2" ] || [ -z "$3" ]; then
    echo "Usage: $0 [-hdwmc] <file> <directory>"
    exit 1
fi

while getopts ":hdwmc" opt; do
    case $opt in
        h|d|w|m)
            target_date=$(date -v+2S +%s)
            Request "$2" "$3" $target_date
            ;;
        c)
            ;;
        :)
            echo "Option -$OPTARG requires an argument."
            exit 1
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))
