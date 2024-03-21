#!/bin/bash

# Name: PhinellyPort
# Author: Mattias Ghodsian
# License: MIT License
# Url: https://github.com/mattiasghodsian/PhinellyPort

source header.sh

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <youtube_video_link>"
    exit 1
fi

# Yellow color escape sequence
yellow='\033[1;33m'
# Reset color escape sequence
reset='\033[0m'

echo -e "${yellow}Downloading copyrighted content without proper authorization is illegal in most countries and not endorsed.${reset}"
echo -e "${yellow}This script is intended for educational purposes only. Please ensure you have the right to download and use the content.${reset}"

if ! command -v youtube-dl &> /dev/null; then
    echo "Error: youtube-dl is not installed. Please install youtube-dl."
    exit 1
fi

if ! command -v ffprobe &> /dev/null; then
    echo "Error: ffprobe is not installed. Please install FFmpeg."
    exit 1
fi

# Get video title
title=$(youtube-dl --get-title "$1")

# Download video
youtube-dl -f bestvideo+bestaudio -o "$title.%(ext)s" "$1"

# Convert to MP3
ffmpeg -i "$title".* -b:a 320k "${title}.mp3"

# Clean up temporary files and exlude mp3
find . -maxdepth 1 -type f -name "$title.*" ! -name "*.mp3" -delete