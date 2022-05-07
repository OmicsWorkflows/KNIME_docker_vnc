#!/bin/bash

# the script is placed in the main folder because of the build context of docker build - this way it can access files_to_copy/ folder

dockerfile_location="./dockerfiles"

echo "Which dockerfile should be used?"
read dockerfile
echo "Which version of the dockerfile should be used?"
read version

docker build -t $dockerfile:$version -f ${dockerfile_location}/Dockerfile_${dockerfile}_${version} .