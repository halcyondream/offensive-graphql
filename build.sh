#!/bin/sh

docker image rm offensive-graphql
docker image rm offensive-graphql-commix

docker image -t offensive-graphql .
docker image -t offensive-graphql-commix -f Dockerfile_comix .