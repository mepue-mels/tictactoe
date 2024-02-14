#!/bin/bash

current_date=$(date +%s)
last_targdate=$(cat targdate)
state=$(cat state)

function Copy() {
    echo "wow"
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

        echo $target_date >| targdate
    done

    sed -i '' 's/1/0/g' state

    while [ 1 ]; do
        if [ $current_date -gt $(cat targdate) ]; then
            Copy
            sed -i '' 's/0/1/g' state
            break
        fi
        current_date=$(date +%s)
    done
else
    while [ 1 ]; do
        if [ $current_date -gt $last_targdate ]; then
            Copy
            sed -i '' 's/0/1/g' state
            echo 0 >| state
            break
        fi
        current_date=$(date +%s)
    done
fi
