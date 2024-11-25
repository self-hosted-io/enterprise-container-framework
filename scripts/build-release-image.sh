#!/bin/bash

# set -eux
set -eux

descriptor=$1


# get the name of the image from the folder name
echo "Building image in folder: $descriptor"

# read image.yaml file using yq and get the top level `name` keys value
name=$(yq -r '.name' "$descriptor/image.yaml")
version=$(yq -r '.version' "$descriptor/image.yaml")

# print the version and name of the image
echo "Version: $version"
echo "Name: $name"

cekit --descriptor $descriptor/image.yaml -v build docker

cekit --descriptor $descriptor/image.yaml test behave

#docker push $name:$version