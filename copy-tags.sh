#!/bin/bash

if ! command -v eyeD3 &> /dev/null
then
    echo "python-eyed3 is not installed"
    exit
fi

source=$1
dest=$2

mkdir /tmp/_thumbnail_tmp
eyeD3 --encoding utf8 "$source" --write-images /tmp/_thumbnail_tmp

title=$(eyeD3 --encoding utf8 "$source" | grep title | cut -b 8-)
artist=$(eyeD3 --encoding utf8 "$source" | grep artist | cut -b 9-)
album=$(eyeD3 --encoding utf8 "$source" | grep album | cut -b 8-)
track=$(eyeD3 --encoding utf8 "$source" | grep track | cut -b 8-)
recording_date=$(eyeD3 -v --encoding utf8 "$source" | grep "recording date" | cut -b 17-)

for filename in /tmp/_thumbnail_tmp/*.png; do
    cover=${filename##*/}
    name=${cover%.png}
    if [ $name = "FRONT_COVER" ]; then
        break
    fi
done

if [ $cover = "*.png" ]; then
    echo "Error: coulnd't find any cover image (looking for .png)"
    rm -rf "/tmp/_thumbnail_tmp"
    exit 1
fi  

eyeD3 --encoding utf8 --add-image=/tmp/_thumbnail_tmp/$cover:FRONT_COVER "$dest" --title "$title" --track "$track" --artist "$artist" --album "$album" --recording-date $recording_date

rm -rf "/tmp/_thumbnail_tmp"