#!/bin/bash

# Source directory where Snap stores .desktop files
source_dir="/var/lib/snapd/desktop/applications"
# Target directory where symbolic links will be created
target_dir="$HOME/.local/share/applications"

# Ensure the target directory exists
mkdir -p "$target_dir"

# Loop through all .desktop files in the source directory
for desktop_file in "$source_dir"/*.desktop; 
do
  # Get the base name of the .desktop file
  file_name=$(basename "$desktop_file")
  
  # Create a symbolic link in the target directory
  ln -s "$desktop_file" "$target_dir/$file_name"
done

echo "Symbolic links created for all Snap applications."
