#!/bin/bash

# input version
version=$1

# Build the Docker image
docker build -f Dockerfile -t mbern/onboarder_github_fastapi:$version .

# make docker network
docker network create onboarder_network

# Kill any existing containers
docker kill onboarder redis
docker rm onboarder redis

# run redis
docker run -d --network onboarder_network --name redis redis

# run app server
docker run -d --network onboarder_network --name onboarder -p 8080:8080 \
-e REDIS_HOST=redis \
-e REDIS_PORT=6379 \
-e GITHUB_REPO_CREATOR_TOKEN="thisisnotarealtoken" \
mbern/onboarder_github_fastapi:$version

