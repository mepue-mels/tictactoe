#!/bin/bash

#Todo
#1. Update date rewrite
#2. Automation daemon

current_date=$(date +%s)
target_date=""
job_file="jobs"
duration_cycle=""

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

    echo $duration_cycle >> jobs
    echo "$date" >> jobs
    echo "cp $file $directory" >> jobs

    echo "Backup scheduled for $file to $directory on $original_date"
}

function Read() {
    echo
    while IFS= read -r cycle && IFS= read -r target_date && IFS= read -r job; do
        if [ "$current_date" -gt "$target_date" ]; then
            # Execute commands stored in variables, if desired
            $cycle 2> /dev/null
            $job

            # Calculate new date (example: adding 1 hour)
            new_date=$(date -v +1S -jf "%s" "$current_date" "+%s")

            echo "$(date), $job, $target_date to $new_date, $cycle" >> log

            # Update target_date in jobs file
            case $cycle in
                h|d|w|m)
                    echo "Targdate=$target_date"
                    echo "NewDate=$new_date"
                    sed -i '' "s/$target_date/$new_date/" jobs
                    ;;
            esac
        fi
    done < "$job_file"
}

function isEmptyArgs() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: $0 [-hdwmc] <file> <directory>"
        exit 1
    fi
}

#this is the mainline routine
while getopts ":hdwmc" opt; do
    case $opt in
        h|d|w|m)
            duration_cycle="$opt"
            isEmptyArgs $2 $3
            target_date=$(date -v+1S +%s)
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
