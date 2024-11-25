#!/bin/bash

# set -eux
set -eux

descriptor=$1


# get the name of the image from the folder name
echo "Building image in folder: $descriptor"

# read image.yaml file using yq and get the top level `name` keys value
name=$(yq -r '.name' "$descriptor/image.yaml")

# Get the current branch name
branch=$(git rev-parse --abbrev-ref HEAD)


# Check if the branch is not main or a tag
if [[ "$branch" != "main" && -z "$(git tag --contains HEAD)" ]]; then
    # Get the Git commit hash
    version=$(git rev-parse --short HEAD)
    # Retag the image
    docker tag $name:latest $name:$version
else
    # Get the version from image.yaml
    version=$(yq -r '.version' "$descriptor/image.yaml")
fi

# print the version and name of the image
echo "Version: $version"
echo "Name: $name"

docker push $name:$version