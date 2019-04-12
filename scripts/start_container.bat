@echo off
:: you can start the container running this script in the commandline directly with 3 parameters: [IMAGE_NAME] [PORT_TO_RUN_ON] [WORKSPACE],
:: e.g. ".\start_container.bat cfprot/knime:3.5.3c 5901 test" where
::     "cfprot/knime:3.5.3c" points to a concrete docker image version
::     "5901" specifies the port on which the container will be accesible for VNC connection
::     "test" is the folder within workspaces folder (see "volume_remote_location" below)
:: order of parameters must be kept (we don't support switches...)
::
:: alternatively just run the script file itself and provide it with the parameters it requests



:: folder containing subfolder you want to mount as your KNIME workspace folder (it must end with the "\", e.g. "D:\knime-workspaces\")
set volume_remote_location=D:\knime-workspaces\
set timezone="Europe/Prague"



:: END OF SETTINGS PART OF THE SCRIPT

:: folder inside the container where volume will be mounted, do not change
set volume_mount_point="/home/knimeuser/knime-workspace"

if "%~1"=="" (
    set /P image_name="Please provide docker image name (e.g. cfprot/knime:3.7.1a): "
) else (
    set image_name=%~1
)

if "%~2"=="" (
    set /P port="Which port should the container run on? (e.g. 5901): "
) else (
    set port=%2
)

if "%~3"=="" (
    set /P workspace="Name of the workspace to use: "
) else (
    set workspace=%~3
)

set workspace_path=%volume_remote_location%%workspace%

docker run -it --name knime%port% -p %port%:5901 -v %workspace_path%:%volume_mount_point% -e CONTAINER_TIMEZONE=%timezone% -e TZ=%timezone% --rm %image_name%
