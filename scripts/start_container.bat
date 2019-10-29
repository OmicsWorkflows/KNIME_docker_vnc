@echo off
@SETLOCAL EnableDelayedExpansion
:: you can start the container running this script in the commandline directly with 3 parameters: [IMAGE_NAME] [PORT_TO_RUN_ON] [WORKSPACE],
:: e.g. ".\start_container.bat cfprot/knime:latest 5901 test" where
::     "cfprot/knime:latest" points to the latest docker image version (replace 'latest' by any older image version, e.g. 3.7.2a)
::     "5901" specifies the port on which the container will be accesible for VNC connection
::     "test" is the folder within workspaces folder (see "volume_remote_location" below)
:: order of parameters must be kept (we don't support switches...)
::
:: alternatively just run the script file itself and provide it with the parameters it requests



:: folder containing subfolder you want to mount as your KNIME workspace folder (e.g. "D:\knime-workspaces\")
set folder_with_workspaces=D:\knime-workspaces\
set timezone="Europe/Prague"

:: default docker image version to be used
set default_image_name=cfprot/knime:latest

:: END OF SETTINGS PART OF THE SCRIPT


:: folder inside the container where volume will be mounted, do not change
set volume_mount_point=/home/knimeuser/knime-workspace

if "%~1"=="" (
    set /P image_name_input="Please provide docker image name (leave empty for cfprot/knime:latest): "
    if "!image_name_input!" == "" (
        set image_name=%default_image_name%
    ) else (
        set image_name=!image_name_input!
    )
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

call :joinpath %folder_with_workspaces% %workspace%

docker run -it --name knime%port% -p %port%:5901 -v %workspace_path%:%volume_mount_point% -e CONTAINER_TIMEZONE=%timezone% -e TZ=%timezone% --rm %image_name%

:: joins folder_with_workspaces and workspace varibles into a absolute path in more robust way
:joinpath
set Path1=%~1
set Path2=%~2
if {%Path1:~-1,1%}=={\} (set workspace_path=%Path1%%Path2%) else (set workspace_path=%Path1%\%Path2%)
goto :eof