#!/bin/bash

# Name: PhinellyPort
# Author: Mattias Ghodsian
# License: MIT License
# Url: https://github.com/mattiasghodsian/PhinellyPort

source header.sh

if ! command -v ffprobe &> /dev/null; then
    echo "Error: ffprobe is not installed. Please install FFmpeg."
    exit 1
fi

get_metadata() {
    file="$1"
    tag_name=${2:-"genre"}
    ffprobe_output=$(ffprobe -v quiet -show_entries format_tags="$tag_name" -of default=noprint_wrappers=1:nokey=1 "$file")
    echo "$ffprobe_output"
}

process_folder() {
    folder="$1"
    tag_name="$2"
    audio_extensions=("mp3" "flac" "wav" "ogg")  # Add more audio extensions as needed

    shopt -s nullglob
    for file in "$folder"/*; do
        if [ -d "$file" ]; then
            process_folder "$file" "$tag_name"
        elif [ -f "$file" ]; then
            # Check if the file is an audio file with a valid extension
            if echo "${audio_extensions[@]}" | grep -q -w "${file##*.}"; then
                tag_value=$(get_metadata "$file" "$tag_name")
                if [ -z "$tag_value" ]; then
                    echo "$tag_name tag is missing in file: $file"
                fi
            fi
        fi
    done
}

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <folder_path> [tag_name]"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Error: The provided path is not a valid folder."
    exit 1
fi

process_folder "$1" "${2:-"genre"}"