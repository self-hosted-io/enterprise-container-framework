#!/bin/bash

# set -eux
set -eux

# get list of all folders under the images directory
folders=$(ls -d images/*)

# print the list of folders
echo "Building the following folders: $folders\n"

# loop through each folder
for folder in $folders
do
  # get the name of the image from the folder name
  echo "Building image in folder: $folder"
  
  # read image.yaml file using yq and get the top level `name` keys value
  name=$(yq -r '.name' "$folder/image.yaml")
  version=$(yq -r '.version' "$folder/image.yaml")

  # print the version and name of the image
  echo "Version: $version"
  echo "Name: $name"

  cekit --descriptor $folder/image.yaml -v build docker

  cekit --descriptor $folder/image.yaml test behave

  docker push $name:$version
 
done
