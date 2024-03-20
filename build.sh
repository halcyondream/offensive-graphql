#!/bin/sh

docker image rm offensive-graphql
docker image rm offensive-graphql-commix

docker build -t offensive-graphql .

if [ "$1" == "--all" ]; then
    docker build -t commix -f Dockerfile_commix .
    docker build -t eyewitness -f Dockerfile_eyewitness .
fi