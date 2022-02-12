#!/bin/bash

#you can start it directly with 1 parameter: [VERSION]
# it is placed in the main folder because of the build context of docker build - this way it can access files_to_copy/ folder

dockerfile_location="./dockerfiles"

if (($# < 2 ));then
echo "Which dockerfile should be used?"
read dockerfile
echo "Which version of dockerfile should be used?"
read version
else
dockerfile=$1
version=$2
fi

docker build -t $dockerfile:$version -f ${dockerfile_location}/Dockerfile_${dockerfile}_${version} .
