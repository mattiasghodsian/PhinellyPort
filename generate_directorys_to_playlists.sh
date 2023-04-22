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

music_folder="$1"

while IFS= read -r -d '' folder; do
  folder_name=$(basename "$folder")
  folder_name=${folder_name// /_}
  ./generate_playlist.sh "$folder" "$folder_name"
done < <(find "$music_folder" -mindepth 1 -maxdepth 1 -type d -print0)
