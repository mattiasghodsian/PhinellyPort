#!/bin/bash

# Name: PhinellyPort
# Author: Mattias Ghodsian
# License: MIT License
# Url: https://github.com/mattiasghodsian/PhinellyPort

source header.sh

# Usage: ./jellyfin_playlist_import.sh <input_file> <playlist_id> <host> <userid> <apikey>
if [ "$#" -ne 5 ]; then
    echo "Usage: ./jellyfin_playlist.sh <input_file> <playlist_id> <host> <userid> <apikey>"
    exit 1
fi

input_file="$1"
playlist_id="$2"
host="$3"
userid="$4"
apikey="$5"

track_query_url="https://${host}/Items?UserId=${userid}&format=json&api_key=${apikey}&Recursive=true&IncludeItemTypes=Audio%2CMusicAlbum%2CMusicArtist&SearchTerm="
playlist_url="https://${host}/Playlists/${playlist_id}/Items?UserId=${userid}&api_key=${apikey}"

urlencode() {
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}

# Check if the playlist exists
playlist_status=$(curl -s -o /dev/null -w "%{http_code}" "${playlist_url}")

if [ "${playlist_status}" -eq 200 ]; then

    item_ids=()

    while IFS= read -r media_file; do
        if [[ "$media_file" != \#* ]]; then
            media_file_fullpath="$media_file"
            media_file=$(basename "$media_file")
            media_file_name="${media_file%.*}"
            media_track_name=$(echo "${media_file_name}" | cut -d '-' -f 2- | awk '{$1=$1};1')

            encoded_media_track_name=$(urlencode "${media_track_name}")

            track_url="${track_query_url}${encoded_media_track_name}"
            track_response=$(curl -s "${track_url}")

            total_record_count=$(echo "${track_response}" | jq -r '.TotalRecordCount')

            if [ "${total_record_count}" -gt 0 ]; then
                item_id=$(echo "${track_response}" | jq -r '.Items[0].Id')
                item_ids+=("${item_id}")
            else
                echo "Error: Failed to fetch track details for '${media_track_name}'"
            fi
            sleep 0.5
        fi
    done < "$input_file"

    sleep 1

    if [ ${#item_ids[@]} -eq 0 ]; then
        echo "No items were added to the playlist."
    else
        item_ids_string=$(IFS=,; echo "${item_ids[*]}")
        post_url="${playlist_url}&ids=${item_ids_string}"
        curl -s -X POST -H "Content-Type: application/json" -d '{}' "${post_url}" -w "\n%{http_code}\n"

    fi

else
    echo "Playlist not found with ID: ${playlist_id}"
    exit 2
fi
