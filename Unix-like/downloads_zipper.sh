#!/bin/bash

# Go to Downloads Folder
cd ~/Downloads

# Iterate over all directories in Downloads
for directory in */; do
  # echo "Directory -> $directory"
  # Get substring of directory name (witout trailing /)
  substring=$(echo $directory | cut -f1 -d "/")

  # check if substring is an allowed substring
  if [[ "$substring" =~ ^(\*|\.|\.\.) ]]
  then
    continue
  fi

  # get the (assumed) name of the dir zip file
  zipfile="${substring}.zip"

  # Compress if no zip file, then delete the old dir
  if [[ -f $zipfile ]]
  then
    :
  else
    zip -r "$zipfile" "$substring"
  fi

  # remove the old directory if zip file now exists
  if [[ -f $zipfile ]]
  then
    echo "Removing dir: $directory"
    rm -r "./$directory"
  fi
done
