#!/usr/bin/env bash

# Check if the audio file argument is provided
if [ -z "$1" ]; then
  echo "No audo file argument provided."
  echo "Usage: $0 <file>"
  exit 1
fi

# Assign the first positional parameter to a variable
audio_file=$1

# Check if the file exists
if [ ! -f "$audio_file" ]; then
  echo "File not found: $audio_file"
  exit 1
fi

# Check if the file is an audio or video file 
file_info=$(ffmpeg -i "$audio_file" 2>&1)
audio_stream=$(echo "$file_info" | grep -oE 'Audio: [a-zA-Z0-9]+')

if [ -z "$audio_stream" ]; then
  echo "The file does not contain an audio stream: $audio_file"
  exit 1
fi

echo ""
echo "The file contains an audio stream: $audio_file"
echo "Audio stream info: $audio_stream"
echo ""

# Extract the audio stream and segment it
ffmpeg -i "$audio_file" -vn -acodec mp3 -f segment -segment_time 1800 output%02d.mp3
