#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage $0 <source image dir> <destination image dir>"
    exit 0
fi

src="$1"
dst="$2"

if [[ ! -d $src ]]; then
    echo "Source $src not a directory"
    exit 1
fi
if [[ ! -d $dst ]]; then
    echo "Destination $dst not a directory"
    exit 1
fi

for filename in $src/*; do
    base=$(basename "$filename")
    dstfile="$dst/${base%.*}.bmp"
    width=$(identify -format "%w" "$filename")> /dev/null
    height=$(identify -format "%h" "$filename")> /dev/null
    rot=90
    if [ $height -gt $width ]; then
        rot=0
    fi

    echo "Converting ==> $filename  ($width x $height) to $dstfile ($rot)"
    convert $filename -rotate $rot -format bmp -geometry 240x -gravity Center -extent 240x320 $dstfile

done

