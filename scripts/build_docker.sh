#!/bin/bash

#you can start it directly with 1 parameter: [VERSION]
# it is placed in the main folder because of the build context of docker build - this way it can access files_to_copy/ folder

dockerfile_location="./../dockerfiles"

if (($# < 1 ));then
echo "Which version of dockerfile should we use?"
read version
else
version=$1
fi

docker build -t knime:$version -f ${dockerfile_location}/Dockerfile_${version} .
