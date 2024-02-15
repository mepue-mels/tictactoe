#!/bin/bash

#executioner script
#must be executed with external daemon

current_date=$(date +%s)
last_targdate=$(cat targdate)
state=$(cat state)

function Copy() {
    local file="$1"
    local destination="$2"

    cp $file "$destination/"

    echo "$file to $destination | $(date)" >> log
}

if [ $state -eq 0 ]; then
    while getopts ":hdwm" opt; do
        case $opt in
            h) #hourly
                target_date=$(date -v+2S +%s)
                ;;
            d) #daily
                target_date=$(date -v+1d +%s)
                ;;
            w) #weekly
                target_date=$(date -v+1w +%s)
                ;;
            m) #monthly adjustment
                target_date=$(date -v+1m +%s)
                ;;
            :)
                echo "Option -$OPTARG requires an argument." >&2
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                ;;
        esac
    done
    shift $((OPTIND - 1))  # Shift command line arguments to skip processed options

    Copy "$1" "$2"

    echo "$target_date" >| targdate
    sed -i '' 's/1/0/g' state

elif [ $state -eq 1 ]; then
    while [ 1 ]; do
        if [ $current_date -gt $last_targdate ]; then
            Copy "$1" "$2"
            sed -i '' 's/0/1/g' state
            echo 0 >| state
            break
        fi
        current_date=$(date +%s)
    done
fi
