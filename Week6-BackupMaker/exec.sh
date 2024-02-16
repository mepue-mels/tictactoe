#! /bin/bash

execfile='find main.sh 2> /dev/null'

if [ -z $execfile ]; then
    echo "File not found!"
    exit 1
fi

while [ 1 ]; do
    ./exec.sh -c
done
