#!/bin/bash

# you can start the container using this script directly with 3 parameters: [IMAGE_NAME] [PORT_TO_RUN_ON] [WORKSPACE],
# e.g. "./start_container.sh knime:3.5.3c 5901 test" where
#     "knime:3.5.3c" points to a concrete docker image version
#     "5901" specifies the port on which the container will be accesible for VNC connection
#     "test" is the folder within workspaces folder (see "volume_remote_location" below)
# order of parameters must be kept (we don't support switches...)



default_image_name="cfprot/knime:latest"
default_workspace=""
# folder containing folder you want to mount as your KNIME workspace folder
volume_remote_location="/media/copy/712006-Proteomics/KNIME_workspaces/"
volume_mount_point="/home/knimeuser/knime-workspace"
image_name=""
timezone="Europe/Prague"

if (($# < 1 ));then
 echo "Please provide docker image name (leave blank to use '$default_image_name')"
 read image_name
 if [ -z "$image_name" ];then
  image_name=$default_image_name
 fi
else
 image_name=$1
fi

if (($# < 2 ));then
 echo "Which port should the container run on?"
 read port
else
 port=$2
fi


# todo folder name + check for existence
if (($# < 3 ));then
 echo "Name of the workspace to use: "
 read workspace
 if [ -z "$workspace" ];then
  workspace=$default_workspace
 fi
else
 workspace=$3
fi

if [ ! -d $volume_remote_location$workspace ];then
echo "$volume_remote_location$workspace directory not found"
exit 1
fi

docker run -it --name knime$port -p $port:5901 -v $volume_remote_location$workspace:$volume_mount_point -e CONTAINER_TIMEZONE=$timezone -e TZ=$timezone $image_name
