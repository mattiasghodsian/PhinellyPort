#!/bin/bash

# Name: PhinellyPort
# Author: Mattias Ghodsian
# License: MIT License
# Url: https://github.com/mattiasghodsian/PhinellyPort

source header.sh

if [ $# -ne 3 ]; then
    echo "Usage: $0 <folder_path> <file_format> <action>"
    echo "Action: delete, dry, or cancel"
    exit 1
fi

folder_path="$1"
file_format="$2"
user_choice="$3"

if [ ! -d "$folder_path" ]; then
    echo "Invalid path. Exiting."
    exit 1
fi

find "$folder_path" -type f -iname "*.$file_format" > temp_filelist.txt

awk -F/ '{print $NF}' temp_filelist.txt | sort | uniq -d | while read -r duplicate; do
    echo "Duplicate file: $duplicate"
    grep -F "$duplicate" temp_filelist.txt | while read -r filepath; do
        echo "- $filepath"
    done
    echo ""
done

if [ "$user_choice" == "delete" ] || [ "$user_choice" == "dry" ]; then
    awk -F/ '{print $NF}' temp_filelist.txt | sort | uniq -d | while read -r duplicate; do
        grep -F "$duplicate" temp_filelist.txt | tail -n +2 | while read -r filepath; do
            if [ "$user_choice" == "dry" ]; then
                echo "Dry run: would delete \"$filepath\""
            elif [ "$user_choice" == "delete" ]; then
                echo "Deleting \"$filepath\""
                rm -- "$filepath"
            fi
        done
    done
elif [ "$user_choice" == "cancel" ]; then
    echo "Operation canceled."
else
    echo "Invalid input. Exiting."
fi

rm temp_filelist.txt