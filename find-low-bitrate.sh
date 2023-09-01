#!/bin/bash

# Name: PhinellyPort
# Author: Mattias Ghodsian
# License: MIT License
# Url: https://github.com/mattiasghodsian/PhinellyPort

source header.sh

if [ $# -ne 1 ]; then
  echo "Usage: $0 <music_folder>"
  exit 1
fi

music_folder=$1

find "$music_folder" -type f \( -iname "*.mp3" -o -iname "*.m4a" \) | while read -r file; do
  bitrate=$(ffprobe -v error -select_streams a:0 -show_entries stream=bit_rate -of default=noprint_wrappers=1:nokey=1 "$file")
  bitrate=${bitrate::-3}

  if [ $? -eq 0 ] && [ "$bitrate" -lt 320 ]; then
    echo "----"
    echo "File: $(basename "$file")"
    echo "Path: $(dirname "$file")"
    echo "Bitrate: $bitrate"
    echo "----"
  else
    echo "Error: Unable to retrieve bitrate for $file"
  fi
done
