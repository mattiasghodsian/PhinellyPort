# PhinellyPort
<p>
    <a href="https://etherscan.io/address/0xBBB96204E45D11C9799c6B12E6eE6F0d4A071Ef5" target="_new"><img src="https://img.shields.io/badge/Donate%20Coffee-ETH-blue?style=for-the-badge&amp;logo=ethereum" alt="Donate Coffee"></a>
    <a href="https://github.com/mattiasghodsian/PhinellyPort/stargazers" target="_new"><img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/mattiasghodsian/PhinellyPort?style=for-the-badge&logo=github&label=Stars&color=blue"></a>
    <a href="https://github.com/mattiasghodsian/PhinellyPort/network/members" target="_new"><img alt="GitHub forks" src="https://img.shields.io/github/forks/mattiasghodsian/PhinellyPort?style=for-the-badge&logo=github&label=Forks&color=blue"></a>

</p>

<p>⚠️ Please note the scripts are far from perfect, and some manual effort is required to import.</center>

PhinellyPort is a collection of tools designed to enhance your media library experience, by offering playlist generation, duplicate file removal outside of Jellyfin media server, and seamless integration with Jellyfin through its API for importing playlists.

## How to
Generating temporary m3u8 files from a directory that contains audio files. The generated m3u8 files will be saved in the terminal's current working directory.

### For Directories with Subdirectories
Use the following command for generating m3u8 files from a directory that includes subdirectories:
```sh
./directories_to_playlists.sh [music_folder]
```
### For a Single Directory
Use the following command for generating an m3u8 file from a single directory:
```sh
./generate_playlist.sh [music_folder] [playlist_name] [optional: new_base_path]
```
### Eliminate Duplicate Audio Files
To remove duplicate audio files within a directory that includes subdirectories, use the following command. The action options available are "delete," "dry," and "cancel." When specifying the file format, do not include a dot in the string (e.g., "mp3").
```sh
./duplicate_cleaner.sh [folder_path] [file_format] [action]
```

### Import Playlist to Jellyfin
To import a playlist to Jellyfin, you first need to ensure that the playlist exists.

- Create empty playlist using [Sonixd](https://github.com/jeffvli/sonixd).
- Navigate to Jellyfin's music section, then go to the Playlist tab and click on the new empty playlist. In the URL, locate the playlist ID, which should appear like this: id=5197ca8074c325d7e5882b0b1b2f0545.
- Obtain your user ID by visiting your profile. Click your avatar in the top-right corner and select "Profile." In the URL, look for userId=f1c88706d5164400b2ab94a865be072.
- Generate a new API Key by going to Administration > API Keys in the Admin panel.

Run the following command to import the playlist:
```sh
./jellyfin_playlist.sh <input_file> <playlist_id> <host> <userid> <apikey>
```
Example
```sh
./jellyfin_playlist_import.sh Rock.m3u8 5197ca8074c325d7e5882b0b1b2f0545 example.com f1c88706d5164400b2ab94a865be072 0050cbe10cf149e000dd8b18c623c780
```