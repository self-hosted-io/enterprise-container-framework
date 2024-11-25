#!/bin/bash

# set bash exit code to 1 if any command fails
#set -eux

# bash function to get local ip address
# function get_local_ip {
#     if [ -z "$CI" ]; then
#         echo "CI=false, getting local ip address"
#         export LOCAL_IP=$(ip route get 1 | awk '{print $NF;exit}')
#     else
#         echo "CI=true, not setting local ip address"
#     fi
# }

# bash function to check it CI=true, if true, set the following variables
# function check_ci {
#     if [ "$CI" = "true" ]; then
#         echo "CI=true, setting variables"
#         export REDIS_HOST=redis
#         export REDIS_PORT="6379"
#         export GITHUB_REPO_CREATOR_TOKEN="thisisnotarealtoken"
#         printenv | grep REDIS
#     else
#         echo "CI=false, setting local variables"
#         export REDIS_HOST=$LOCAL_IP
#         export REDIS_PORT="6379"
#         export GITHUB_REPO_CREATOR_TOKEN="thisisnotarealtoken"
#         printenv | grep REDIS
#     fi
# }

# check_ci
# get_local_ip


# printf "Building onboarder image with base image: $1\n"
# docker build -f reference_apps/onboarder_github_fastapi/Dockerfile --build-arg BASE_IMAGE=$1 -t mbern/onboarder:latest ./reference_apps/onboarder_github_fastapi

# # kill any existing containers if ci=false or not set
# if [ -z "$CI" ] || [ "$CI" = "false" ]; then
#     printf "Stopping and removing onboarder and redis containers\n"

#     set +e # disable exit on error

#     docker kill onboarder redis
#     docker rm onboarder redis

#     set -eux
# fi

# # run redis if CI=false or not set
# if [ -z "$CI" ] || [ "$CI" = "false" ]; then
#     printf "Running redis container\n"
#     docker run -d --network=host --name redis redis
#     export REDIS_HOST=localhost
#     export REDIS_PORT=6379
# else
#     # Ensure REDIS_HOST and REDIS_PORT are set in CI environment
#     export REDIS_HOST=${REDIS_HOST:-redis}
#     export REDIS_PORT=${REDIS_PORT:-6379}
# fi

# # run onboarder container
# docker run -d --network=host --name onboarder \
# -e REDIS_HOST=$REDIS_HOST \
# -e REDIS_PORT=$REDIS_PORT \
# -e GITHUB_REPO_CREATOR_TOKEN=$GITHUB_REPO_CREATOR_TOKEN \
# mbern/onboarder:latest

# # get onboarder logs
# printf "Getting onboarder logs\n"
# docker logs onboarder


# # use curl to check if onboarder is running, do a curl to the health endpoint, backoff 5s, retry 10 times
# printf "Checking if onboarder is running\n"

# if [ -z "$CI" ] || [ "$CI" = "false" ]; then
#     for i in {1..10}; do
#     curl -s http://10.0.0.24:8080/healthcheck && break
#     sleep 5
#     done
# else
#     for i in {1..10}; do
#     curl -s http://localhost:8080/healthcheck && break
#     sleep 5
#     done
# fi

docker kill onboarder 
docker rm onboarder

docker build -f reference_apps/onboarder_github_fastapi/Dockerfile --build-arg BASE_IMAGE=$1 -t mbern/onboarder:latest ./reference_apps/onboarder_github_fastapi



export DOCKER_NETWORK_ID=$(docker network ls --filter name=github_network --format "{{.ID}}")

set -e
docker run -d -p 8080:8080 --network=$DOCKER_NETWORK_ID --name onboarder \
-e REDIS_HOST=redis \
-e REDIS_PORT=6379 \
-e GITHUB_REPO_CREATOR_TOKEN="testtoken" \
mbern/onboarder:latest

set +e

# Wait for the onboarder container to be ready
printf "Waiting for onboarder container to be ready\n"
for i in {1..60}; do
    if curl -f http://localhost:8080/deepcheck; then
        printf "Onboarder container is ready\n"
        break
    else
        printf "Waiting for onboarder container...\n"
        sleep 2
    fi
done

printf "Running integration tests\n"
cd reference_apps/onboarder_github_fastapi/integration
set -e
pytest -vv
set +e

printf "Stopping and removing onboarder container\n"
docker kill onboarder
docker rm onboarder



