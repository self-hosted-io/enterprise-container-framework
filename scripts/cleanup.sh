#!/bin/bash

# clean up /tmp directory
set +e # disable exit on error due to some files are locked by kernel
rm -rf /tmp/*

# remove any redis images
docker rmi redis

# remove any onboarder images
docker rmi mbern/onboarder:latest

prune_images() {
    # remove any dangling images
    docker image prune -f

    # remove any stopped containers
    docker container prune -f
}

prune_images
