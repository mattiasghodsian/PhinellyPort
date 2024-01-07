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
    echo "Metadata for $file:"
    ffprobe -v quiet -show_format -show_streams "$file"
}

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <audio_file1> [audio_file2] [audio_file3] ..."
    exit 1
fi

for file in "$@"; do
    if [ -f "$file" ]; then
        get_metadata "$file"
    else
        echo "Error: File '$file' not found."
    fi
done