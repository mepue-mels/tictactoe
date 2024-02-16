#!/bin/bash

current_date=$(date +%s)
target_date=""
job_file="jobs"

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

function Read() {
    while IFS= read -r target_date && IFS= read -r job; do
        if [ "$current_date" -gt "$target_date" ]; then
            $job
        fi
    done < "$job_file"
}

function isEmptyArgs() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: $0 [-hdwmc] <file> <directory>"
        exit 1
    fi
}

while getopts ":hdwmc" opt; do
    case $opt in
        h|d|w|m)
            isEmptyArgs $2 $3
            target_date=$(date -v+2S +%s)
            Request "$2" "$3" $target_date
            ;;
        c)
            Read
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
