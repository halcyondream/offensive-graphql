#!/bin/sh

docker image rm offensive-graphql
docker image rm offensive-graphql-commix

docker build -t offensive-graphql .

if [ "$1" == "--build-commix" ]; then
    docker build -t offensive-graphql-commix -f Dockerfile_commix .
fi