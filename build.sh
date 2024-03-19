#!/bin/sh

docker image rm blackql-tools
docker image rm blackql-commix

docker image -t blackql-tools .
docker image -t blackql-commix -f Dockerfile_comix .