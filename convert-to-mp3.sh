#!/bin/bash

if ! command -v ffmpeg &> /dev/null
then
    echo "ffmpeg is not installed"
    exit
fi

file=$1
name=${file%%.*}
ffmpeg -i $file "$name.mp3"