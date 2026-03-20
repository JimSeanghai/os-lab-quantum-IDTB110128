#!/bin/bash

# 1. Interactive Prompt
echo "--- Secure Drop Zone Generator ---"
read -p "Enter the name for the new drop zone folder: " FOLDER_NAME

# 2. Directory Setup
# Check if it already exists to avoid errors
if [ -d "$FOLDER_NAME" ]; then
    echo "Error: Directory '$FOLDER_NAME' already exists."
    exit 1
fi

mkdir "$FOLDER_NAME"
echo "Directory '$FOLDER_NAME' created."

# 3. The Sticky Bit Puzzle (Permissions)
# We give others write and execute (o+wx) so they can enter and upload.
# We add '+t' (The Sticky Bit) so they can't delete YOUR files.
chmod 777 "$FOLDER_NAME"
chmod +t "$FOLDER_NAME"

echo "Permissions set: Sticky Bit (+t) applied."
ls -ld "$FOLDER_NAME"
