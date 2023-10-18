#!/bin/bash

# you can start the container using this script directly with 3 parameters: [IMAGE_NAME] [PORT_TO_RUN_ON] [WORKSPACE],
# e.g. "./start_container.sh cfprot/knime:3.5.3c 5901 test" where
#     "cfprot/knime:latest" points to the latest docker image version (replace 'latest' by any older image version, e.g. 3.7.2a)
#     "5901" specifies the port on which the container will be accesible for VNC connection
#     "test" is the folder within workspaces folder (see "volume_remote_location" below)
# order of parameters must be kept (we don't support switches...)
#
# alternatively just run the script file itself and provide it with the parameters it requests


######################################################
### settings to be adjusted on the given PC/server ###
######################################################


# folder containing subfolder you want to mount as your KNIME workspace folder (e.g. "/home/user_name/knime-workspaces/")
folder_with_workspaces="/media/copy/712006-Proteomics/KNIME_workspaces/"
# timezone in which the container will run
timezone="Europe/Prague"


# default settings for the container start you may modify in case you do not want to specify them frequently on the container start
default_image_name="cfprot/knime:latest"
default_port=5901
default_workspace="knime-workspace"
default_vnc_password=knime


#######################################
### END OF THE SCRIPT SETTINGS PART ###
#######################################


volume_mount_point="/home/knimeuser/knime-workspace"
image_name=""

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
 echo "Which port should the container run on? (e.g. 5901; leave blank to use '$default_port')"
 read port
 if [ -z "$port" ];then
  port=$default_port
 fi
else
 port=$2
fi


# todo folder name + check for existence
if (($# < 3 ));then
 echo "Name of the workspace to use (leave blank to use '$default_workspace'): "
 read workspace
 if [ -z "$workspace" ];then
  workspace=$default_workspace
 fi
else
 workspace=$3
fi

if [ ! -d $folder_with_workspaces$workspace ];then
echo "$folder_with_workspaces$workspace directory not found"
exit 1
fi

CONTAINER_NAME="knime$port"

# checks for the presence of exited container with the name identical to the one to be created and removes it if exists
CID=$(docker ps -q -f status=exited -f name=^/${CONTAINER_NAME}$)
if [ ! "${CID}" ]; then
  echo "Exited container with the name '$CONTAINER_NAME' doesn't exist, will be created now."
else
  echo "Exited container with the name '$CONTAINER_NAME' exists already, will try to remove it for you and will be recreated."
  docker rm $CONTAINER_NAME
fi
unset CID

docker run -it --shm-size=1g --name knime$port -p $port:5901 -v $folder_with_workspaces$workspace:$volume_mount_point -e CONTAINER_TIMEZONE=$timezone -e TZ=$timezone -e VNCPASSWORD=$default_vnc_password $image_name
