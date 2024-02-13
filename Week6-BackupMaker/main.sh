#!/usr/bin/env sh

file_type=""

condition=""

while getopts ":t:" option; do
    case $option in
        t)
            file_type=$OPTARG
            ;;
        \?)
            echo "Invalid option!"
            exit;;
    esac
done

case $file_type in
    file)
        echo "File detected."
        ;;
    dir)
        echo "Directory detected."
        ;;
    *)
        echo "Error."
        ;;
esac
