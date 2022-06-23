#!/bin/bash

if ! command -v eyeD3 &> /dev/null
then
    echo "python-eyed3 is not installed"
    exit
fi
if ! command -v yt-dlp &> /dev/null
then
    echo "yt-dlp is not installed"
    exit
fi

URL=$1
creator=$(yt-dlp -s -O creator --playlist-end 1 $URL)
album=$(yt-dlp -s -O album --playlist-end 1 $URL)
year=$(yt-dlp -s -O release_year --playlist-end 1 $URL)

mkdir "$year - $album"
cd "$year - $album"

yt-dlp -x --audio-format mp3 -o "%(autonumber+1)02d %(title)s.%(ext)s" "$URL"

yt-dlp --write-thumbnail --skip-download -o "precover.%(ext)s" --playlist-end 1 --convert-thumbnails png "$URL"

convert precover.png -gravity center -crop 1:1 cover.png

for filename in ./*.mp3; do
    title=${filename##*/}
    title=${title%.mp3}
    num=${title%% *}
    title=${title#* }
    eyeD3 --encoding utf8 --add-image=cover.png:FRONT_COVER "$filename" --title "$title" --track "$num" --artist "$creator" --album "$album" --recording-date $year
    # id3v2 -a "$creator" -A "$album" -t "$title"  -T $num -y $year "$filename"
done

rm cover.png precover.png