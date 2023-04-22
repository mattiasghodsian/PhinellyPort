#!/bin/bash

# Name: PhinellyPort
# Author: Mattias Ghodsian
# License: MIT License
# Url: https://github.com/mattiasghodsian/PhinellyPort

source header.sh

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Usage: ./generate_playlist.sh [music_folder] [playlist_name] [optional: new_base_path]"
    exit 1
fi

music_folder=$1
playlist_name=$2
new_base_path=$3

if [ ! -d "$music_folder" ]; then
    echo "Error: The specified music_folder does not exist or is not a directory."
    exit 1
fi

playlist_file="${playlist_name}.m3u8"
echo "#EXTM3U" > "$playlist_file"

find "$music_folder" -type f \( -iname "*.mp3" -o -iname "*.wav" \) | while read -r music_file; do
    echo "#EXTINF:-1,$(basename "${music_file%.*}")" >> "$playlist_file"
    if [ -z "$new_base_path" ]; then
        echo "$music_file" >> "$playlist_file"
    else
        new_music_file="${new_base_path%/}/$(basename "$music_file")"
        echo "$new_music_file" >> "$playlist_file"
    fi
done

echo "Playlist generated successfully: $playlist_file"

